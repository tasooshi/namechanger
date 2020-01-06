# License: BSD-3-Clause (http://opensource.org/licenses/BSD-3-Clause)
# Homepage: https://github.com/tasooshi/namechanger
# Version: 0.9.0

###############
# Environment #
###############

NAME = namechanger
EUID = $(shell id -u -r)
SRC_DIR = $(abspath .)


##########
# Checks #
##########

ifneq ($(EUID), 0)
  $(error This package introduces system-wide changes and must be run as root)
endif


############
# Defaults #
############

NAMECHANGER_DESCRIPTION = Randomizes host name.
NAMECHANGER_HOMEPAGE = https://github.com/tasooshi/namechanger
NAMECHANGER_VERSION = 0.9.0
NAMECHANGER_LICENSE = BSD-3-Clause (http://opensource.org/licenses/BSD-3-Clause)
NAMECHANGER_BIN = /usr/local/bin/$(NAME)
NAMECHANGER_BIN_TEMPLATE = $(SRC_DIR)/shared/bin/$(NAME).sh
NAMECHANGER_SERVICE = /usr/lib/systemd/system/$(NAME).service
NAMECHANGER_SERVICE_TEMPLATE = $(SRC_DIR)/shared/systemd/$(NAME).service
NAMECHANGER_CONF = /etc/default/$(NAME)
NAMECHANGER_CONF_TEMPLATE = $(SRC_DIR)/shared/etc/$(NAME).conf
NAMECHANGER_LOG = /var/log/$(NAME).log
NAMECHANGER_HOSTNAMEGEN = /usr/local/bin/hostnamegen


########################
# OS-specific settings #
########################

OS_NAME = $(shell grep '^ID=' /etc/os-release | cut -d= -f2)

TARGET_OS = targets/$(OS_NAME)/vars

ifeq (,$(wildcard $(TARGET_OS)))
  $(error This operating system is not supported: "$(OS_NAME)")
else
  $(info Operating system identified as: "$(OS_NAME)")
  include $(TARGET_OS)
endif


###########
# Targets #
###########

all:
	$(info Available targets:)
	@grep '^[a-z].*:' Makefile | grep -v ^all | cut -d: -f1 | sort


$(NAMECHANGER_CONF): $(NAMECHANGER_CONF_TEMPLATE)
	$(info Installing configuration...)
	@cp $< $@
	@sed -i 's^{{ hostnamegen }}^$(NAMECHANGER_HOSTNAMEGEN)^' $@
	@sed -i 's^{{ log }}^$(NAMECHANGER_LOG)^' $@
	@sed -i 's^{{ version }}^$(NAMECHANGER_VERSION)^' $@
	@chmod a+rx $@

$(NAMECHANGER_BIN): $(NAMECHANGER_BIN_TEMPLATE)
	$(info Installing executable...)
	@cp $< $@
	@sed -i 's^{{ configuration }}^$(NAMECHANGER_CONF)^' $@
	@sed -i 's^{{ homepage }}^$(NAMECHANGER_HOMEPAGE)^' $@
	@sed -i 's^{{ version }}^$(NAMECHANGER_VERSION)^' $@
	@sed -i 's^{{ license }}^$(NAMECHANGER_LICENSE)^' $@
	@sed -i 's^{{ description }}^$(NAMECHANGER_DESCRIPTION)^' $@
	@chmod a+rx $@


$(NAMECHANGER_SERVICE): $(NAMECHANGER_SERVICE_TEMPLATE)
	$(info Installing service...)
	@cp $< $@
	@sed -i 's^{{ description }}^$(NAMECHANGER_DESCRIPTION)^' $@
	@sed -i 's^{{ executable }}^$(NAMECHANGER_BIN)^' $@
	@sed -i 's^{{ version }}^$(NAMECHANGER_VERSION)^' $@


install: mkinstalldirs $(NAMECHANGER_BIN) $(NAMECHANGER_CONF) $(NAMECHANGER_SERVICE)
	$(info Installing Python dependencies...)
	@pip install wheel
	@pip install hostnamegen==0.9.0
	@systemctl enable $(NAME).service
	@echo "*** NOTE: You might want to enable log rotation for $(NAMECHANGER_LOG)"


uninstall:
	@systemctl disable $(NAME).service
	@rm $(NAMECHANGER_BIN) $(NAMECHANGER_CONF) $(NAMECHANGER_SERVICE)


mkinstalldirs:
	@mkdir -p $(dir \
		$(NAMECHANGER_BIN) \
		$(NAMECHANGER_CONF) \
		$(NAMECHANGER_SERVICE) \
		$(NAMECHANGER_LOG))


.PHONY: all install uninstall mkinstalldirs build
