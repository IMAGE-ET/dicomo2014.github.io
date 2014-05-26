#!/bin/ruby
# -*- coding: utf-8 -*-

# CSV形式のセッションの詳細情報から、
# Front matter付きのセッションページを生成

require 'csv'
require 'yaml'
require './_scripts/papercache.rb'

session_data_file = "_data/DICOMO2014_session_data.csv"
session_folder = "_posts/session"

paper = PaperCache.new
reader = CSV.open(session_data_file, "r", {:encoding=>"cp932:utf-8", :skip_blanks=>false, :row_sep=>"\n" })
sessions = {}
detail = false
year = 0
month = 0
day = 0
date = ""
# シンポジウム名
dummy = reader.shift if not reader.eof?
# 日付
dummy = reader.shift
# ヘッダ
header = reader.shift
# ?
dummy = reader.shift
# セッション部屋
row = reader.shift
room = {"a" => row[0], "b" => row[23], "c" => row[46], "d" => row[69],
  "e" => row[92], "f" => row[115], "g" => row[138], "h" => row[161]}

until reader.eof?
  row = reader.shift
  if row.length < 1 then
    next
  elsif /^デモセッション/ =~ row[1] then
    room["ds"] = row[0]
  elsif /^特別講演/ =~ row[1] then
    room["sp"] = row[0]
  elsif /^####/ =~ row[0] then
    detail = true
    puts room
    next
  end
  next unless detail

  str = row[0]
  if /^(?<myear>\d{4}年)(?<mmonth>\d+)月(?<mday>\d+)日/ =~ str then
    date = str
    year = myear.to_i
    month = mmonth.to_i
    day = mday.to_i
    printf "%d/%d/%d", year, month, day
    puts
    next
  elsif /^(?<sid>[\dA-Z]+)\s(?<title>.+)/ =~ str then
    # セッション情報
    ssid = sid.downcase
    session_file_name = sprintf "%d-%02d-%02d-session-%s.html", year, month, day, ssid
    puts "generating " + session_file_name
    session_file_name = session_folder + "/" + session_file_name
    front = {"category" => "session", "layout" => "event"}
    front["title"] = sid + " " + title
    front["pageid"] = ssid
    if /^\d/ =~ ssid then
      front["tags"] = "normal"
    else
      front["tags"] = ssid
    end
    if room[ssid] then
      front["location"] = room[ssid]
    elsif room[ssid[1]] then
      front["location"] = room[ssid[1]]
    end
    row = reader.shift
    # 時間
    if /^(?<sh>\d+):(?<sm>\d+)～(?<eh>\d+):(?<em>\d+)/ =~ row[0] then
      front["start"] = sprintf "%d-%02d-%02d %02d:%02d:00", year, month, day, sh, sm
      front["end"] = sprintf "%d-%02d-%02d %02d:%02d:00", year, month, day, eh, em
    else
      printf "session %s error", session_file_name
      puts
    end
    File.open(session_file_name, "w") do |f|
      f.write YAML.dump(front)
      f.write "---\n"
      row = reader.shift
      if row.length > 0 then
        # 座長
        f.write row[0]
        f.write "\n"
        row = reader.shift # empty
      end
      while not reader.eof? and (row = reader.shift).length > 0 do
        psid = row[0] # セッションサブ番号
        ptime = row[1] # 時間
        pid = row[2] # 論文番号
        pid = row[3] if /^p/ =~ pid
        row = reader.shift # タイトル
        title = row[0]
        f.write <<EOT
<div data-role="collapsible">
EOT
        f.write "<h3>" + psid + ":" + title + "</h3>\n"
        f.write "<p>" + title + "</p>\n"
        if paper.number[pid] then
#          puts "found " + pid
          paperrow = paper.number[pid]
          right = paperrow[14]
# 論文集発行日以降に変更
#          unless /不許可$/ =~ right then
          if /常に許可$/ =~ right then
            abst = paperrow[13] 
            f.write "<blockquote>" + abst + "</blockquote>\n" if abst
          else
            f.write "<blockquote>アブストラクト非公開</blockquote>\n"
          end
        else
          puts "not found " + pid
        end
        f.write "<ul data-role='listview'>\n"
        # 著者情報
        while (row = reader.shift).length > 0 do
          name = row[1]
          org = row[2]
          if /^○/ =~ row[0] then
            name = "発表者：" + name
          end
          f.write "<li>" + name + "(" + org + ")</li>\n"
        end
        f.write "</ul>\n"
        f.write <<EOT
</div>
EOT
      end
    end
  end
#  puts row
end
