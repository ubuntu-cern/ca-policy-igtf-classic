# Makefile to generate a IGTF debian package

include VERSION

PACKAGE = ca-policy-igtf-classic-$(VERSION)
BASEURL = https://dist.eugridpma.info/distribution/igtf/current/accredited/
BUNDLE = igtf-preinstalled-bundle-classic-$(VERSION).tar.gz
BUILD = build

$(BUNDLE):
	wget $(BASEURL)/$(BUNDLE)

install: $(BUNDLE)
	install -m 0775 -d ${prefix}/etc/grid-security/certificates
	tar -xzf $(PWD)/$(BUNDLE) -C ${prefix}/etc/grid-security/certificates
	chmod 0644 ${prefix}/etc/grid-security/certificates/*

tarball: $(BUNDLE)
	mkdir $(PACKAGE)
	cp $(BUNDLE) Makefile VERSION $(PACKAGE)/
	tar -czf $(PACKAGE).tar.gz $(PACKAGE)
	rm -rf $(PACKAGE)

deb: tarball
	-rm -rf $(BUILD)
	mkdir -p $(BUILD)
	cp $(PACKAGE).tar.gz $(BUILD)/$(PACKAGE).orig.tar.gz
	tar -C $(BUILD) -xzf $(BUILD)/$(PACKAGE).orig.tar.gz
	cp -a debian $(BUILD)/$(PACKAGE)/
	(cd $(BUILD)/$(PACKAGE); debuild -b)
	cp $(BUILD)/*.deb .

changelog:
	dch -v $(VERSION)

clean:
	-rm -rf $(BUNDLE) $(BUILD)

