class RegistrationsController < Devise::RegistrationsController
  # Taken from https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-on-successful-sign-up-%28registration%29
  protected

  def after_sign_up_path_for(resource)
    holidays_path
  end
end