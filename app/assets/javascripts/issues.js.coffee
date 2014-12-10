
$.fn.profile_editor = (options) ->
    $self = $(this)
    search_url = options.search_url
    tmpl_url = options.tmpl_url
    form_prefix = options.form_prefix

    update_ui = () ->
        if $("[name$='[profile_id]']", $self).length > 0
            $(".form-group:has([data-role=profile-searcher])", $self).hide()
            $(".form-group:has([data-role=new-profile-btn])", $self).show()
        else
            $(".form-group:has([data-role=profile-searcher])", $self).show()
            $(".form-group:has([data-role=new-profile-btn])", $self).hide()

    $("[data-role=profile-searcher]", $self)
        .select2
            placeholder: 'Search an exist profile here...',
            minimumInputLength: 1,
            width: '100%',
            ajax: 
                url: search_url,
                dataType: 'json',
                data: (term, page) ->
                    {q: term, p: page}
                results: (data, page) ->
                    {results: data, more: false}

        .bind "update-profile", (e, profile_id) ->
            data = {form_prefix: form_prefix}
            data['id'] = profile_id if profile_id
            $.ajax
                url: tmpl_url,
                data: data,
                dataType: 'html',
                type: 'get',
                success: (html) ->
                    $("[data-role=contents]", $self).html(html);
                    update_ui()
                error: (xhr) ->
                    if xhr.status == 404
                        alert('Profile not found')
                    else
                        alert('Server Error')

        .bind "change", (e) ->
            val = $(this).val()
            $(this).select2 "val", ""
            $(this).trigger "update-profile", [val]

    $("[data-role=new-profile-btn]", $self).bind "click", ->
        $("[data-role=profile-searcher]", $self).trigger "update-profile", []

    update_ui()

$.fn.bundle_finder = (options) ->
    $self = $(this)
    search_url = options.search_url 
    selected = options.selected

    $self
        .select2
            placeholder: 'Search for a bundle...'
            minimumInputLength: 1
            width: '300px'
            ajax:
                url: search_url,
                dataType: 'json',
                data: (term, page) ->
                    {q: term, p: page}
                results: (data, page) ->
                    {results: data, more: false}
        .bind "change", ->
            val = $self.val()
            $self.select2 "val", ""
            selected val

class BundleEditor
    $self = undefined
    
    constructor: (dom, options) ->
        $self = $(dom)
        @form_prefix = options.form_prefix || ""
        @tmpl_url = options.tmpl_url
        
        for e in $("[data-bundle-id]", $self)
            @init_ui $(e)

    add: (bundle_id) ->
        if $("[data-bundle-id=" + bundle_id + "]", $self).length > 0
            alert 'Bundle already exist'
            return

        $.ajax
            url: @tmpl_url,
            data: {id: bundle_id, form_prefix: @form_prefix },
            dataType: 'html',
            type: 'get',
            success: (html) =>
                $self.append @init_ui($(html))
                
                # all_sample_types = $.map $("[data-sample-type]", $(html)), (e) ->
                #     $(e).attr "data-sample-type"
                # sample_types = []
                #
                # for t in all_sample_types
                #     if sample_types.indexOf t == -1
                #         sample_types.push(t)
                #
                # $self.trigger('bundle-added', [sample_types])
                
            error: (xhr) =>
                if xhr.status == 404
                    alert('Bundle not found')
                else
                    alert('Server Error')

    init_ui: ($html) ->
        $("[data-role=delete]", $html).bind "click", =>
            @delete $html.attr "data-bundle-id"
        $("[data-role=restore]", $html).bind "click", =>
            @restore $html.attr "data-bundle-id"
        $html

    delete: (bundle_id) ->
        $b = $("[data-bundle-id=" + bundle_id + "]", $self)
        if $b.attr("data-new") == "true"
            $b.remove()
        else
            $b.addClass("danger")
            $("[data-role=delete]", $b).hide()
            $("[data-role=restore]", $b).show()
            $('[data-role=destroy-flag]', $b).val('true')

    restore: (bundle_id) ->
        $b = $("[data-bundle-id=" + bundle_id + "]", $self)
        $b.removeClass("danger")
        $("[data-role=delete]", $b).show()
        $("[data-role=restore]", $b).hide()
        $('[data-role=destroy-flag]', $b).val('false')
    

$.fn.bundle_editor = (options, values) ->
    if options == 'add'
        for e in this
            e._bundle_editor.add values
    else
        for e in this
            e._bundle_editor = new BundleEditor e, options
        this

class SampleEditor
    $self = undefined
    
    constructor: (dom, options) ->
        $self = $(dom)
        @form_prefix = options.form_prefix
        @tmpl_url = options.tmpl_url
        
        # Bind destroy UI
        for element in $("[data-role=sample]", $self)
            @bind_ui $(element), $(element).hasClass("new")
    
    add: (options) ->
        $.ajax
            url: @tmpl_url
            dataType: 'html'
            data: {form_prefix: @form_prefix}
            type: 'get'
            success: (html) =>
                $html = $(html)
                @bind_ui $html, true
                $self.append $html
                
            error: (xhr) =>
                if xhr.status == 404
                    alert('Bundle not found')
                else
                    alert('Server Error')

    bind_ui: ($sample, is_new) ->
        # Destroy
        $del_btn = $("[data-role=delete]", $sample)
        $restore_btn = $("[data-role=restore]", $sample)
        if is_new
            $del_btn.bind "click", ->
                $sample.remove()
        else
            $del_btn.bind "click", ->
                $sample.addClass "danger"
                $del_btn.hide()
                $restore_btn.show()
                $('[data-role=destroy-flag]', $sample).val('true')

            $restore_btn.bind "click", ->
                $sample.removeClass "danger"
                $del_btn.show()
                $restore_btn.hide()
                $('[data-role=destroy-flag]', $sample).val('false')
                
        
$.fn.sample_editor = (options, values) ->
    if options == 'add'
        for e in this
            e._sample_editor.add(values)
    else
        for e in this
            e._sample_editor = new SampleEditor(e, options)
        this
