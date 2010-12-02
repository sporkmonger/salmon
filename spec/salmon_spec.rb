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

  it 'should convert encoded data to integer correctly' do
    Salmon.base64url_to_i('AQAB').should == 65537
  end

  it 'should convert integer to encoded data correctly' do
    Salmon.i_to_base64url(65537).should == 'AQAB'
  end
end
