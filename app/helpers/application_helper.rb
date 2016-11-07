require 'sinatra/form_helpers'
require_relative '../../lib/form_tags_helper'

module ApplicationHelper
  include FormTagsHelper

  def title(name = nil)
    "Carrier Pigeon#{' | ' + name if name.present?}"
  end

  def options_for_radio_buttons
    {
      reviewing: 'By reviews',
      expiring: 'By ellapsed hours'
    }
  end

  def reviews_info(count)
    !count.zero? ? "#{count} reviews remaining" : 'That was a last review'
  end

  def expiring_info(created_at, count)
    "Message will be destroyed #{humanize_date(created_at + count.hours)}"
  end

  def flash_class(key)
    case key.to_sym
      when :notice then 'alert alert-info'
      when :success then 'alert alert-success'
      when :error then 'alert alert-danger'
      when :alert then 'alert alert-warning'
    end
  end

  def errors_list(value)
    value.is_a?(Array) ? value.map{ |error| tag(:p, format_error(error, value[-1]) ) }.join : value
  end


  private


  def format_error(error, last_error)
    error + (error != last_error ? ';' : '.')
  end

  def humanize_date(date)
    date.strftime("%d %B at %H:%M")
  end
end