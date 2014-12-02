
def render_label(html_tag, instance)
  "<div class=\"has-error\">#{html_tag}</div>"
end

def render_input(html_tag, instance)
    <<-eos
<span class=\"has-error has-feedback\">#{html_tag}<span class=\"glyphicon glyphicon-remove form-control-feedback\"></span></span>
<span class="help-block">#{instance.error_message.first}</span>
  eos
end

ActionView::Base.field_error_proc = Proc.new { |html_tag, instance|
  if html_tag =~ /\A<label/
    render_label(html_tag, instance).html_safe
  else
    render_input(html_tag, instance).html_safe
  end
}
