#!/bin/ruby
# -*- coding: utf-8 -*-

# CSV形式の表彰一覧に所属を追加する


require 'csv'
require 'yaml'
require './_scripts/papercache.rb'
require './_scripts/sessioncache.rb'
require './_scripts/personcache.rb'

$org_list = "_data/表彰結果まとめ_公開.csv"
$dest_list = "_data/commendation_list.csv"

papercache = PaperCache.new
sessioncache = SessionCache.new
personcache = PersonCache.new(papercache, sessioncache)

CSV.open($dest_list, "wb:cp932") do |writer|
  reader = CSV.open($org_list, "rt:cp932:utf-8")
  header = reader.shift
  reader.each do |row|
    next unless row[1]
    paper = sessioncache.bypsid(row[2])
    unless paper then
      puts "paper #{row[2]} not found"
      next
    end
    paper[:author].each do |author|
      if author[:name] == row[3] then
        row[3] = "#{row[3]}（#{author[:org]}）"
        puts row[3]
      end
    end
    writer << [row[1],row[2],row[5],row[3]]
  end
end
