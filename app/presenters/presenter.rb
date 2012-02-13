class Presenter
  attr_reader :object
  
  def id
    @object.id
  end
  
  def initialize(object, opts={})
    @object = object
  end
  
  private
  def method_missing(method, *args, &block)
    @object.send(method, *args, &block)
  end
  
end
