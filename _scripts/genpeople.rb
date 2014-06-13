#!/bin/ruby
# -*- coding: utf-8 -*-

# CSV形式の参加者一覧から、
# 参加者のページを生成

require 'csv'
require 'yaml'
require './_scripts/papercache.rb'
require './_scripts/sessioncache.rb'
require './_scripts/personcache.rb'

person_folder = "_posts/people"

papercache = PaperCache.new
sessioncache = SessionCache.new
personcache = PersonCache.new(papercache, sessioncache)

personcache.list.each do |person|
  unless person.public? then
    puts "not public: " + person.id
    next
  end
  person_file = ""
  if /^(?<year>\d+)\/(?<month>\d+)\/(?<day>\d+)/ =~ person.registdate then
    person_file = sprintf "%d-%02d-%02d-%4d.md", year, month, day, person.id
  else
    puts "date error: " + person.id
    next
  end
  person_path = person_folder + "/" + person_file
  puts "generating: " + person_path

  front = {"category" => "people", "layout" => "people"}
  front["title"] = person.name
  front["yomi"] = person.yomi
  front["pageid"] = person.id
  front["emailhash"] = person.emailhash
  sessionlist = []
  papers = papercache.byauthor(person.name)
  if person.alias then
    papers = [] unless papers
    papers.concat(papercache.byauthor(person.alias))
  end
  if papers then
    papers.each do |paper|
      pitem = {"title"=>paper.title, "psid"=>paper.psid,
        "sessiontitle"=>paper.sessiontitle, "sessionid"=>paper.sessionid}
      if paper.isPresenter?(person) then
        pitem["role"] = "発表者"
      else
        pitem["role"] = "著者"
      end
      sessionlist << pitem
    end
  end
  session = sessioncache.bychair(person.name)
  session = sessioncache.bychair(person.alias) if person.alias and not session
  if session then
    sitem = {"sessiontitle"=>session[:title], "role"=>"座長",
      "sessionid"=>session[:id]}
    sessionlist << sitem
  end
  front["session"] = sessionlist if sessionlist.length > 0
  File.open(person_path, "wb") do |f|
    f.write YAML.dump(front)
    f.write "---\n"
    f.write person.comment
  end #file
end
