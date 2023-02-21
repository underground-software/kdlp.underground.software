# A template for near-instantaneous deployment of websites
# Copyright (C) 2019 Joel Savitz and Chris Odom

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

CC 	= markdown
LD	= cat
LDFLAGS = -
HEADER 	= header nav
SRCDIR  = src
DOCDIR  = docs
SLDIR	= slides
DOCS 	= $(patsubst $(SRCDIR)/%.md, %.html, $(shell find $(SRCDIR) -wholename '*.md'))
SLIDES	= $(patsubst $(SLDIR)/%.md, $(DOCDIR)/%.html, $(shell find $(SLDIR) -wholename '*.md'))

.PHONY: all sl clean

all: $(DOCDIR) $(DOCS) $(SLIDES)
	@echo Generating Website...

%.html: $(SRCDIR)/%.md
	$(shell $(CC) $^ | $(LD) $(HEADER) $(LDFLAGS) > $(patsubst %.html, $(DOCDIR)/%.html, $@))

$(DOCDIR):
	mkdir $(DOCDIR)

$(DOCDIR)/%.html: $(SLDIR)/%.md
	
	marp $^ --output=./$@ --template=bare

clean:
	rm -rf $(patsubst %, $(DOCDIR)/%, $(DOCS))
