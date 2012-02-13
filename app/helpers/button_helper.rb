module ButtonHelper
  
  def edit_button(text, path, options={})
    options.merge!(:class => "edit")
    options.merge!(:title => "Edit")
    button(text, path, options)
  end
  
  def delete_button(text, path, options={})
    options.merge!(:class => "delete")
    options.merge!(:title => "Delete")
    button(text, path, options)
  end
  
  def button(text, path, options={})
    options.merge!(:class => "button #{options[:class]}")
    link_to(content_tag(:span , text), path, options)
  end
  
end
