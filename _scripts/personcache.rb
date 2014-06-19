#!/bin/ruby
# -*- coding: utf-8 -*-

require 'csv'
require 'digest/md5'

$person_data_file = "_data/DICOMO2014参加者-20140619.csv"

class PersonCache

  attr_reader :list

  def initialize(papercache, sessioncache)
    @papercache = papercache
    @sessioncache = sessioncache
    @list = []
    @name = {}
    @number = {}
    @chair = {}
    @index = -1
    reader = CSV.open($person_data_file, "rt", {:encoding=>"cp932:utf-8", :skip_blanks=>false})
    puts "reading person file: " + $person_data_file
    @header = reader.shift
    reader.each do |row|
      next if row.length < 1
      next unless row[0]
      item = PersonItem.new(@papercache, @sessioncache, row)
      @list << item
#      puts "person id: " + item.id
#      puts item.name
      puts "number duplication " + item.id if @number[item.id]
      @number[item.id] = item
      puts "name duplication " + item.name if @name[item.name.downcase]
      puts "alias duplication " + item.alias if item.alias and @name[item.alias.downcase]
#      if item.public? then
        @name[item.name.downcase] = item
        @name[item.alias.downcase] = item if item.alias
#      end
    end
  end

  def byname(name)
    @name[name.downcase]
  end

  def bynumber(num)
    @number[num]
  end

  class PersonItem
    def initialize(papercache, sessioncache, row)
      @papercache = papercache
      @sessioncache = sessioncache
      @row = row
    end

    def id
      @row[35]
    end

    def registdate
      @row[34]
    end

    def emailhash
      Digest::MD5.hexdigest(@row[33].strip.downcase)
    end

    def name
      if /^[\w\s]+$/ =~ @row[1] then
        @row[2] + " " + @row[1]
      else
        @row[1] + " " + @row[2]
      end
    end

    def yomi
      @row[3] + " " + @row[4]
    end

    def alias
      @row[85]
    end

    def comment
      @row[81]
    end

    def public?
      if self.comment or @papercache.byauthor(self.name) or @sessioncache.bychair(self.name) then
        true
      elsif self.alias and (@papercache.byauthor(self.alias) or @sessioncache.bychair(self.alias)) then
        true
      else
        false
      end
    end
  end
end
