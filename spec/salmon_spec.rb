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

require 'salmon'

describe Salmon do
  # Ugly-looking test data carefully designed to cover as much of the
  # base64url algorithm as possible.

  it 'should encode data correctly' do
    Salmon.base64url_encode('2`?33>]').should == 'MmA_MzM-XQ'
    Salmon.base64url_encode('  ').should == 'ICA'
  end

  it 'should decode data correctly' do
    Salmon.base64url_decode('MmA_MzM-XQ').should == '2`?33>]'
    Salmon.base64url_decode('ICA').should == '  '
  end

  it 'should decode data correctly despite whitespace' do
    Salmon.base64url_decode("     MmA_M\n\t  zM-XQ   ").should == '2`?33>]'
    Salmon.base64url_decode("  IC\nA\t  ").should == '  '
  end

  it 'should convert encoded data to integer correctly' do
    Salmon.base64url_to_i('AQAB').should == 65537
    Salmon.base64url_to_i((
      'mVgY8RN6URBTstndvmUUPb4UZTdwvwmddSKE5z_jvKU' +
      'EK6yk1u3rrC9yN8k6FilGj9K0eeUPe2hf4Pj-5CmHww'
    )).should == (
      '803128378907519656502289154656359136834494406215410' +
      '050964539889229343337085989194330643990745488374753' +
      '4493461257620351548796452092307094036643522661681091'
    ).to_i
  end

  it 'should convert encoded data with zeroes to integer correctly' do
    Salmon.base64url_to_i((
      'AJlYGPETelEQU7LZ3b5lFD2-FGU3cL8JnXUihOc_47' +
      'ylBCuspNbt66wvcjfJOhYpRo_StHnlD3toX-D4_uQph8M'
    )).should == (
      '803128378907519656502289154656359136834494406215410' +
      '050964539889229343337085989194330643990745488374753' +
      '4493461257620351548796452092307094036643522661681091'
    ).to_i
  end

  it 'should convert integer to encoded data correctly' do
    Salmon.i_to_base64url(65537).should == 'AQAB'
    Salmon.i_to_base64url((
      '803128378907519656502289154656359136834494406215410' +
      '050964539889229343337085989194330643990745488374753' +
      '4493461257620351548796452092307094036643522661681091'
    ).to_i).should == (
      'mVgY8RN6URBTstndvmUUPb4UZTdwvwmddSKE5z_jvKU' +
      'EK6yk1u3rrC9yN8k6FilGj9K0eeUPe2hf4Pj-5CmHww'
    )
  end

  it 'should convert encoded data to an integer and back correctly' do
    Salmon.i_to_base64url(
      Salmon.base64url_to_i('AQAB')
    ).should == 'AQAB'
    encoded_data = (
      'mVgY8RN6URBTstndvmUUPb4UZTdwvwmddSKE5z_jvKU' +
      'EK6yk1u3rrC9yN8k6FilGj9K0eeUPe2hf4Pj-5CmHww'
    )
    Salmon.i_to_base64url(
      Salmon.base64url_to_i(encoded_data)
    ).should == encoded_data
  end

  it 'should convert integer to encoded data and back correctly' do
    for n in (2 ** 1000 .. 2 ** 1000 + 1000)
      Salmon.base64url_to_i(Salmon.i_to_base64url(n)).should == n
    end
  end
end
