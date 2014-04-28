#!/bin/ruby
# -*- coding: utf-8 -*-

# CSV形式のセッションの詳細情報から、
# Front matter付きのセッションページを生成

require 'csv'

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
    sid.downcase!
    session_file_name = sprintf "%d-%02d-%02d-session-%s.md", year, month, day, sid
    puts session_file_name
  end
#  puts line
end
