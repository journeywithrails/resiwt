module ListHelper
  
  def render_list(object, collection, context="app", locals={})
    render :partial => "#{context}/#{object}/list", :locals => { object.to_sym => collection }.merge!(locals)
  end
  
end
