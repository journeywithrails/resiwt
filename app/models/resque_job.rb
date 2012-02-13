class ResqueJob < ActiveRecord::Base
  validates_uniqueness_of :record_id, :scope => [:record_type, :association, :page]
  validates_uniqueness_of :association, :scope => [:record_type, :record_id, :page]
  validates_uniqueness_of :record_type, :scope => [:record_id, :association, :page]
  validates_uniqueness_of :page, :scope => [:record_id, :record_type, :association]
  
  validates_presence_of :record_id
  validates_presence_of :record_type
  validates_presence_of :association
  
  named_scope :for, lambda { |record, association | {:limit => 1, :conditions => {:record_id => record.id, :record_type => record.class.to_s, :association => association.to_s, :page => 1}}}
  named_scope :for_page, lambda { |record, association, page| {:limit => 1, :conditions => {:record_id => record.id, :record_type => record.class.to_s, :association => association.to_s, :page => page}}}
  
  def record
    @record ||= record_type.constantize.find record_id rescue nil
  end
  
  def record=(record)
    record_type = record.class.to_s
    record_id = record.id
  end
  
end
