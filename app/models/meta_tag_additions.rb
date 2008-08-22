module MetaTagAdditions
  include Radiant::Taggable
  
    desc %{
    The namespace for 'meta' attributes.  If used as a singleton tag, both the description
    and keywords fields will be output as &lt;meta /&gt; tags unless the attribute 'tag' is set to 'false'.

    *Usage*:

    <pre><code> <r:meta [tag="false"] />
     <r:meta>
       <r:description [tag="false"] />
       <r:keywords [tag="false"] />
     </r:meta>
    </code></pre>
  }
  tag 'meta' do |tag|
    inherit = boolean_attr_or_error(tag, 'inherit', 'true')
    if tag.double?
      tag.expand
    else
      tag.render('description', tag.attr) +
      tag.render('keywords', tag.attr)
    end
  end

  desc %{
    Emits the page description field in a meta tag, unless attribute
    'tag' is set to 'false'.

    *Usage*:

    <pre><code> <r:meta:description [tag="false"] /> </code></pre>
  }
  tag 'meta:description' do |tag|
    inherit = boolean_attr_or_error(tag, 'inherit', 'true')
    show_tag = tag.attr['tag'] != 'false' || false
    page = tag.locals.page
    if inherit
      while (page.description.blank? and (not page.parent.nil?)) do
        page = page.parent
      end
    end
    description = CGI.escapeHTML(page.description)
    if show_tag
      "<meta name=\"description\" content=\"#{description}\" />"
    else
      description
    end
  end

  desc %{
    Emits the page keywords field in a meta tag, unless attribute
    'tag' is set to 'false'.

    *Usage*:

    <pre><code> <r:meta:keywords [tag="false"] /> </code></pre>
  }
  tag 'meta:keywords' do |tag|
    inherit = boolean_attr_or_error(tag, 'inherit', 'true')
    show_tag = tag.attr['tag'] != 'false' || false
    page = tag.locals.page
    if inherit
      while (page.keywords.blank? and (not page.parent.nil?)) do
        page = page.parent
      end
    end
    keywords = CGI.escapeHTML(page.keywords)
    if show_tag
      "<meta name=\"keywords\" content=\"#{keywords}\" />"
    else
      keywords
    end
  end
  
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