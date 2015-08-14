require 'rails_helper'
require 'email_spec'

RSpec.configure do |config|
  config.before(:each) do
    reset_mailer # Clears out ActionMailer::Base.deliveries
  end
end
