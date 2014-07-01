#!/bin/ruby
# -*- coding: utf-8 -*-

# CSV形式の参加者一覧から、
# 参加者のページを生成

require 'csv'
require 'yaml'
require './_scripts/papercache.rb'
require './_scripts/sessioncache.rb'
require './_scripts/personcache.rb'

$output_folder = "_data"
$qrcode_script = "bash _scripts/genqrcode.sh"
$dicomo_site = "http://dicomo2014.github.io/people/"

papercache = PaperCache.new
sessioncache = SessionCache.new
personcache = PersonCache.new(papercache, sessioncache)

personcache.list.each do |person|
  unless person.public? then
    puts "not public: #{person.id}"
    system("cp null.png #{person.id}.png")
    next
  end

  system("#{$qrcode_script} #{$output_folder}/#{person.id}.png " +
         "#{$dicomo_site}#{person.id}/");
end
