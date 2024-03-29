ActiveAdmin.register UserReport do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :date, :savings_cents, :stocks_cents, :total_cents, :dividends_cents
  #
  # or
  #
  # permit_params do
  #   permitted = [:date, :savings_cents, :stocks_cents, :total_cents, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
