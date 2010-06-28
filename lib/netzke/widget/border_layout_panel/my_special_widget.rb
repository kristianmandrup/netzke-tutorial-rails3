module Netzke::Widget::BorderLayoutPanels
  class MySpecial < Base
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

          :south => {
            :widget_class_name => "Panel"
            :ext_config => {
              :title => "Panel"
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