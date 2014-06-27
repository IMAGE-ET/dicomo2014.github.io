#!/bin/ruby
# -*- coding: utf-8 -*-

require 'csv'

$session_data_file = "_data/DICOMO2014_session_data.csv"

class SessionCache

  attr_reader :list

  def initialize()
    @index = -1
    @list = []
    @author = {}
    @number = {}
    @chair = {}
    reader = CSV.open($session_data_file, "rt:cp932:utf-8",
                      {:skip_blanks=>false})
    puts "reading session file: " + $session_data_file
    detail = false
    year = 0
    month = 0
    day = 0
    date = ""

    # シンポジウム名
    dummy = reader.shift if not reader.eof?
    # 日付
    dummy = reader.shift
    # ヘッダ
    @header = reader.shift
    # ?
    dummy = reader.shift
    # セッション部屋（今は不要）
    row = reader.shift

    until reader.eof?
      row = reader.shift
      if row.length < 1 then
        next
      elsif /^####/ =~ row[0] then
        detail = true
        next
      end
      next unless detail

      str = row[0]
      if /^(?<myear>\d{4}年)(?<mmonth>\d+)月(?<mday>\d+)日/ =~ str then
        date = str
        year = myear.to_i
        month = mmonth.to_i
        day = mday.to_i
#        printf "%d/%d/%d", year, month, day
#        puts
        next
      elsif /^(?<sid>[\dA-Z]+)\s(?<title>.+)/ =~ str then
        # セッション情報
        ssid = sid.downcase
        item = {} #SessionItem.new(ssid)
        item[:id] = ssid
        item[:year] = year
        item[:month] = month
        item[:day] = day
        item[:title] = sid + " " + title
        row = reader.shift
        # 時間
        if /^(?<sh>\d+):(?<sm>\d+)～(?<eh>\d+):(?<em>\d+)/ =~ row[0] then
          item[:start] = sprintf "%02d:%02d", sh, sm
          item[:end] = sprintf "%02d:%02d", eh, em
        else
          printf "session %s time error", ssid
          puts
        end
        row = reader.shift
        # 部屋
        if /^部屋:\s(?<room>.+)/ =~ row[0] then
          item[:location] = room
        else
          printf "session %s room error", ssid
          puts
        end
        row = reader.shift
        # 座長
        if row.length > 0 and /^座長:\s(?<chairname>.+)\s\((?<chairorg>.+)\)/ =~ row[0] then
          item[:chairname] = chairname
          item[:chairorg] = chairorg
          @chair[chairname.downcase] = item
          row = reader.shift # empty
        end
        paperlist = []
        while not reader.eof? and (row = reader.shift).length > 0 do
          paper = {}
          paper[:sessionid] = ssid
          paper[:psid] = row[0]
          if /^p\.\s*(?<pagenum>\d+)/ =~ row[2] then
            paper[:pagenum] = pagenum
          end
          paper[:id] = row[3]
          # タイトル
          row = reader.shift
          paper[:title] = row[0]
          authorlist = []
          # 著者情報
          while (row = reader.shift).length > 0 do
            author = {}
            author[:name] = row[1]
            author[:org] = row[2]
            if /^○/ =~ row[0] then
              author[:presenter] = true
            else
              author[:presenter] = false
            end
            @author[author[:name].downcase] = [] unless @author[author[:name].downcase]
            @author[author[:name].downcase] << paper
            authorlist << author
          end #author
          paper[:author] = authorlist
          paperlist << paper
        end #paper
        item[:paper] = paperlist
        @list << item
        @number[item[:id]] = item
      end #session
    end #until
  end #initialize

  def byauthor(name)
    @author[name.downcase]
  end

  def bychair(name)
    @chair[name.downcase]
  end

  def bynumber(num)
    @number[num]
  end
end
