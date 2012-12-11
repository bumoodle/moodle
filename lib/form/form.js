/**
 * This file contains JS functionality required by mforms and is included automatically
 * when required.
 */

// Namespace for the form bits and bobs
M.form = M.form || {};

/**
 * Move logic for event application formslib to event handler
 * Stores a list of the dependencyManager for each form on the page.
 */
M.form.dependencyManagers = {};

/**
 * Initialises a manager for a forms dependencies.
 * This should happen once per form.
 */
M.form.initFormDependencies = function(Y, formid, dependencies) {

    // If the dependencies isn't an array or object we don't want to
    // know about it
    if (!Y.Lang.isArray(dependencies) && !Y.Lang.isObject(dependencies)) {
        return false;
    }

    /**
     * Fixes an issue with YUI's processing method of form.elements property
     * in Internet Explorer.
     *     http://yuilibrary.com/projects/yui3/ticket/2528030
     */
    Y.Node.ATTRS.elements = {
        getter: function() {
            return Y.all(new Y.Array(this._node.elements, 0, true));
        }
    };

    // Define the dependency manager if it hasn't already been defined.
    M.form.dependencyManager = M.form.dependencyManager || (function(){
        var dependencyManager = function() {
            dependencyManager.superclass.constructor.apply(this, arguments);
        };
        dependencyManager.prototype = {
            _form : null,
            _locks : [],
            _hides : [],
            _dirty : [],
            _nameCollections : null,
            _fileinputs : null,
            initializer : function() {
                this._form = Y.one('#'+formid);

                // Add the relevant handlers here - we check more explicity which handlers to act upon when they're actually triggered
                this._form.delegate(['click', 'blur', 'change'], this.checkDependents, '.hasDependency', this);

                return this.updateAllDependencies();
            },
            checkDependents : function(e) {
                var changed = null,
                dependon,
                elementtype;

                // Grab the element and form
                changed = e.target.ancestor('.hasDependency', true);
                dependon = changed.get('name');
                if (!dependon) {
                    return false;
                }
                this._form = changed.ancestor('form');

                elementtype = changed.get('nodeName').toUpperCase();
                if (elementtype === 'INPUT') {
                    if (changed.getAttribute('type').match(/^(button|submit|radio|checkbox)$/)) {
                      // Only respond to clicks for buttons, submits, radios and checkboxes
                      if (e.type !== "click") {
                          return;
                      }
                    } else if (e.type !== 'blur') {
                      // Only respond to blurs for other input elements
                      return;
                    } else if (changed.getAttribute('type') === 'reset' && e.type === 'click') {
                      // We additionally ensure that we reset the form
                      this._form.reset();
                    }
                } else if (elementtype === 'SELECT' && e.type !== 'click') {
                    // Only respond to clicks for select elements
                    return;
                }

                return this.updateAllDependencies();
            },
            /**
             * Initializes the mapping from element name to YUI NodeList
             */
            initElementsByName : function() {
                var names = [],
                i, condition, value, ei;
                // Collect element names
                for (i in dependencies) {
                    names[i] = new Y.NodeList();
                    for (condition in dependencies[i]) {
                        for (value in dependencies[i][condition]) {
                            for (ei in dependencies[i][condition][value]) {
                                names[dependencies[i][condition][value][ei]] = new Y.NodeList();
                            }
                        }
                    }
                }
                // Locate elements for each name
                this._form.get('elements').each(function(node){
                    var name = node.getAttribute('name');
                    if (names[name]) {
                        names[name].push(node);
                    }
                });
                this._nameCollections = names;
            },
            /**
             * Gets all elements in the form by their name and returns
             * a YUI NodeList
             *
             * @param {string} name The form element name.
             * @return {Y.NodeList}
             */
            elementsByName : function(name) {
                if (!this._nameCollections) {
                    this.initElementsByName();
                }
                if (!this._nameCollections[name]) {
                    return new Y.NodeList();
                }
                return this._nameCollections[name];
            },
            /**
             * Checks the dependencies the form has an makes any changes to the
             * form that are required.
             *
             * Changes are made by functions title _dependency_{dependencytype}
             * and more can easily be introduced by defining further functions.
             *
             * @param {string} name The form element name to check dependencies against.
             * @param {Event | null} e The event, if any.
             */
            checkDependencies : function(dependon, e) {
                var tohide = [],
                    tolock = [],
                    condition, value, lock, hide,
                    checkfunction, result, elements,
                    ei, eltolock,
                    el, needsupdate = false;
                if (!dependencies[dependon]) {
                    return true;
                }
                elements = this.elementsByName(dependon);
                for (condition in dependencies[dependon]) {
                    for (value in dependencies[dependon][condition]) {
                        checkfunction = '_dependency_'+condition;
                        if (Y.Lang.isFunction(this[checkfunction])) {
                            result = this[checkfunction].apply(this, [elements, value, e]);
                        } else {
                            result = this._dependency_default(elements, value, e);
                        }
                        lock = result.lock || false;
                        hide = result.hide || false;
                        for (ei in dependencies[dependon][condition][value]) {
                            eltolock = dependencies[dependon][condition][value][ei];
                            tohide[eltolock] = tohide[eltolock] || hide;
                            tolock[eltolock] = tolock[eltolock] || lock;
                        }
                    }
                }
                for (el in tolock) {
                    needsupdate = false;
                    if (tolock[el]) {
                        this._locks[el] = this._locks[el] || [];
                        if (!this._locks[el][dependon]) {
                            this._locks[el][dependon] = true;
                            needsupdate = true;
                        }
                    } else if (this._locks[el] && this._locks[el][dependon]) {
                        delete this._locks[el][dependon];
                        needsupdate = true;
                    }
                    if (tohide[el]) {
                        this._hides[el] = this._hides[el] || [];
                        if (!this._hides[el][dependon]) {
                            this._hides[el][dependon] = true;
                            needsupdate = true;
                        }
                    } else if (this._hides[el] && this._hides[el][dependon]) {
                        delete this._hides[el][dependon];
                        needsupdate = true;
                    }
                    if (needsupdate) {
                        this._dirty[el] = true;
                    }
                }
                return true;
            },
            /**
             * Update all dependencies in form
             */
            updateAllDependencies : function() {
                for (var el in dependencies) {
                    this.checkDependencies(el, null);
                }
                this.updateForm();
            },
            /**
             * Update dependencies associated with event
             *
             * @param {Event} e The event.
             */
            updateEventDependencies : function(e) {
                var el = e.target.getAttribute('name');
                this.checkDependencies(el, e);
                this.updateForm();
            },
            /**
             * Flush pending changes to the form
             */
            updateForm : function() {
                var el, locked, hidden;
                for (el in this._dirty) {
                    if (this._locks[el]) {
                        locked = !this._isObjectEmpty(this._locks[el]);
                        this._disableElement(el, locked);
                    }
                    if (this._hides[el]) {
                        hidden = !this._isObjectEmpty(this._hides[el]);
                        this._hideElement(el, hidden);
                    }
                }
                this._dirty = [];
            },
            /**
             * Disables or enables all form elements with the given name
             *
             * @param {string} name The form element name.
             * @param {boolean} disabled True to disable, false to enable.
             */
            _disableElement : function(name, disabled) {
                var els = this.elementsByName(name),
                filepicker = this.isFilePicker(name),
                fitem;
                els.each(function(node){
                    if (disabled) {
                        node.setAttribute('disabled', 'disabled');
                    } else {
                        node.removeAttribute('disabled');
                    }

                    // Extra code to disable filepicker or filemanager form elements
                    if (filepicker) {
                        fitem = node.ancestor('.fitem');
                        if (fitem) {
                            if (disabled){
                                fitem.addClass('disabled');
                            } else {
                                fitem.removeClass('disabled');
                            }
                        }
                    }
                });
            },
            /**
             * Hides or shows all form elements with the given name.
             *
             * @param {string} name The form element name.
             * @param {boolean} disabled True to hide, false to show.
             */
            _hideElement : function(name, hidden) {
                var els = this.elementsByName(name);
                els.each(function(node){
                    var e = node.ancestor('.fitem');
                    if (e) {
                        e.setStyles({
                            display : (hidden) ? 'none' : ''
                        });
                    }
                });
            },
            /**
             * Is the form element inside a filepicker or filemanager?
             *
             * @param {string} el The form element name.
             * @return {boolean}
             */
            isFilePicker : function(el) {
                var fileinputs = [],
                els;
                if (!this._fileinputs) {
                    els = this._form.all('.fitem.fitem_ffilepicker input,.fitem.fitem_ffilemanager input');
                    els.each(function(node){
                        fileinputs[node.getAttribute('name')] = true;
                    });
                    this._fileinputs = fileinputs;
                }
                return this._fileinputs[el] || false;
            },
            /**
             * Check if the object is empty
             *
             * @param {object} obj
             * @return {boolean}
             */
            _isObjectEmpty : function(obj) {
                var prop;
                for(prop in obj) {
                    if(obj.hasOwnProperty(prop)) {
                        return false;
                    }
                }
                return true;
            },
            _dependency_notchecked : function(elements, value) {
                var lock = false;
                elements.each(function(){
                    if (this.getAttribute('type').toLowerCase() === 'hidden'
                        && !this.siblings('input[type=checkbox][name="' + this.get('name') + '"]').isEmpty()) {
                        // This is the hidden input that is part of an advcheckbox.
                        return;
                    }
                    if (this.getAttribute('type').toLowerCase() === 'radio' && this.get('value') !== value) {
                        return;
                    }
                    lock = lock || !Y.Node.getDOMNode(this).checked;
                });
                return {
                    lock : lock,
                    hide : false
                };
            },
            _dependency_checked : function(elements, value) {
                var lock = false;
                elements.each(function(){
                    if (this.getAttribute('type').toLowerCase() === 'hidden'
                        && !this.siblings('input[type=checkbox][name="' + this.get('name') + '"]').isEmpty()) {
                        // This is the hidden input that is part of an advcheckbox.
                        return;
                    }
                    if (this.getAttribute('type').toLowerCase() === 'radio' && this.get('value') !== value) {
                        return;
                    }
                    lock = lock || Y.Node.getDOMNode(this).checked;
                });
                return {
                    lock : lock,
                    hide : false
                };
            },
            _dependency_noitemselected : function(elements) {
                var lock = false;
                elements.each(function(){
                    lock = lock || this.get('selectedIndex') === -1;
                });
                return {
                    lock : lock,
                    hide : false
                };
            },
            _dependency_eq : function(elements, value) {
                var lock = false;
                var hidden_val = false;
                var options, v, selected, values;
                elements.each(function(){
                    if (this.getAttribute('type').toLowerCase() === 'radio' && !Y.Node.getDOMNode(this).checked) {
                        return;
                    } else if (this.getAttribute('type').toLowerCase() ===  'hidden'
                        && !this.siblings('input[type=checkbox][name="' + this.get('name') + '"]').isEmpty()) {
                        // This is the hidden input that is part of an advcheckbox.
                        hidden_val = (this.get('value') ===  value);
                        return;
                    } else if (this.getAttribute('type').toLowerCase() ===  'checkbox' && !Y.Node.getDOMNode(this).checked) {
                        lock = lock || hidden_val;
                        return;
                    }
                    if (this.getAttribute('class').toLowerCase() == 'filepickerhidden') {
                        // Check for filepicker status.
                        var elementname = this.getAttribute('name');
                        if (elementname && M.form_filepicker.instances[elementname].fileadded) {
                            lock = false;
                        } else {
                            lock = true;
                        }
                    } else if (this.get('nodeName').toUpperCase() === 'SELECT' && this.get('multiple') === true) {
                        // Multiple selects can have one or more value assigned. A pipe (|) is used as a value separator
                        // when multiple values have to be selected at the same time.
                        values = value.split('|');
                        selected = [];
                        options = this.get('options');
                        options.each(function() {
                            if (this.get('selected')) {
                                selected[selected.length] = this.get('value');
                            }
                        });
                        if (selected.length > 0 && selected.length === values.length) {
                            for (var i in selected) {
                                v = selected[i];
                                if (values.indexOf(v) > -1) {
                                    lock = true;
                                } else {
                                    lock = false;
                                    return;
                                }
                            }
                        } else {
                            lock = false;
                        }
                    } else {
                        lock = lock || this.get('value') ===  value;
                    }
                });
                return {
                    lock : lock,
                    hide : false
                };
            },
            _dependency_hide : function() {
                return {
                    lock : false,
                    hide : true
                };
            },
            _dependency_default : function(elements, value) {
                var lock = false,
                hidden_val = false;
                elements.each(function(){
                    if (this.getAttribute('type').toLowerCase() === 'radio' && !Y.Node.getDOMNode(this).checked) {
                        return;
                    } else if (this.getAttribute('type').toLowerCase() ===  'hidden'
                        && !this.siblings('input[type=checkbox][name="' + this.get('name') + '"]').isEmpty()) {
                        // This is the hidden input that is part of an advcheckbox.
                        hidden_val = (this.get('value') !== value);
                        return;
                    } else if (this.getAttribute('type').toLowerCase() ===  'checkbox' && !Y.Node.getDOMNode(this).checked) {
                        lock = lock || hidden_val;
                        return;
                    }
                    //check for filepicker status
                    if (this.getAttribute('class').toLowerCase() ===  'filepickerhidden') {
                        var elementname = this.getAttribute('name');
                        if (elementname && M.form_filepicker.instances[elementname].fileadded) {
                            lock = true;
                        } else {
                            lock = false;
                        }
                    } else if (this.get('nodeName').toUpperCase() === 'SELECT' && this.get('multiple') === true) {
                        // Multiple selects can have one or more value assigned. A pipe (|) is used as a value separator
                        // when multiple values have to be selected at the same time.
                        values = value.split('|');
                        selected = [];
                        options = this.get('options');
                        options.each(function() {
                            if (this.get('selected')) {
                                selected[selected.length] = this.get('value');
                            }
                        });
                        if (selected.length > 0 && selected.length === values.length) {
                            for (var i in selected) {
                                v = selected[i];
                                if (values.indexOf(v) > -1) {
                                    lock = false;
                                } else {
                                    lock = true;
                                    return;
                                }
                            }
                        } else {
                            lock = true;
                        }
                    } else {
                        lock = lock || this.get('value') !== value;
                    }
                });
                return {
                    lock : lock,
                    hide : false
                };
            }
        };
        Y.extend(dependencyManager, Y.Base, dependencyManager.prototype, {
            NAME : 'mform-dependency-manager'
        });

        return dependencyManager;
    })();

    M.form.dependencyManagers[formid] = new M.form.dependencyManager();
    return M.form.dependencyManagers[formid];
};

/**
 * Update the state of a form. You need to call this after, for example, changing
 * the state of some of the form input elements in your own code, in order that
 * things like the disableIf state of elements can be updated.
 */
M.form.updateFormState = function(formid) {
    if (formid in M.form.dependencyManagers) {
        M.form.dependencyManagers[formid].updateAllDependencies();
    }
};
