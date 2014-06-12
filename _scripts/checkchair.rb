#!/bin/ruby
# -*- coding: utf-8 -*-

require './_scripts/papercache.rb'
require './_scripts/sessioncache.rb'
require './_scripts/personcache.rb'

papercache = PaperCache.new
sessioncache = SessionCache.new
personcache = PersonCache.new(papercache, sessioncache)

sessioncache.list.each do |session|
  next unless session[:chairname]
  chair = session[:chairname]
  unless personcache.byname(chair) then
    puts "no registration " + chair + " at " + session[:id]
  end
end
