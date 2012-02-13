require 'will_paginate'

module Tweasier::Cache
  
  class NilCacheObject < Object; end
  
  module Associations
    module ClassMethods
      
      def has_many(association_id, params = {}, &extension)
        job = params.delete(:cached_with)
        duration = params.delete(:cached_for)
        
        response = super(association_id, params, &extension)
        define_overrides(association_id,job,duration) if specifies_caching_options?(job,duration)
        response
      end
      
      def has_one(association_id, params = {})
        job = params.delete(:cached_with)
        duration = params.delete(:cached_for)
        
        response = super(association_id,params)
        define_overrides(association_id,job,duration) if specifies_caching_options?(job,duration)
        response
      end
      
      def belongs_to(association_id, params = {})
        job = params.delete(:cached_with)
        duration = params.delete(:cached_for)
        
        response = super(association_id,params)
        define_overrides(association_id,job,duration) if specifies_caching_options?(job,duration)
        response
      end
      
      def has_and_belongs_to_many(association_id, params = {}, &extension)
        job = params.delete(:cached_with)
        duration = params.delete(:cached_for)
        
        response = super(association_id,params,&extension)
        define_overrides(association_id,job,duration) if specifies_caching_options?(job,duration)
        response
      end
      
      private
      
      def define_overrides(association_id,cache_with,cached_for)
        prior = self.instance_method association_id
        self.send :define_method, association_id do | *args |
          Tweasier::Cache::Associations::association_with_caching(self, association_id, prior, cache_with, cached_for, *args)
        end
      end
      
      def specifies_caching_options?(job,duration)
        !(job.nil? || duration.nil?)
      end
      
    end
  
    module AssociationInstanceMethods
      
      attr_accessor :record, :page, :cached_for, :cache_with, :association_id, :job
      
      def stale?
        if refreshed_at.nil? || !ActionController::Base.perform_caching
          true
        else
          refreshed_at + cached_for < Time.zone.now
        end
      end
      
      def frozen?
        false
      end
      
      def fresh?
        !stale?
      end
      
      def refresh
        Resque.enqueue(cache_with, job_data)
        job.update_attributes(:is_running => true)
      end
      
      def refresh!
        results = cache_with.perform(job_data)
        record.send("#{association_id}=", results)
        results
      end
      
      def refreshed_at
        job.refreshed_at if job
      end
      
      def job_data
        {:page => page, :job_id => job.id, :record_id => record.id, :assocation => association_id.to_s}
      end
      
    end
  
    def self.included(receiver)
      receiver.extend ClassMethods
    end
    
    private
    def self.association_with_caching(record, association_id, delegate_method, cache_with, cached_for, *args)
      associated_data = delegate_method.bind(record).call(args)
      #FIXME might be better to use reflection to setup the actual class
      associated_data = Tweasier::Cache::NilCacheObject.new if associated_data.nil?
      params = args[0] || {}

      #Get pagination working on assocations
      page = params[:page].nil? ? 1 : params[:page].to_i
      if(params[:page])
        per_page = record.class.per_page rescue 20
        associated_data = associated_data.paginate(:page => page, :per_page => per_page)
      end
    
      associated_data.extend AssociationInstanceMethods
      associated_data.job = ResqueJob.find_or_create_by_record_type_and_record_id_and_association_and_page(record.class.to_s, record.id, association_id.to_s, page)
      associated_data.record = record
      associated_data.page = page
      associated_data.association_id = association_id
      associated_data.cache_with = cache_with
      associated_data.cached_for = cached_for
    
      associated_data
    end
  end
end
