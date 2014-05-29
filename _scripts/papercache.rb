#!/bin/ruby
# -*- coding: utf-8 -*-

require 'csv'

$paper_data_file = "_data/DICOMO2014_paper_data.csv"

class PaperCache

  attr_accessor :list, :author, :number

  def initialize()
    @list = []
    @author = {}
    @number = {}
    reader = CSV.open($paper_data_file, "rt", {:encoding=>"cp932:utf-8", :skip_blanks=>false})
    puts "reading paper file: " + $paper_data_file
    # タイトル
    dummy = reader.shift if not reader.eof?
    # ヘッダ
    @header = reader.shift
    reader.each do |row|
      @list << row
      # 登録番号
      @number[row[0]] = row
      # 講演者参加登録番号
      @author[row[28]] = row
#      puts "paper id: " + row[0]
    end
  end
end
