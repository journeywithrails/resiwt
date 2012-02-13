module ContentHelper
  
  def content_area(&block)
    content_tag(:div, :class => 'content') do
      top    = content_tag(:div, "", :class => 'content_top')
      middle = content_tag(:div, capture(&block), :class => 'content_middle')
      bottom = content_tag(:div, "", :class => 'content_bottom')
      top + middle + bottom
    end
  end
  
  def help_link(anchor, options={})
    hint        = "Open the help page for this section"
    options     = options.merge!(:class => "help_link", :title => hint, :alt => hint)
    anchor_path = "#{faq_path}##{anchor}"
    link_to(content_tag(:span, "Help"), "#{anchor_path}", options)
  end
end
