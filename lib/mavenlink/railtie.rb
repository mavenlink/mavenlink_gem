module Mavenlink
  class Railtie < Rails::Railtie
    initializer "mavenlink.initialize" do
      Mavenlink.oauth_token = ENV["MAVENLINK_OAUTH_TOKEN"]
    end
  end
end
