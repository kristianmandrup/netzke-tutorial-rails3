module Netzke::Widget
  module Panel
    class MyPanel < Netzke::Widget::Base
      def default_config
        super.merge({
          :update_body_html => <<-END_OF_JAVASCRIPT.l,
            function(html){
              this.body.update(html);
            }
          END_OF_JAVASCRIPT
        })
      end
    end
  end
end