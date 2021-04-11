module GroupFilter
  include ActiveSupport::Concern

  def filter_by_group_name(model_object, name)
    unless name.present?
      return model_object
    end

    model_object.where('lower(name) like ?', "%#{params[:name].downcase}%")
  end
end
