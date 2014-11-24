require 'yaml'
data = Rails.root.join('config/twitter.yml').read

require 'erb'
data = ERB.new(data).result(binding)

yml_config = YAML.load(data)


TWITTER_REST_CLIENT = ::Twitter::REST::Client.new do |config|
  yml_config.each do |key, value|
    config.send("#{key}=", value)
  end
end

