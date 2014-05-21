#!/bin/ruby
# -*- coding: utf-8 -*-

# CSV形式のセッションの詳細情報から、
# Front matter付きのセッションページを生成

require 'csv'
require 'yaml'

session_data_file = "_data/DICOMO2014_session_data.csv"
session_folder = "_posts/session"

reader = CSV.open(session_data_file, "r", {:encoding=>"cp932:utf-8", :skip_blanks=>false, :row_sep=>"\n"})
sessions = {}
detail = false
year = 0
month = 0
day = 0
date = ""
until reader.eof?
  line = reader.shift
  if line.length < 1 then
    next
  elsif /^####/ =~ line[0] then
    detail = true
    next
  end
  next unless detail

  str = line[0]
  if /^(?<myear>\d{4}年)(?<mmonth>\d+)月(?<mday>\d+)日/ =~ str then
    date = str
    year = myear.to_i
    month = mmonth.to_i
    day = mday.to_i
    printf "%d/%d/%d", year, month, day
    puts
    next
  elsif /^(?<sid>\d[A-Z])\s(?<title>.+)/ =~ str then
    # セッション情報
    ssid = sid.downcase
    session_file_name = sprintf "%d-%02d-%02d-session-%s.html", year, month, day, ssid
    puts session_file_name
    session_file_name = session_folder + "/" + session_file_name
    front = {"category" => "session", "layout" => "event"}
    front["title"] = sid + " " + title
    front["pageid"] = ssid
    line = reader.shift
    # 時間
    if /^(?<sh>\d+):(?<sm>\d+)～(?<eh>\d+):(?<em>\d+)/ =~ line[0] then
      front["start"] = sprintf "%d-%02d-%02d %02d:%02d:00", year, month, day, sh, sm
      front["end"] = sprintf "%d-%02d-%02d %02d:%02d:00", year, month, day, eh, em
    else
      printf "session %s error", session_file_name
      puts
    end
    File.open(session_file_name, "w") do |f|
      f.write YAML.dump(front)
      f.write "---\n"
      # 座長
      line = reader.shift
      f.write line[0]
      f.write "\n"
      line = reader.shift # empty
      while (line = reader.shift).length > 0 do
        psid = line[0] # セッションサブ番号
        ptime = line[1] # 時間
        pid = line[2] # 論文番号
        line = reader.shift # タイトル
      f.write <<EOT
<div data-role="collapsible">
EOT
        f.write "<h3>" + psid + ":" + line[0] + "</h3>\n"
        f.write "<p>" + line[0] + "</p>\n"
      f.write <<EOT
</div>
EOT
        # 著者を読み飛ばす
        line = reader.shift while line.length > 0
      end
    end
  end
#  puts line
end
