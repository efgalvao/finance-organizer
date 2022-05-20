ActiveAdmin.register Investments::Stock::Share do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :date, :value_cents
  #
  # or
  #
  permit_params do
    permitted = %i[date value_cents stock_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
end
