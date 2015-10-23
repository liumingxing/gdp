# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  #config.time_zone = 'UTC'
  
  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  
  #config.gem "fiveruns_tuneup"
end

ActiveRecord::Base.pluralize_table_names = false
class Hash
  alias  old_to_json to_json
  
  def to_json(options = nil) #:nodoc:
    hash = as_json(options)

    result = '{'
    result << hash.map do |key, value|
      "#{ActiveSupport::JSON.encode(key.to_s)}:#{ActiveSupport::JSON.encode(value, options)}"
    end * ','
    result << '}'
  end
end

require 'iconv'
class String   
   def to_gb2312 
     begin
        Iconv.iconv("GBK", "UTF-8", self)[0]
     rescue 
        self
     end
   end  
   
   def to_utf8
    begin
        Iconv.iconv("UTF-8", "GBK", self)[0]
     rescue 
        self
     end
   end 
   
   def utf8?     
          unpack('U*') rescue return false     
          true     
   end  
end

begin
  filters = Logfilter.find(:all)
  $FilterMap = {}
  for filter in filters
    next if filter.log != 1
    if filter.action
      $FilterMap["/#{filter.controller}/#{filter.action}"] = filter.desc
    else
      $FilterMap["/#{filter.controller}"] = filter.desc
    end
  end
rescue 
end

$BUDGET_TYPE = {"1"=>"估算", "2"=>"概算", "3"=>"预算"}
$CONTRACT_OPERATE = {}
begin
  for item in Dictionary.find_by_name("合同操作").items
    $CONTRACT_OPERATE[item.code] = item.name
  end
rescue 
end