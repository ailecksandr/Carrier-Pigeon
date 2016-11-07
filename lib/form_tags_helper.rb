require 'sinatra/form_helpers'

module FormTagsHelper
  def include_stylesheet(name, options = {})
    href = options[:external] ? name : "/stylesheets/#{name}.css"
    single_tag :link, type: 'text/css', rel: 'stylesheet', href: href
  end

  def include_javascript(name, options = {})
    src = options[:external] ? name : "/javascripts/#{name}.js"
    tag :script, '', type: 'text/javascript', src: src
  end

  def form_tag(action, options = {}, &block)
    method = options.delete(:method)
    method = :post if %w(post get put).exclude? method.to_s.downcase
    out = tag(:form, nil, {action: action, method: method.to_s.upcase}.merge(options))
    out << capture_haml(&block) + '</form>' if block_given?
    out
  end

  def link_to(content, href = content, options={}, &block)
    if block_given?
      out = tag :a, nil, options.merge(href: content)
      out << capture_haml(&block) + '</a>'
      out
    else
      tag :a, content, options.merge(href: href)
    end
  end

  def partial(page, variables = {})
    haml page.to_sym, { layout: false }, variables
  end

  def set_favicon(name)
    single_tag :link, type: 'image/png', rel: 'shortcut icon', href: "/images/#{name}.png"
  end

  def radio_button(obj, field, values, options = {})
    join = options.delete(:join) || ' '
    labs = options.delete(:label)
    Array(values).collect do |val|
      id, text = id_and_text_from_value(val)
      selected = options[:selected].to_s == id.to_s
      single_tag(:input, options.merge(
        type: 'radio', id: css_id(obj, field, id),
        name: "#{obj}[#{field}]", value: id,
        checked: selected ? 'true' : nil,
        class: options[:class]
      )) +
      (labs.nil? || labs == true ?
          label(obj, "#{field}_#{id.to_s.downcase}", text, class: selected ? 'selected' : nil) : '')
    end.join(join)
  end
end