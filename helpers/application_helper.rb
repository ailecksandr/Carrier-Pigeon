module ApplicationHelper
  def include_stylesheet(name)
    single_tag :link, type: 'text/css', rel: 'stylesheet', href: "/stylesheets/#{name}.css"
  end

  def include_javascript(name)
    tag :script, type: 'text/javascript', src: "/javascripts/#{name}.js"
  end

  def set_favicon(name)
    single_tag :link, type: 'image/png', rel: 'shortcut icon', href: "/images/#{name}.png"
  end

  def title
    @title ||= 'Carrier Pigeon'
  end
end