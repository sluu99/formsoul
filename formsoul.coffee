class FormSoul

    constructor: (@model, container) ->
        @errors = {}
        @inputElements = {}
        @errorElements = {}

        container = $(container)

        for own key of @model
            elem = container.find('[fs-field='+key+']:first')
            if elem?
                @inputElements[key] = elem
                errorElem = container.find('[fs-error='+key+']:first')
                @errorElements[key] = errorElem if errorElem?


    # Display the errors in the form
    showErrors: () ->
        for own key, errorElem of @errorElements
            inputElem = @inputElements[key]
            if @errors[key]? and @errors[key].length > 0
                errorElem.addClass('fs-error') unless errorElem.hasClass('fs-error')
                errorElem.text(@errors[key])
                inputElem.addClass('fs-error') unless inputElem.hasClass('fs-error')
            else
                errorElem.text('')
                errorElem.removeClass('fs-error')
                inputElem.removeClass('fs-error')


    # Validate and show errors. Pass in false to disable showign errors
    validate: (showErrors=true) ->
        @errors = @model.validate()
        showErrors() if showErrors
        Object.keys(@errors).length is 0


    # Fill the model values into the fields
    fill: () ->
        for own key, elem of @inputElements
            elem.val(@model[key])

    # Gather the field values into the model
    gather: () ->
        for own key, elem of @inputElements
            @model[key] = elem.val()
