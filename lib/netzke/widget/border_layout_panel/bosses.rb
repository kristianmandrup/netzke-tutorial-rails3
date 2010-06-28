module Netzke::Widget
  class BossesAndClerks < BorderLayoutPanel
    def default_config
      super.merge({
        :regions => {
          :center => {
            :widget_class_name => "GridPanel",
            :data_class_name => "Boss",
            :ext_config => {
              :title => "Bosses"
            }
          },
          :east => {
            :widget_class_name => "Panel",
            :ext_config => {
              :title => "Info"
            },
            :region_config => {
              :width => 240,
              :split => true
            }
          },
          :south => {
            :widget_class_name => "GridPanel",
            :data_class_name => "Clerk",
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
  
  end
end
