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

require 'salmon/envelope'
require 'json'

describe Salmon::Envelope, 'in its initial state' do
  before do
    @envelope = Salmon::Envelope.new
  end

  it 'should set the payload correctly' do
    @envelope.payload =
      "<?xml version='1.0' encoding='UTF-8'?>\n" +
      "<entry xmlns='http://www.w3.org/2005/Atom'>\n" +
      "  <id>tag:example.com,2009:cmt-0.44775718</id>  \n" +
      "  <author><name>test@example.com</name>" +
      "<uri>bob@example.com</uri></author>\n" +
      "  <thr:in-reply-to xmlns:thr='" +
      "http://purl.org/syndication/thread/1.0'\n" +
      "      ref='tag:blogger.com,1999:blog-893591374313312737."+
      "post-3861663258538857954'>tag:blogger.com,1999:" +
      "blog-893591374313312737.post-3861663258538857954\n" +
      "  </thr:in-reply-to>\n" +
      "  <content>Salmon swim upstream!</content>\n" +
      "  <title>Salmon swim upstream!</title>\n" +
      "  <updated>2009-12-18T20:04:03Z</updated>\n" +
      "</entry>\n    "
    @envelope.data.should ==
      "PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz4KPGVudHJ5IHhtbG5z" +
      "PSdodHRwOi8vd3d3LnczLm9yZy8yMDA1L0F0b20nPgogIDxpZD50YWc6ZXhhbXBsZS5j" +
      "b20sMjAwOTpjbXQtMC40NDc3NTcxODwvaWQ-ICAKICA8YXV0aG9yPjxuYW1lPnRlc3RA" +
      "ZXhhbXBsZS5jb208L25hbWU-PHVyaT5ib2JAZXhhbXBsZS5jb208L3VyaT48L2F1dGhv" +
      "cj4KICA8dGhyOmluLXJlcGx5LXRvIHhtbG5zOnRocj0naHR0cDovL3B1cmwub3JnL3N5" +
      "bmRpY2F0aW9uL3RocmVhZC8xLjAnCiAgICAgIHJlZj0ndGFnOmJsb2dnZXIuY29tLDE5" +
      "OTk6YmxvZy04OTM1OTEzNzQzMTMzMTI3MzcucG9zdC0zODYxNjYzMjU4NTM4ODU3OTU0" +
      "Jz50YWc6YmxvZ2dlci5jb20sMTk5OTpibG9nLTg5MzU5MTM3NDMxMzMxMjczNy5wb3N0" +
      "LTM4NjE2NjMyNTg1Mzg4NTc5NTQKICA8L3Rocjppbi1yZXBseS10bz4KICA8Y29udGVu" +
      "dD5TYWxtb24gc3dpbSB1cHN0cmVhbSE8L2NvbnRlbnQ-CiAgPHRpdGxlPlNhbG1vbiBz" +
      "d2ltIHVwc3RyZWFtITwvdGl0bGU-CiAgPHVwZGF0ZWQ-MjAwOS0xMi0xOFQyMDowNDow" +
      "M1o8L3VwZGF0ZWQ-CjwvZW50cnk-CiAgICA"
  end
end

describe Salmon::Envelope, 'with a JSON serialization' do
  before do
    @envelope = Salmon::Envelope.parse_json(<<-JSON.strip)
      {
        "data": "PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz4KPGVudHJ5IHhtbG5zPSdodHRwOi8vd3d3LnczLm9yZy8yMDA1L0F0b20nPgogIDxpZD50YWc6ZXhhbXBsZS5jb20sMjAwOTpjbXQtMC40NDc3NTcxODwvaWQ-ICAKICA8YXV0aG9yPjxuYW1lPnRlc3RAZXhhbXBsZS5jb208L25hbWU-PHVyaT5ib2JAZXhhbXBsZS5jb208L3VyaT48L2F1dGhvcj4KICA8dGhyOmluLXJlcGx5LXRvIHhtbG5zOnRocj0naHR0cDovL3B1cmwub3JnL3N5bmRpY2F0aW9uL3RocmVhZC8xLjAnCiAgICAgIHJlZj0ndGFnOmJsb2dnZXIuY29tLDE5OTk6YmxvZy04OTM1OTEzNzQzMTMzMTI3MzcucG9zdC0zODYxNjYzMjU4NTM4ODU3OTU0Jz50YWc6YmxvZ2dlci5jb20sMTk5OTpibG9nLTg5MzU5MTM3NDMxMzMxMjczNy5wb3N0LTM4NjE2NjMyNTg1Mzg4NTc5NTQKICA8L3Rocjppbi1yZXBseS10bz4KICA8Y29udGVudD5TYWxtb24gc3dpbSB1cHN0cmVhbSE8L2NvbnRlbnQ-CiAgPHRpdGxlPlNhbG1vbiBzd2ltIHVwc3RyZWFtITwvdGl0bGU-CiAgPHVwZGF0ZWQ-MjAwOS0xMi0xOFQyMDowNDowM1o8L3VwZGF0ZWQ-CjwvZW50cnk-CiAgICA",
        "data_type": "application/atom+xml",
        "encoding": "base64url",
        "alg": "RSA-SHA256",
        "sigs": [
          {
          "value": "EvGSD2vi8qYcveHnb-rrlok07qnCXjn8YSeCDDXlbhILSabgvNsPpbe76up8w63i2fWHvLKJzeGLKfyHg8ZomQ",
          "keyhash": "4k8ikoyC2Xh+8BiIeQ+ob7Hcd2J7/Vj3uM61dy9iRMI="
          }
        ]
      }
    JSON
  end

  it 'should parse the data correctly' do
    @envelope.data.should ==
      "PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz4KPGVudHJ5IHhtbG5z" +
      "PSdodHRwOi8vd3d3LnczLm9yZy8yMDA1L0F0b20nPgogIDxpZD50YWc6ZXhhbXBsZS5j" +
      "b20sMjAwOTpjbXQtMC40NDc3NTcxODwvaWQ-ICAKICA8YXV0aG9yPjxuYW1lPnRlc3RA" +
      "ZXhhbXBsZS5jb208L25hbWU-PHVyaT5ib2JAZXhhbXBsZS5jb208L3VyaT48L2F1dGhv" +
      "cj4KICA8dGhyOmluLXJlcGx5LXRvIHhtbG5zOnRocj0naHR0cDovL3B1cmwub3JnL3N5" +
      "bmRpY2F0aW9uL3RocmVhZC8xLjAnCiAgICAgIHJlZj0ndGFnOmJsb2dnZXIuY29tLDE5" +
      "OTk6YmxvZy04OTM1OTEzNzQzMTMzMTI3MzcucG9zdC0zODYxNjYzMjU4NTM4ODU3OTU0" +
      "Jz50YWc6YmxvZ2dlci5jb20sMTk5OTpibG9nLTg5MzU5MTM3NDMxMzMxMjczNy5wb3N0" +
      "LTM4NjE2NjMyNTg1Mzg4NTc5NTQKICA8L3Rocjppbi1yZXBseS10bz4KICA8Y29udGVu" +
      "dD5TYWxtb24gc3dpbSB1cHN0cmVhbSE8L2NvbnRlbnQ-CiAgPHRpdGxlPlNhbG1vbiBz" +
      "d2ltIHVwc3RyZWFtITwvdGl0bGU-CiAgPHVwZGF0ZWQ-MjAwOS0xMi0xOFQyMDowNDow" +
      "M1o8L3VwZGF0ZWQ-CjwvZW50cnk-CiAgICA"
  end

  it 'should parse the payload correctly' do
    @envelope.payload.should ==
      "<?xml version='1.0' encoding='UTF-8'?>\n" +
      "<entry xmlns='http://www.w3.org/2005/Atom'>\n" +
      "  <id>tag:example.com,2009:cmt-0.44775718</id>  \n" +
      "  <author><name>test@example.com</name>" +
      "<uri>bob@example.com</uri></author>\n" +
      "  <thr:in-reply-to xmlns:thr='" +
      "http://purl.org/syndication/thread/1.0'\n" +
      "      ref='tag:blogger.com,1999:blog-893591374313312737."+
      "post-3861663258538857954'>tag:blogger.com,1999:" +
      "blog-893591374313312737.post-3861663258538857954\n" +
      "  </thr:in-reply-to>\n" +
      "  <content>Salmon swim upstream!</content>\n" +
      "  <title>Salmon swim upstream!</title>\n" +
      "  <updated>2009-12-18T20:04:03Z</updated>\n" +
      "</entry>\n  "
  end

  it 'should parse the data type correctly' do
    @envelope.data_type.should == 'application/atom+xml'
  end

  it 'should parse the encoding correctly' do
    @envelope.encoding.should == 'base64url'
  end

  it 'should parse the algorithm correctly' do
    @envelope.algorithm.should == 'RSA-SHA256'
  end

  it 'should parse at least one signature' do
    @envelope.signatures.should_not be_empty
    @envelope.signatures.first.should be_kind_of(Salmon::Signature)
  end
end
