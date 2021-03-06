class FormSoul

    # General value function
    # Returns a function for getting/setting with a DOM element
    # elem: the DOM element
    @genericVal = (elem) ->
        (val) -> if val? then elem.val(val) else elem.val()
    @checkboxVal = (elem) ->
        (val) -> if val? then elem.prop('checked', val) else elem.prop('checked')
    @staticVal = (elem) ->
        htmlAttr = elem.attr('fs-html')
        if htmlAttr? and htmlAttr.toLowerCase() is 'true'
            (html) -> if html? then elem.html(html) else elem.html()
        else
            (text) -> if text? then elem.text(text) else elem.text()

    #
    # Class constructor
    constructor: (@model, container) ->
        @errors = {}
        @inputElements = {}
        @errorElements = {}
        @funcs = {} # data functions

        container = $(container)

        for own key of @model
            elem = container.find('[fs-field='+key+']:first')[0]
            if typeof(@model[key]) is 'function' then continue
            if elem?
                @inputElements[key] = $(elem)
                errorElem = container.find('[fs-error='+key+']:first')[0]
                @errorElements[key] = $(errorElem) if errorElem?
                @chooseValFunction(key, @inputElements[key])

        # special error element
        formErrorElem = container.find('[fs-error=_]:first')[0]
        @errorElements['_'] = $(formErrorElem) if formErrorElem?



    #
    # set data function based on element type
    chooseValFunction: (key, elem) ->
        tagName = elem.prop('tagName')

        switch tagName
            when 'DIV','SPAN','P' then @funcs[key] = FormSoul.staticVal(elem)
            when 'INPUT','TEXTAREA','SELECT'
                type = elem.prop('type')
                switch type
                    when 'checkbox' then @funcs[key] = FormSoul.checkboxVal(elem)
                    when 'radio' then throw 'Radio inputs are not supported'
                    else @funcs[key] = FormSoul.genericVal(elem)
            else throw tagName + ' is not supported'



    #
    # Returns true if the form has any validation error. Call formsoul.validate()
    # before calling this function
    hasErrors: () ->
        for own key of @errors
            return true
        return false



    #
    # Display the errors in the form
    showErrors: () ->
        for own key, errorElem of @errorElements
            inputElem = @inputElements[key]
            error = @errors[key]

            if error and error.length > 0
                # determine if error is an array
                if typeof(error) isnt 'string' and Object::toString.call(error) is '[object Array]'
                    error = error[0] # show the first error

                errorElem.addClass('fs-error') unless errorElem.hasClass('fs-error')
                errorElem.text(error)
                unless not(inputElem?) or inputElem.hasClass('fs-error')
                    inputElem.addClass('fs-error')
            else
                errorElem.text('')
                errorElem.removeClass('fs-error')
                inputElem.removeClass('fs-error') if inputElem?



    #
    # Validate and show errors. Pass in false to disable showign errors
    validate: (showErrors=true) ->
        @errors = @model.validate()
        @showErrors() if showErrors
        return @hasErrors() isnt true


    #
    # Fill the model values into the fields
    fill: () ->
        for own key, func of @funcs
            func(@model[key])



    #
    # Gather the field values into the model
    gather: () ->
        for own key, func of @funcs
            @model[key] = func()


window.FormSoul = FormSoul
