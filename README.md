Small JS library for form and model binding (requires jQuery).

Example:

    <div id="formContainer">
      <form onSubmit="return onFormSubmit()">
        <input type="text" fs-field="name">
        <div fs-error="name"></div>
      </form>
    </div>

    <script>
      function FormModel() {
        this.name = '';
      }

      // your model should have a validate function that returns an associative array of errors
      FormModel.prototype.validate = function() {
        if (!this.name) return { 'name': ['Name is required'] };
        return {};
      }

      var model = new FormModel();
      model.name = 'John';

      var fs = new FormSoul(model, '#formContainer');
      fs.fill(); // the input will now be John

      function onFormSubmit() {
        fs.gather();  // get the values from form into model
        return fs.validate(); // this will display the error in the div
        // call fs.validate(false) to not display errors
      }
    </script>
