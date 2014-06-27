#!/bin/ruby
# -*- coding: utf-8 -*-

# CSV形式のセッションの詳細情報から、
# Front matter付きのセッションページを生成

require 'csv'
require 'yaml'
require './_scripts/papercache.rb'
require './_scripts/sessioncache.rb'
require './_scripts/personcache.rb'

$output_folder = "_data"
$qrcode_script = "bash _scripts/genqrcode.sh"
$dicomo_site = "http://dicomo2014.github.io/session/"

papercache = PaperCache.new
sessioncache = SessionCache.new
personcache = PersonCache.new(papercache, sessioncache)

sessioncache.list.each do |session|

  id = session[:id]
  file = "session-" + id + ".png"
  url = $dicomo_site + "session-" + id + "/"
  
  system($qrcode_script + " " + $output_folder + "/" + file + " " + url);
end
