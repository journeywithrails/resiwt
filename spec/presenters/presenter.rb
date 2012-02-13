describe Presenter do
  
  class DummyObject < Struct.new(:name)
  end
  
  before do
    @object    = DummyObject.new("Josh")
    @presenter = Presenter.new(@object)
  end
  
  it "should delegate successfully to the object its presenting" do
    @object.name.should    == "Josh"
    @presenter.name.should == "Josh"
  end
  
  it "should call method missing on a method that doesnt exist on the decorated object" do
    lambda { @object.doesnt_exist }.should raise_error(NameError)
    lambda { @presenter.doesnt_exist }.should raise_error(NameError)
  end
  
  it "should delegate the Object#id to the decorated object" do
    @presenter.id.should == @object.id
  end
  
end
