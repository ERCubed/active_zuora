require 'savon'
require 'active_model'
require 'active_support/all'

require 'active_zuora/connection'
require 'active_zuora/generator'
require 'active_zuora/fields'
require 'active_zuora/belongs_to_associations'
require 'active_zuora/base'
require 'active_zuora/relation'
require 'active_zuora/scoping'
require 'active_zuora/persistence'
require 'active_zuora/has_many_proxy'
require 'active_zuora/has_many_associations'
require 'active_zuora/z_object'
require 'active_zuora/subscribe'
require 'active_zuora/amend'
require 'active_zuora/generate'

module ActiveZuora

  # Setup configuration.  None of this sends a request.
  def self.configure(configuration)
    # Set some sensible defaults with the savon SOAP client.

    # Savon.configure do |config|
    #   config.log = HTTPI.log = configuration[:log] || false
    #   config.log_level = configuration[:log_level] || :info
    #   config.logger = configuration[:logger] if configuration[:logger]
    #   config.raise_errors = true
    # end
    @client = Savon.client(
        wsdl: configuration[:wsdl],
        raise_errors: true
    )
    # Create a default connection on Base
    Base.connection = Connection.new(configuration)
    puts "======="
    puts Base.connection.soap_client.inspect.to_yaml
    puts "======="
    puts Base.connection.inspect.to_yaml
    puts "======="
    # puts Base.connection.soap_client[:document]
  end

  def self.generate_classes(options={})
    # generator = Generator.new(Base.connection.soap_client.wsdl.parser, options)
    file = Nokogiri::XML File.read('wsdl/zuora.wsdl')
    generator = Generator.new(file, options)
    generator.generate_classes
  end

end