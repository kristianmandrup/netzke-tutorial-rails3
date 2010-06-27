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


  end
end