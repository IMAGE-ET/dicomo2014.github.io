#!/bin/ruby
# -*- coding: utf-8 -*-

require 'csv'
require 'digest/md5'

$person_data_file = "_data/DICOMO2014参加者-20140612.csv"

class PersonCache

  attr_reader :list, :name, :number

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
      @number[item.id] = item
      if item.public? then
        @name[item.name] = item
      end
    end
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
      @row[1] + " " + @row[2]
    end

    def comment
      @row[81]
    end

    def public?
      self.comment or @papercache.author[self.name] or @sessioncache.chair[self.name]
    end
  end
end
