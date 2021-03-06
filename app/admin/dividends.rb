ActiveAdmin.register Investments::Stock::Dividend do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :date, :value_cents, :stock_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:date, :value_cents, :stock_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
