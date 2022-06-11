ActiveAdmin.register Account::Account do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :savings, :user_id, :balance_cents, :kind
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :savings, :user_id, :balance_cents, :kind]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
