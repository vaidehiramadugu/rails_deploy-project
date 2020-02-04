# encoding: binary
# frozen_string_literal: true

require "ffi"

module RbNaCl
  # Provides helpers for defining the libsodium bindings
  module Sodium
    def self.extended(klass)
      klass.extend FFI::Library
      if defined?(RBNACL_LIBSODIUM_GEM_LIB_PATH)
        klass.ffi_lib RBNACL_LIBSODIUM_GEM_LIB_PATH
      else
        klass.ffi_lib "sodium"
      end
    end

    def sodium_type(type = nil)
      return @type if type.nil?
      @type = type
    end

    def sodium_primitive(primitive = nil)
      return @primitive if primitive.nil?
      @primitive = primitive
    end

    def primitive
      sodium_primitive
    end

    def sodium_constant(constant, name = constant)
      fn = "crypto_#{sodium_type}_#{sodium_primitive}_#{constant.to_s.downcase}"
      attach_function fn, [], :size_t
      const_set(name, public_send(fn))
    end

    def sodium_function(name, function, arguments)
      module_eval <<-eos, __FILE__, __LINE__ + 1
      attach_function #{function.inspect}, #{arguments.inspect}, :int
      def self.#{name}(*args)
        ret = #{function}(*args)
        ret == 0
      end
      eos
    end

    def sodium_function_with_return_code(name, function, arguments)
      module_eval <<-eos, __FILE__, __LINE__ + 1
      attach_function #{function.inspect}, #{arguments.inspect}, :int
      def self.#{name}(*args)
        #{function}(*args)
      end
      eos
    end
  end
end
