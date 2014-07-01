module RademadeAdmin::FormHelper
  def admin_form(record, model, &block)
    semantic_form_for(
      record,
      :url => record.new_record? ? admin_create_uri(model) : admin_update_uri(record),
      :as => :data,
      :html => {
        :multipart => true,
        :class => (record.new_record? ? 'insert-item-form' : 'update-item-form') + ' form-horizontal',
      },
      &block
    )
  end

  def admin_field(form, name, params, model_reflection, record)
    attrs = admin_default_params(name).merge( admin_field_params( params ) )

    field = form.input(name, input_attr(attrs))

    if multiple_relation?(model_reflection, name)
      link = admin_field_link_to_list(name, model_reflection, record).to_s
    else
      link = ''
    end

    concat field + link
  end

  def admin_default_params(name)
    { :label => field_to_label(name) }
  end

  def admin_field_link_to_list(name, model_reflection, record)
    uri = admin_url_for(model_reflection.reflect_on_association(name).class_name, {
      :action => :index,
      :parent => model_reflection.model,
      :parent_id => record.id.to_s
    })
    link_to(field_to_label(name).pluralize + ' list', uri)
  end

  def admin_field_params(field_params)
    if field_params.is_a? Hash
      field_params
    else
      {:as => field_params}
    end
  end

  private

  def multiple_relation?(model_reflection, name)
    association = model_reflection.reflect_on_association(name)
    if association
      inner_model = association.class_name.to_s
      model_reflection.has_many.include? inner_model
    end
  end

end