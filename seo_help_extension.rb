class SeoHelpExtension < Radiant::Extension
  version "1.0"
  description "Provides some tags to assist with SEO"
  url "http://saturnflyer.com/"
  
  def activate
    Page.send(:include, MetaTagAdditions)
  end
  
  def deactivate
  end
  
end