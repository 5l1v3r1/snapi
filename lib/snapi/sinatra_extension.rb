require 'json'
require 'sinatra/contrib'

module Snapi
  # TODO document, test, make more robust
  module SinatraExtension
    extend Sinatra::Extension

    get "/?" do
      JSON.generate(Snapi.capabilities)
    end

    get "/:capability/?" do
      @capability = params.delete(:capability).to_sym

      unless Snapi.valid_capabilities.include?(@capability)
        raise InvalidCapabilityError
      end

      Snapi.capabilities[@capability].to_hash
    end

    get "/:capability/:function/?" do
      @capability = params.delete(:capability).to_sym
      @function = params.delete(:function).to_sym

      unless Snapi.valid_capabilities.include?(@capability)
        raise InvalidCapabilityError
      end

      unless Snapi.capabilities[@capability].valid_function_call?(@function,params)
        raise InvalidFunctionCallError
      end

      Snapi.capabilities[@capability].run_function?(@function,params)
    end

  end
end