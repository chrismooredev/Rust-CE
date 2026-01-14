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

override LTOFILES = $(LINK_CSOURCES) $(LINK_CPPSOURCES) $(if $(RSENTRY),incremental/rust.bc)

include $(shell cedev-config --makefile)

# The CE-Programming project uses .bc files for this step,
# but we're using .ll files here so we could potentially map the target from wasm32 to ez80
# bc/ir is just a matter of changing extensions (bc/ll) and --emit=llvm-(bc/ir)
incremental/rust.bc: $(RSSOURCES)
	$(Q)$(call MKDIR,$(@D))
	$(Q)echo "[compiling] $(call NATIVEPATH,$(RSENTRY)) due to modifed $(call NATIVEPATH,$?)"

#   a good next step here would be figure out how to compile for ez80 directly

# nightly 2022-03-09 is the closest nightly to the ez80 LLVM branch of the CE-Programming project
# using such a similar (major) LLVM version gets us a codegen clang crash instead of an IR syntax error
	pwsh -NoProfile -Command '$$env:RUSTFLAGS="-C panic=abort -C debuginfo=0 --emit=llvm-ir -C opt-level=0"; cargo +nightly-2022-08-13 build --verbose -Z build-std=core --target=wasm32-unknown-unknown --release'

#	pre-link the rust code to keep from incorporating the hashed, numerous, and undeterministic rust object filenames into the makefile rules
#   yes the compiler_builtins glob is why we're using powershell
	pwsh -NoProfile -Command 'ez80-link -o incremental/rust.bc @(Get-ChildItem .\target\wasm32-unknown-unknown\release\deps\*.ll | Where-Object { $$_.Name -NotLike "compiler_builtins-*.ll" }).FullName'

#   building with this IR is a bit of a hack, but it works for this demo
#   it emits (at least) two warnings due to the mismatching architectures:
#   ez80 target from jac0bly/CE-Programming project's LLVM branch, and Rust's wasm32-unknown-unknown
#   - Linking two modules of different data layouts
#   - Linking two modules of different target triples
