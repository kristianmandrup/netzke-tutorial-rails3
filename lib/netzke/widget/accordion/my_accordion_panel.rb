module Netzke::Widget   
  module AccordionPanel
    class MyAccordionPanel < Base
      def default_config
        super.merge({
          :items => [{
            :class_name => "GridPanel",
            :model => "Boss",
            :name => "bosses"
          }, {
            :class_name => "GridPanel",
            :model => "Clerk",
            :name => "clerks"
          }], 
          :ext_config => {
            :width => 700,
            :border => true,
            :title => "Two GridPanels loaded dynamically"
          } 
        })
      end
    end
end