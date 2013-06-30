/**
 * Create a new form soul with the model and container
 *
 * model: the model object
 * container: containerID or the container DOM
 */
function FormSoul(model, container) {
    $this = this;

    $this.model = model;
    $this.errors = {};
    $this.inputElements = {};
    $this.errorElements = {};
    container = $(container);

    // start the binding
    Object.keys(model).forEach(function (key) {
        var elem = container.find('[fs-field='+key+']:first');
        if (elem) {
            $this.inputElements[key] = elem;

            var errorElem = container.find('[fs-error='+key+']:first');
            if (errorElem) $this.errorElements[key] = errorElem;
        }
    });
}

/**
 * Display errors on the form
 */
FormSoul.prototype.showErrors = function() {
    Object.keys($this.errorElements).forEach(function(key) {
        if (Array.isArray($this.errors[key]) && $this.errors[key].length > 0) {

            if (!$this.inputElements[key].hasClass('fs-error'))
                $this.inputElements[key].addClass('fs-error');

            if (!$this.errorElements[key].hasClass('fs-error'))
                $this.errorElements[key].addClass('fs-error');

            $this.errorElements[key].text($this.errors[key][0]);
        } else {

            $this.errorElements[key].text('');
            $this.inputElements[key].removeClass('fs-error');
            $this.errorElements[key].removeClass('fs-error');
        }
    });
}

/**
 * Validate and show errors. Disable showing error by passing false
 */
FormSoul.prototype.validate = function(showErrors) {

    if (typeof(showErrors) === 'undefined') showErrors = true;
    this.errors = this.model.validate();
    if (showErrors) this.showErrors();

    return Object.keys($this.errors).length < 1;
}

/**
 * Fill the model values into the fields
 */
FormSoul.prototype.fill = function() {
    Object.keys($this.inputElements).forEach(function(key) {
        $this.inputElements[key].val(model[key]);
    });
}

/**
 * Gather the form values in to the model
 */
FormSoul.prototype.gather = function() {
    Object.keys($this.inputElements).forEach(function(key) {
        $this.model[key] = $this.inputElements[key].val();
    });
}