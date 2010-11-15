# Copyright (C) 2010 Google Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

require "salmon/signature"
require "base64"

module Salmon
  class Envelope
    def data
      @data ||= nil
    end

    def data=(new_data)
      @data = new_data
      @payload = Base64.decode64(@data.gsub('-', '+').gsub('_', '/'))
    end

    def payload
      @payload ||= nil
    end

    def payload=(new_payload)
      @payload = new_payload
      @data = Base64.encode64(
        @payload
      ).gsub('+', '-').gsub('/', '_').gsub(/[\s=]/, '')
    end

    def data_type
      @data_type ||= nil
    end

    def data_type=(new_data_type)
      @data_type = new_data_type
    end

    def encoding
      @encoding ||= 'base64url'
    end

    def encoding=(new_encoding)
      @encoding = new_encoding
    end

    def algorithm
      @algorithm ||= 'RSA-SHA256'
    end

    def algorithm=(new_algorithm)
      @algorithm = new_algorithm
    end

    def signatures
      @signatures ||= []
    end

    def parse_json(data)
      require 'json'
      if data.respond_to?(:to_str)
        data = JSON.parse(data.to_str)
      elsif !data.kind_of?(Hash)
        raise TypeError, "Expected Hash or String, got #{data.class}."
      end
      self.data = data['data']
      self.data_type = data['data_type']
      self.encoding = data['encoding']
      self.algorithm = data['alg']
      if !data['sigs'].kind_of?(Array)
        raise ArgumentError, "Expected 'sigs' to contain a list of signatures."
      end
      for sig in data['sigs']
        self.signatures << Salmon::Signature.new.parse_json(sig)
      end
      return self
    end

    def self.parse_json(data)
      require 'json'
      if data.respond_to?(:to_str)
        data = JSON.parse(data.to_str)
      elsif !data.kind_of?(Hash)
        raise TypeError, "Expected Hash or String, got #{data.class}."
      end
      return Salmon::Envelope.new.parse_json(data)
    end

    def self.parse_xml(data)
      # TODO
    end
  end
end
