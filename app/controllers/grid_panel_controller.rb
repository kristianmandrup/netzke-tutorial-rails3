require 'faker'
class GridPanelController < ApplicationController  
  
  def demo
    # Simplify the URL, there was no need for more actions apparently
    redirect_to :action => "index", :status=>:moved_permanently
  end
  
  def regenerate_test_data
    Netzke::Data.regenerate_test_data
    redirect_to :action => "demo"
  end

  def reset_configs                  
    Netzke::Data.reset_configs
    redirect_to :action => "demo"
  end
end
