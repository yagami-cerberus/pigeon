// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require select2
//= require turbolinks
//= require_tree .

jQuery.fn.extend({
    checkbox_toggle: function (children_selector) {
        var $children = $(children_selector);
        
        $(this).bind("change", function () {
            $children.prop("checked", this.checked).trigger("change");
        });
    },
    text_input_options: function(input, selector) {
        $.each(this, function(index, e) {
            var $self = $(e);
            var $input = $(input, $self);
            $("a", $self).bind("click", function(){
                $input.val($(this).text());
            });
        })
    }
});
