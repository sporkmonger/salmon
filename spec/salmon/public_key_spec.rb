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

require 'spec_helper'

require 'salmon/public_key'

shared_examples_for 'normal public keys' do
  it 'should have the correct modulus and exponent' do
    @public_key.modulus.should == (
      '803128378907519656502289154656359136834494406215410' +
      '050964539889229343337085989194330643990745488374753' +
      '4493461257620351548796452092307094036643522661681091'
    ).to_i
    @public_key.exponent.should == '65537'.to_i
  end
end

describe Salmon::PublicKey, 'parsed from application/magic-key' do
  before do
    @public_key = Salmon::PublicKey.parse_magic_key(
      'RSA.mVgY8RN6URBTstndvmUUPb4UZTdwvwmddSKE5z_jvKU' +
      'EK6yk1u3rrC9yN8k6FilGj9K0eeUPe2hf4Pj-5CmHww.AQAB'
    )
  end

  it_should_behave_like 'normal public keys'
end

describe Salmon::PublicKey, 'parsed from application/magic-key with zeroes' do
  before do
    @public_key = Salmon::PublicKey.parse_magic_key(
      'RSA.AJlYGPETelEQU7LZ3b5lFD2-FGU3cL8JnXUihOc_47' +
      'ylBCuspNbt66wvcjfJOhYpRo_StHnlD3toX-D4_uQph8M.AQAB'
    )
  end

  it_should_behave_like 'normal public keys'
end

describe Salmon::PublicKey, 'parsed from .pem' do
  before do
    @public_key = Salmon::PublicKey.parse_pem(<<-PEM
-----BEGIN RSA PUBLIC KEY-----
MEgCQQCZWBjxE3pREFOy2d2+ZRQ9vhRlN3C/CZ11IoTnP+O8pQQrrKTW7eusL3I3
yToWKUaP0rR55Q97aF/g+P7kKYfDAgMBAAE=
-----END RSA PUBLIC KEY-----
PEM
    )
  end

  it_should_behave_like 'normal public keys'
end

describe Salmon::PublicKey, 'parsed from .der' do
  before do
    @public_key = Salmon::PublicKey.parse_der(
      "0H\002A\000\231X\030\361\023zQ\020S\262\331\335\276e\024=\276\024e7p" +
      "\277\t\235u\"\204\347?\343\274\245\004+\254\244\326\355\353\254/r7" +
      "\311:\026)F\217\322\264y\345\017{h_\340\370\376\344)\207\303\002" +
      "\003\001\000\001"
    )
  end

  it_should_behave_like 'normal public keys'
end

describe Salmon::PublicKey, 'constructed from a modulus and exponent' do
  before do
    modulus = (
      '803128378907519656502289154656359136834494406215410' +
      '050964539889229343337085989194330643990745488374753' +
      '4493461257620351548796452092307094036643522661681091'
    ).to_i
    exponent = '65537'.to_i
    @public_key = Salmon::PublicKey.new(modulus, exponent)
  end

  it 'should generate application/magic-key correctly' do
    @public_key.to_s.should == (
      'RSA.mVgY8RN6URBTstndvmUUPb4UZTdwvwmddSKE5z_jvKU' +
      'EK6yk1u3rrC9yN8k6FilGj9K0eeUPe2hf4Pj-5CmHww.AQAB'
    )
  end

  it 'should generate a .pem correctly' do
    @public_key.to_pem.should == <<-PEM
-----BEGIN RSA PUBLIC KEY-----
MEgCQQCZWBjxE3pREFOy2d2+ZRQ9vhRlN3C/CZ11IoTnP+O8pQQrrKTW7eusL3I3
yToWKUaP0rR55Q97aF/g+P7kKYfDAgMBAAE=
-----END RSA PUBLIC KEY-----
PEM
  end

  it 'should generate a .der correctly' do
    @public_key.to_der.should == (
      "0H\002A\000\231X\030\361\023zQ\020S\262\331\335\276e\024=\276\024e7p" +
      "\277\t\235u\"\204\347?\343\274\245\004+\254\244\326\355\353\254/r7" +
      "\311:\026)F\217\322\264y\345\017{h_\340\370\376\344)\207\303\002" +
      "\003\001\000\001"
    )
  end

  it 'should generate a magic signature key ID correctly' do
    @public_key.to_key_id.should == (
      'ATyfAWA5nA6s62uvxAZTwyciKnFDtl9hCpzZwMVi0PQ'
    )
  end
end
