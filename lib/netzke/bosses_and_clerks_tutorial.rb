module Netzke
  class BossesAndClerksTutorial < BorderLayoutPanel 
    def default_config
      super.merge({
        :regions => {
          :center => {
            :class_name => "GridPanel",
            :model => "Boss",
            :ext_config => {
              :title => "Bosses"
            }
          },
          :east => {
            :class_name => "Panel",
            :ext_config => {
              :title => "Info"
            },
            :region_config => {
              :width => 240,
              :split => true
            }
          },
          :south => {
            :class_name => "GridPanel",
            :model => "Clerk",
            :ext_config => {
              :title => "Clerks"
            },
            :region_config => {
              :height => 150,
              :split => true
            }
          }
        },
        :ext_config => {
          :header => false
        }
      })
    end

    def self.js_extend_properties
      super.merge({
        :init_component => <<-END_OF_JAVASCRIPT.l,
          function(){
            #{js_full_class_name}.superclass.initComponent.call(this);

            // Set the selection changed event
            this.getCenterWidget().on('rowclick', this.onBossSelectionChanged, this);
          }
        END_OF_JAVASCRIPT

        # Event handler
        :on_boss_selection_changed => <<-END_OF_JAVASCRIPT.l,
          function(self, rowIndex){
            alert("Boss id: " + self.store.getAt(rowIndex).get('id'));
          }
        END_OF_JAVASCRIPT
      })
    end



  end
end