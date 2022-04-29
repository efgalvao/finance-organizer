ActiveAdmin.register Share do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :aquisition_date, :aquisition_value_cents
  #
  # or
  #
  permit_params do
    permitted = [:aquisition_date, :aquisition_value_cents, :stock_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
end
