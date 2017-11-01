class Users::InvitationsController < Devise::InvitationsController
  def after_accept_path_for(resource)
    profile_edit_path
  end
end
