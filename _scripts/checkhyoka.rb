#!/bin/ruby
# -*- coding: utf-8 -*-

require './_scripts/papercache.rb'
require './_scripts/sessioncache.rb'
require './_scripts/personcache.rb'

$hyoka_file="_data/DICOMO2014_座長_評価委員リストv5.csv"

papercache = PaperCache.new
sessioncache = SessionCache.new
personcache = PersonCache.new(papercache, sessioncache)

reader = CSV.open($hyoka_file, "rt", {:encoding=>"cp932:utf-8", :skip_blanks=>false})
reader.shift #dummy
header = reader.shift
reader.each do |row|
  next unless row[0]
  [row[5],row[7]].each do |name|
    unless name and personcache.byname(name) then
      puts "no registration " + name + " at " + row[0]
    end
  end
end
