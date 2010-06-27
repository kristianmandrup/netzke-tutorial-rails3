module Netzke
  class BossesAndClerksTutorial < BorderLayoutPanel 
    def default_config
      super.merge({
        :regions => {
          :center => {
            :widget_class_name => "Panel"
          },
          :east => {
            :widget_class_name => "Panel",
            :region_config => {
              :width => 240,
              :split => true
            }
          },
          :south => {
            :widget_class_name => "Panel",
            :region_config => {
              :height => 150,
              :split => true
            }
          }
        }
      })
    end
  end
end