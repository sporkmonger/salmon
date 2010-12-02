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

require 'salmon/key'

describe Salmon::Key do
  it 'should parse application/magic-key correctly' do
    key = Salmon::Key.parse_magic_key(
      'RSA.mVgY8RN6URBTstndvmUUPb4UZTdwvwmddSKE5z_' +
      'jvKUEK6yk1u3rrC9yN8k6FilGj9K0eeUPe2hf4Pj-5CmHww.AQAB'
    )
    key.modulus.should == (
      '803128378907519656502289154656359136834494406215410' +
      '050964539889229343337085989194330643990745488374753' +
      '4493461257620351548796452092307094036643522661681091'
    ).to_i
    key.exponent.should == '65537'.to_i
  end
end
