#!/bin/ruby
# -*- coding: utf-8 -*-

require './_scripts/papercache.rb'
require './_scripts/sessioncache.rb'
require './_scripts/personcache.rb'

papercache = PaperCache.new
sessioncache = SessionCache.new
personcache = PersonCache.new(papercache, sessioncache)

sessioncache.list.each do |session|
  next unless session[:paper]
  session[:paper].each do |paper|
    paper[:author].each do |author|
      if author[:presenter] and not personcache.byname(author[:name]) then
        puts "no registration " + author[:name] + " at " + paper[:psid]
      end
    end
  end
end
