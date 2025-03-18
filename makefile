# ----------------------------
# Makefile Options
# ----------------------------

NAME = DEMO
DESCRIPTION = "CE Rust Toolchain Demo"
COMPRESSED = NO

CFLAGS = -Wall -Wextra -Oz
CXXFLAGS = -Wall -Wextra -Oz
RSFLAGS = --edition=2021 -C opt-level=0

# if opt-level != 0, presumably fixable with better matching LLVM versions
# error: unterminated attribute group
# attributes #1 = { nofree norecurse noreturn nosync nounwind memory(none) "target-cpu"="generic" }

# ----------------------------

# wildcard match for lib.rs - ignore Rust if missing
RS_EXTENSION = rs
RSENTRY = $(wildcard $(SRCDIR)/lib.$(RS_EXTENSION))
RSSOURCES = $(sort $(call rwildcard,$(SRCDIR),*.$(RS_EXTENSION)))
LINK_RSSOURCES = $(call UPDIR_ADD,$(RSENTRY:$(SRCDIR)/%.$(RS_EXTENSION)=$(OBJDIR)/%.$(RS_EXTENSION).ll))

override LTOFILES = $(LINK_CSOURCES) $(LINK_CPPSOURCES) $(LINK_RSSOURCES)

include $(shell cedev-config --makefile)

# The CE-Programming project uses .bc files for this step,
# but we're using .ll files here so we could potentially map the target from wasm32 to ez80
# bc/ir is just a matter of changing extensions (bc/ll) and --emit=llvm-(bc/ir)
$(LINK_RSSOURCES): $(RSSOURCES) # $(EXTRA_HEADERS) $(MAKEFILE_LIST) $(DEPS)
	$(Q)$(call MKDIR,$(@D))
	$(Q)echo [compiling] $(call NATIVEPATH,$(RSENTRY)) due to modifed $(call NATIVEPATH,$?)

#   a good next step here would be figure out how to compile for ez80 directly
	$(Q)rustc --target=wasm32-unknown-unknown --emit=llvm-ir -C debuginfo=0 $(RSFLAGS) $(call QUOTE_ARG,$(RSENTRY)) -o $(call QUOTE_ARG,$@)

#   building with this IR is a bit of a hack, but it works for this demo
#   it emits (at least) two warnings due to the mismatching architectures:
#   ez80 target from jac0bly/CE-Programming project's LLVM branch, and Rust's wasm32-unknown-unknown
#   - Linking two modules of different data layouts
#   - Linking two modules of different target triples

#   no windows sed.. it just silences a warning anyway
#	$(Q)sed -i "s/wasm32-unknown-unknown/ez80/" $(call QUOTE_ARG,$@)
