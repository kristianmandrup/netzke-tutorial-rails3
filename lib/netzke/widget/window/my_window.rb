module Netzke::Widget   
  module Window
    class MyWindow < Base
      def default_config
        super.merge({
          :height => 300,
          :width => 300,
          :layout => 'hbox',
          :layout_config => {
            :align => 'middle',
            :pack => 'start'
          },
          :defaults => {
            :frame => true,
            :flex => 1
          },
          :items => [
            {
              :title => 'Panel 1'
            },
            {
              :title => 'Panel 2'
            },
            {
              :title => 'Panel 3'
            }
          ]
        }).show();
      end
    end
end
