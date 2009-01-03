require 'active_record'
require 'active_record/version'
require 'active_record/fixtures'

class ActiveRecordTestConnector
  
  cattr_accessor :able_to_connect
  cattr_accessor :connected

  FIXTURES_PATH = File.join(File.dirname(__FILE__), '..', 'fixtures')

  # Set our defaults
  self.connected = false
  self.able_to_connect = true

  def self.setup
    unless self.connected || !self.able_to_connect
      setup_connection
      load_schema
      add_load_path FIXTURES_PATH
      self.connected = true
    end
  rescue Exception => e  # errors from ActiveRecord setup
    $stderr.puts "\nSkipping ActiveRecord tests: #{e}\n\n"
    self.able_to_connect = false
  end

  private
  
  def self.add_load_path(path)
    dep = defined?(ActiveSupport::Dependencies) ? ActiveSupport::Dependencies : ::Dependencies
    dep.load_paths.unshift path
  end

  def self.setup_connection    
    configuration = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'database.yml'))
        
    ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/../debug.log")  
    ActiveRecord::Base.logger.level = Logger::DEBUG  
    ActiveRecord::Base.establish_connection(configuration['test'])
             
    unless Object.const_defined?(:QUOTED_TYPE)
      Object.send :const_set, :QUOTED_TYPE, ActiveRecord::Base.connection.quote_column_name('type')
    end
  end

  def self.load_schema
    ActiveRecord::Base.silence do
      ActiveRecord::Migration.verbose = false
      load File.join(FIXTURES_PATH, 'schema.rb')
    end
  end

end
