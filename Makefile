# what collective(s) are the subject(s)
COLLECTIVES=homebrew brew

# tools
SED=gsed
RG=rg -IN --sort=path
HLEDGER=hledger

# the API URL from which to retrieve
# use COLLECTIVENAME as a variable for the collective, which will be later substituted
CSV_DOWNLOAD_URL=https://rest.opencollective.com/v2/COLLECTIVENAME/transactions.csv?fetchAll=1&includeGiftCardTransactions=1&includeIncognitoTransactions=1&includeChildrenTransactions=1&kind=ADDED_FUNDS%2CCONTRIBUTION%2CEXPENSE%2CHOST_FEE&fields=datetime%2CshortId%2CshortGroup%2Cdescription%2Ctype%2Ckind%2CisRefund%2CisRefunded%2CshortRefundId%2CdisplayAmount%2Camount%2CpaymentProcessorFee%2CnetAmount%2Cbalance%2Ccurrency%2CaccountSlug%2CaccountName%2CoppositeAccountSlug%2CoppositeAccountName%2CpaymentMethodService%2CpaymentMethodType%2CexpenseType%2CexpenseTags%2CpayoutMethodType%2CmerchantId%2CorderMemo

# persisted files calculated from the names of the contents of $(COLLECTIVES)
WITH_OC=$(addprefix oc-,$(COLLECTIVES))
CSVS=$(addsuffix .csv,$(WITH_OC))
JOURNALS=$(CSVS:csv=journal)
ACCOUNTS=$(CSVS:csv=accounts)

varcheck:
	@echo WITH_OC=$(WITH_OC)
	@echo CSVS=$(CSVS)
	@echo JOURNALS=$(JOURNALS)
	@echo ACCOUNTS=$(ACCOUNTS)

help: # list make targets
	@printf "OpenCollective finances analysis for collectives [ $(COLLECTIVES) ]. This mainly manages data, for reports see ./hlfi\nTargets:\n"
	@$(RG) '^(\w[^:]*): [^#]*(# .*)|^# \*\* (.*)' -or '$$3 $$1|$$2' $(MAKEFILE_LIST) | column -t -s'|' || true
# (which have a single-# same-line comment)

help-%: # list make targets matching a pattern
	@make -s help | $(RG) -i "$*" || true

csvs: $(CSVS) # retrieve all CSVs
	@echo "Retrieved $^"

oc-%.csv: .import-oc-%.csv
	(test -f $@ && mv $@ $@.old) || true
	mv $< $@

.PHONY: update-data
update-data: $(addprefix .import-,$(CSVS))

# TODO: figure out how best to make this run no more than once per day
#       probably need to just put the date in it
.import-oc-%.csv:
	curl -o $@ "$(subst COLLECTIVENAME,$*,$(CSV_DOWNLOAD_URL))"

#.INTERMEDIATE: $(addprefix .import-,$(CSVS))


journals: $(JOURNALS) # regenerate all journals


# these options require a newer hledger than what's currently available in Ubuntu 20.04
# TODO: make codespace use newer than 20.04, maybe just use Homebrew base?
HLEDGER_NEWER_OPTIONS=-c '1.00 USD' --round=soft

oc-%.journal: oc-%.csv oc.csv.rules  # regenerate journal from csv
	((printf "include oc-$*.accounts\n\n"; $(HLEDGER) -f $< print -x --rules-file=oc.csv.rules $(HLEDGER_NEWER_OPTIONS)) > $@.new && mv $@.new $@) || (rm -f $@.new; false)

.PHONY: accounts
accounts: $(ACCOUNTS)

# This preserves the existing content of oc.accounts, may need to clean that manually from time to time.
oc-%.accounts: oc-%.journal  # declare any new accounts found in the journal
	((cat oc.accounts; $(HLEDGER) -f $< accounts --undeclared --directives) | sort > $@.new && mv $@.new $@) || (rm -f $@.new; false)

oc.journal: $(JOURNALS)
	cat $(JOURNALS) > $@

CHECKS=accounts commodities balanced ordereddates
check:  # check the journal for problems
	@printf "checking journal.. "
	@$(HLEDGER) -f oc.journal check $(CHECKS) && echo "all ok ✅"

journal: oc.journal oc.accounts check Makefile  # make oc.journal + oc.accounts + check

README.md: journal Makefile  # update reports and charts in README.md
	$(SED) '/<!-- REPORTS: -->/q' README.md >.README.md
	./hlfi reports -O html >>.README.md
	echo >>.README.md
	echo '```' >>.README.md
	./hlfi b-a >>.README.md
	echo '```' >>.README.md
	echo '```' >>.README.md
	./hlfi b-r >>.README.md
	echo '```' >>.README.md
	echo '```' >>.README.md
	./hlfi b-x >>.README.md
	echo '```' >>.README.md
	echo '```' >>.README.md
	./hlfi l-a >>.README.md
	echo '```' >>.README.md
	echo '```' >>.README.md
	./hlfi l-r >>.README.md
	echo '```' >>.README.md
	echo '```' >>.README.md
	./hlfi l-x >>.README.md
	echo '```' >>.README.md
	$(SED) -E -z 's/<style>[^>]+><link[^>]+>/\n<br>\n/g' <.README.md >README.md  # remove HTML reports' CSS
	rm -f .README.md

update:  # make journal + README.md and commit both
	@make README.md
	git commit -m "update csv"      -- $(CSVS)          || echo "csv has not changed"
	git commit -m "update journal"  -- $(JOURNALS)      || echo "journal has not changed"
	git commit -m "update accounts" -- $(ACCOUNTS)     || echo "accounts have not changed"
	git commit -m "update readme reports" -- README.md || echo "readme reports have not changed"

