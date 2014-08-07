Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :facebook, '1447667902164724', '3f6a99bae5d17823f6acc43ec553b883', {:client_options => {:ssl => {:verify => false}}}  
end