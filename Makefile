# Tab5 PDA Terminal: rebuild everything from source.
#
#   make setup       pinned Python packages for the CAD scripts
#   make cad         fetch the pinned original STLs, build every STL and run the fit / motion checks
#   make 3mf         print plates for the Bambu Lab A1 mini (cad/3mf/)
#   make verify      rebuild and compare with cad/out/MANIFEST.json (what is committed)
#   make report      slicer estimates and stability warnings (needs prusa-slicer) -> cad/out/print_report.md
#   make sim         the lid closing onto its snap, simulated on the built parts -> cad/out/snap_sim.md
#   make render      README / assembly images (needs Node.js; downloads Chromium for Playwright)
#   make manifest    after a deliberate design change: record the new CAD outputs
PYTHON      ?= python3
ORIGINAL    ?= $(HOME)/phone-enclosure
export PHONE_ENCLOSURE_STL ?= $(ORIGINAL)/STL

.PHONY: all setup original cad 3mf verify report sim manifest render photoreal

all: 3mf

setup:
	$(PYTHON) -m pip install -r cad/requirements.txt

original:
	cad/tools/fetch_original.sh $(ORIGINAL)

cad: original
	cd cad && $(PYTHON) src/build.py

3mf: cad
	cd cad && $(PYTHON) src/export_3mf.py

verify: 3mf
	cd cad && $(PYTHON) tools/manifest.py --check

report: 3mf
	cd cad && $(PYTHON) tools/print_report.py

sim: cad
	cd cad && $(PYTHON) tools/snap_sim.py

# photoreal renders in matte black PLA (Blender Cycles as a Python module: pip install bpy==5.3.0; about 10 min each)
photoreal:
	$(PYTHON) docs/render/photoreal.py --view open
	$(PYTHON) docs/render/photoreal.py --view closed

manifest: 3mf
	cd cad && $(PYTHON) tools/manifest.py --write

render:
	cd docs/render && npm ci && npx playwright install chromium && npm run render
	$(PYTHON) docs/hinge_figure.py docs/images/hinge_screws.png
	$(PYTHON) docs/coupons_figure.py docs/images/plate0_coupons.png
	$(PYTHON) docs/kit_figure.py docs/images/kit_mount.png
	$(PYTHON) docs/snap_figure.py docs/images/panel_snap.png
	$(PYTHON) docs/splice_figure.py docs/images/splice_plates.png
	$(PYTHON) docs/latch_figure.py docs/images/latch.png
	cd cad && $(PYTHON) tools/snap_sim.py --figure ../docs/images/snap_sim.png
