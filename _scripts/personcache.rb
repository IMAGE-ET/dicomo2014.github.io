#!/bin/ruby
# -*- coding: utf-8 -*-

require 'csv'

$person_data_file = "_data/DICOMO2014参加者-20140611.csv"

class PersonCache

  attr_reader :list, :name, :number

  def initialize(papercache)
    @papercache = papercache
    @list = []
    @name = {}
    @number = {}
    @index = -1
    reader = CSV.open($person_data_file, "rt", {:encoding=>"cp932:utf-8", :skip_blanks=>false})
    puts "reading person file: " + $person_data_file
    @header = reader.shift
    reader.each do |row|
      next if row.length < 1
      item = PersonItem.new(@papercache, row)
      @list << item
#      puts "person id: " + item.id
#      puts item.name
      @number[item.id] = item
      if item.public? then
        @name[item.name] = item
      end
    end
  end

  def size
    @list.size
  end

  def hasNext?
    @list.size - 1 > @index
  end

  def next
    @index += 1 if @list.size - 1 > @index
    @list[@index]
  end

  class PersonItem
    def initialize(papercache, row)
      @papercache = papercache
      @row = row
    end

    def id
      @row[35]
    end

    def name
      @row[1] + " " + @row[2]
    end

    def comment
      @row[81]
    end

    def public?
      self.comment or @papercache.author[self.name]
    end
  end
end
