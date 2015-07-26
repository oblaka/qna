class ConfirmationsController < Devise::ConfirmationsController
  def show
    super do |resource|
      sign_in(resource)
      redirect_to profile_path
      return
    end
  end
end
