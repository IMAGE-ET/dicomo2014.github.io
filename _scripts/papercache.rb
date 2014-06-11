#!/bin/ruby
# -*- coding: utf-8 -*-

require 'csv'

$paper_data_file = "_data/DICOMO2014_paper_data.csv"

class PaperCache

  attr_reader :list, :author, :authorid, :number

  def initialize()
    @list = []
    @author = {}
    @authorid = {}
    @number = {}
    @index = -1
    reader = CSV.open($paper_data_file, "rt", {:encoding=>"cp932:utf-8", :skip_blanks=>false})
    puts "reading paper file: " + $paper_data_file
    # タイトル
    dummy = reader.shift if not reader.eof?
    # ヘッダ
    @header = reader.shift
    reader.each do |row|
      item = PaperItem.new(row)
      @list << item
#      puts "paper id: " + item.id
      # 登録番号
      @number[item.id] = item
      # 講演者参加登録番号
      @authorid[item.authorid] = item
      item.authors.each do |author|
        @author[author[:name]] = item
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
    @list[++@index]
  end

  class PaperItem
    def initialize(row)
      @row = row
    end

    def id
      @row[0]
    end

    def authorid
      @row[28]
    end

    # 論文集発行日以降に変更
    def right?
      /常に許可$/ =~ @row[14]
#      not /不許可$/ =~ row[14]
    end

    def abstract
      @row[13]
    end

    def authors
      authorlist = []
      index = 68
      while @row[index] do
        author = {:name => @row[index] + " " + @row[index + 1]}
        authorlist << author
        index += 6
      end
      authorlist
    end
  end
end
