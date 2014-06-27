#!/bin/ruby
# -*- coding: utf-8 -*-

require 'csv'

$paper_data_file = "_data/DICOMO2014_paper_data.csv"

class PaperCache

  attr_reader :list

  def initialize()
    @list = []
    @author = {}
    @presenterid = {}
    @number = {}
    @index = -1
    reader = CSV.open($paper_data_file, "rt:cp932:utf-8", {:skip_blanks=>false})
    puts "reading paper file: " + $paper_data_file
    # タイトル
    dummy = reader.shift if not reader.eof?
    # ヘッダ
    @header = reader.shift
    reader.each do |row|
      item = PaperItem.new(row)
      if item.reject? then
        next
      end
      @list << item
#      puts "paper id: " + item.id
      # 登録番号
      @number[item.id] = item
      # 講演者参加登録番号
      @presenterid[item.presenterid] = item
      item.authors.each do |author|
        @author[author[:name].downcase] = [] unless @author[author[:name].downcase]
        @author[author[:name].downcase] << item
      end
    end
  end

  def byauthor(name)
    @author[name.downcase]
  end

  def bypresenterid(id)
    @presenterid[id]
  end

  def bynumber(num)
    @number[num]
  end

  class PaperItem
    def initialize(row)
      @row = row
    end

    def id
      @row[0]
    end

    def title
      @row[1]
    end

    # 発表者。更新されていない場合あり
    def presenterid
      @row[28]
    end

    def presentername
      @row[25]
    end

    def presenternum
      @row[24]
    end

    # 論文集発行日以降に変更
    def right?
      /常に許可$/ =~ @row[14]
#      not /不許可$/ =~ row[14]
    end

    def reject?
      /^reject/ =~ @row[44]
    end

    def abstract
      @row[13]
    end

    def sessionid
      @row[46].downcase if @row[46]
    end

    def psid
      @row[49].strip if @row[49]
    end

    def sessiontitle
      title = @row[47]
      title = @row[46] + " " + title if @row[46]
    end

    def authors
      authorlist = []
      index = 68
      num = 1
      while @row[index] do
        if /^[\w\s]+$/ =~ @row[index] then
          name = @row[index + 1] + " " + @row[index]
        else
          name = @row[index] + " " + @row[index + 1]
        end
        author = {:name => name}
        author[:presenter] = (self.presenternum == num)
        authorlist << author
        index += 6
        num += 1
      end
      authorlist
    end

    def isPresenter?(person)
#      self.presenterid == person.id
      self.presentername == person.name or self.presentername == person.alias
    end
  end
end
