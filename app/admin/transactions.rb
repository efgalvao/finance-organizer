ActiveAdmin.register Transaction do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :kind, :title, :date
  #
  # or
  #
  permit_params do
    permitted = %i[account_id category_id value_cents kind title date]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
end
