RUBY=ruby
SCRIPTDIR=_scripts

all:\
	gensession\
	genpeople\
#	checkall

gensession:
	rm -rf _posts/generated
	mkdir -v _posts/generated
	$(RUBY) $(SCRIPTDIR)/gensession.rb

genpeople:
	rm -rf _posts/people
	mkdir -v _posts/people
	$(RUBY) $(SCRIPTDIR)/genpeople.rb

genpresenterlist:
	$(RUBY) $(SCRIPTDIR)/genpresenterlist.rb | grep -v 'reading' | iconv -t cp932 > _data/presenter_list.csv

checkall:\
	checkchair\
	checkhyoka\
	checkpresenter

checkchair:
	$(RUBY) $(SCRIPTDIR)/checkchair.rb

checkhyoka:
	$(RUBY) $(SCRIPTDIR)/checkhyoka.rb

checkpresenter:
	$(RUBY) $(SCRIPTDIR)/checkpresenter.rb
