module Netzke::Widget   
  module FormPanel
    class MyFormPanel < Base
      def default_config
        super.merge({
          :model => config[:model]
        })
      end
    
      def independent_config
        super.deep_merge(
          :ext_config => {
            :tbar => ["Actions", :save, :del]
          }
        )
      end
    
      def actions
        super.merge(
          :save => {:text => "Save", :icon => "/images/icons/disk.png"},
          :del => {:text => "Delete", :icon => "/images/icons/delete.png"}
        )
      end
    
      def self.js_extend_properties
        {        
          :on_save => <<-END_OF_JAVASCRIPT.l,
            function(){
            }
          END_OF_JAVASCRIPT
        
          :on_del => <<-END_OF_JAVASCRIPT.l,
            function(){
            }
          END_OF_JAVASCRIPT
        
        }
      end    
    end
  end
end
