module MetaTagAdditions
  include Radiant::Taggable
  
  desc %{
    Renders it's contents if data is found for the given @name@ attribute.
    The default @name@ is 'keywords'. You may also use 'description'.
    
    *Usage:*
    <pre><code><r:if_meta name="description">...</r:if_meta></code></pre>
  }
  tag 'if_meta' do |tag|
    page = tag.locals.page
    name = attr_or_error(tag, :attribute_name => 'name', :default => 'keywords', :values => 'keywords, description')
    inherit = boolean_attr_or_error(tag, 'inherit', 'true')
    if inherit
      while (page.send(name).blank? and (not page.parent.nil?)) do
        page = page.parent
      end
    end
    tag.expand if !page.send(name).blank?
  end
  
  desc %{
    Renders it's contents if data is not found for the given @name@ attribute.
    The default @name@ is 'keywords'. You may also use 'description'.
    
    *Usage:*
    <pre><code><r:if_meta name="keywords">...</r:if_meta></code></pre>
  }
  tag 'unless_meta' do |tag|
    page = tag.locals.page
    name = attr_or_error(tag, :attribute_name => 'name', :default => 'keywords', :values => 'keywords, description')
    inherit = boolean_attr_or_error(tag, 'inherit', 'true')
    if inherit
      while (page.send(name).blank? and (not page.parent.nil?)) do
        page = page.parent
      end
    end
    tag.expand unless !page.send(name).blank?
  end
end