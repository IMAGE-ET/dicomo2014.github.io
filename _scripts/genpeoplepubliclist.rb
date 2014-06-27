#!/bin/ruby
# -*- coding: utf-8 -*-

# CSV形式の参加者一覧から、
# Web公開可能な参加者の一覧を生成

require 'csv'
require 'yaml'
require './_scripts/papercache.rb'
require './_scripts/sessioncache.rb'
require './_scripts/personcache.rb'

$public_list = "_data/peoplepublic_list.csv"

papercache = PaperCache.new
sessioncache = SessionCache.new
personcache = PersonCache.new(papercache, sessioncache)

CSV.open($public_list, "wb:cp932") do |writer|
  personcache.list.each do |person|
    writer << [person.id, person.public?.to_s]
  end
end
