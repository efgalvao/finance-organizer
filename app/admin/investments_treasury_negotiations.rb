ActiveAdmin.register Investments::Treasury::Negotiation do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :treasury_id, :kind, :date, :invested_cents, :shares
  #
  # or
  #
  # permit_params do
  #   permitted = [:treasury_id, :kind, :date, :invested_cents, :shares]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
