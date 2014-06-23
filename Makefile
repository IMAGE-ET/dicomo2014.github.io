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

gensessionlist:
	$(RUBY) $(SCRIPTDIR)/gensessionlist.rb

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
