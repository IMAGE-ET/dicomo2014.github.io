#!/bin/ruby
# -*- coding: utf-8 -*-

# CSV形式のセッションの詳細情報から、
# Front matter付きのセッションページを生成

require 'csv'
require 'yaml'
require './_scripts/papercache.rb'
require './_scripts/sessioncache.rb'
require './_scripts/personcache.rb'

papercache = PaperCache.new
sessioncache = SessionCache.new
personcache = PersonCache.new(papercache, sessioncache)

sessioncache.list.each do |session|
  # 論文
  session[:paper].each do |paper|
    psid = paper[:psid]
    paper[:author].each do |author|
      if author[:presenter] then
        puts "" + psid + "," + author[:name]
      end
    end
  end
end
