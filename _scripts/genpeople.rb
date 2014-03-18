#!/bin/ruby
# -*- coding: utf-8 -*-

f = "_data/people.yaml"
File.open(f,'w') do |f|
  f.write <<"EOS"
- id: m0
  name: 野村
  twitter: yoshimov
  facebook: http://facebook.com/yoshimov
  url: http://yoshimov.com
  emailhash: 0bc18dd65dec21f0601e33ada8937ad6
  staff: 実行委員(広報)
  group: なし
  session:
  - id: 1b
    title: 1B:統一テーマ
    role: 発表者
    papertitle: "test"

EOS
  for num in 1..400 do
    f.write "- id: m" + num.to_s + "\n"
    f.write <<"EOS"
  name: test
  twitter: yoshimov
  facebook: http://facebook.com/yoshimov
  url: http://yoshimov.com
  staff: 実行委員(広報)
  group: なし
  session:
  - id: 1b
    title: 1B:統一テーマ
    role: 発表者
    papertitle: "test"

EOS
  end
end
