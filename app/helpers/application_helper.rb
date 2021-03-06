# frozen_string_literal: true

module ApplicationHelper
  def mdl_select(model_and_name, options, value)
    model, name = model_and_name.split('[')
    name.chop!
    label = model.camelize.constantize.human_attribute_name(name)
    name = model_and_name
    visible_value = if value
                      options.select { |i| i[1] == value }.first[0]
                    else
                      ''
                    end
    render 'mdl_select', name: name, model_and_name: model_and_name, model: model, label: label, options: options, visible_value: visible_value, value: value
  end
end
