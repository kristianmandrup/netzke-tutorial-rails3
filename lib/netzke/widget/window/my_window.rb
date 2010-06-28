module Netzke::Widget   
  module Window
    class MyWindow < Base
      def default_config
        super.merge({
          :item => {
            :class_name => "BossesAndClerks"
          }
      end
    end
end
