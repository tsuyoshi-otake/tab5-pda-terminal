# Tab5 PDA Terminal: the enclosure

A clamshell for an **M5Stack Tab5** (in the lid) and a **CACOE keyboard** (in the tray), 3D-printed, with two Sugatsune
HG-MF08 torque hinges. It is a variant of the enclosure of
[PaperDIY PDA Terminal](https://github.com/tsuyoshi-otake/paperdiy-pda-terminal), which is itself derived from
[phone-enclosure](https://github.com/unkyulee/phone-enclosure) by Un Kyu Lee. Japanese overview: [../README.md](../README.md);
assembly: [ASSEMBLY_ja.md](ASSEMBLY_ja.md); parts list: [bom.csv](bom.csv).

**Status: designed, not printed.** The Tab5's dimensions are read from M5Stack's size drawing and housing model; nothing
has been checked against a real Tab5. The design this derives from has been built once; its latest changes (the relief
at the hinge side, the snap) are unprinted there too.

## Run

```sh
make setup     # pinned Python packages
make 3mf       # fetch the pinned original STLs, build all STLs (with fit and motion checks) and the print plates
make verify    # rebuild and compare with out/MANIFEST.json
make report    # needs prusa-slicer: print time, filament, hinge margin, tipping -> out/print_report.md
make sim       # the lid closing onto its snap, simulated on the built parts -> out/snap_sim.md
make render    # images (Node.js, Playwright's Chromium, matplotlib with a Japanese font)
```

Everything is rebuilt from `src/params.py` + `src/build.py`; `tools/manifest.py` records the hashes of what is committed
and CI (`.github/workflows/build.yml`) rebuilds and compares on every push.

## What is new against the PaperDIY version

The code is the PaperDIY version's with the Tab5 in the place of the PaperDIY Complete Kit, so the parameters keep their
`KIT_*` names: "the kit" in `params.py`, `build.py` and the build log is the Tab5. Code and parameters of the earlier
designs (bare PaperDIY, magnets, push-rods, panel-mount USB-C lids) are still in the files and are not built.

| | PaperDIY version | here |
| --- | --- | --- |
| device in the lid | Complete Kit 120 × 67 × 6.3 mm, 43 g | Tab5 128 × 80 × 12 mm, 120.9 g (no battery) |
| lid | top slopes, 23.8 / 26.4 mm closed | flat top, 29.8 mm closed (`kit_lid_top`: flat when the device needs more than the hinge) |
| window | 105 × 59.7 | 110.7 × 62.3 (+0.3 a side), centred in the lid; 0.6 mm off the Tab5's middle across |
| ports | USB-C at the left end, y −24, at the kit's front face | a **port bay** left of the Tab5: power button, USB-A, USB-C, headset jack and Grove reachable through the panel, plugs in through openings in the left end wall (`KIT_PORTS`, `PORT_BAY`; below) |
| panel | KEY slot + guard, power slot, 6 screws | camera hole, 2 microphone holes, the port bay (joined with the slot beside the power button), 4 screws (corners) + 2 pillars without a screw right of the Tab5 (`PANEL_PILLARS`) |
| snap's flex zone | to 2 mm below the ceiling | to 8 mm below the ceiling (the same 11.9 mm of height in a taller wall): 19.1 N/mm, strain 0.33 % at 0.40 mm |
| split (A1 mini) | lid x −72, panel x −74.2 (left ends) | lid x +72, panel x +75 (right ends, so the port bay is in one piece with a whole ceiling); one splice plate each; the tray still at x −72 |
| tray, hinges, covers, snap lip and groove, relief at the hinge side | | unchanged (the tray is the same part) |

### The Tab5 in the lid

Tab5 frame, seen from the screen: x to the right, y up. The size drawing is in first-angle projection (the view drawn to
the right of the front view is the left side), which the housing model and the pin map confirm: the power button, USB-A, USB-C, 3.5 mm
headset jack and PORT.A (Grove) are on the **left** edge, in that order from the top, the battery bay and the camera on the right, the speaker and the 1/4" nut
on the bottom edge. In the lid the Tab5 lies screen down with its left edge toward −x (the lid's left end) and its top
edge toward −y (the lid's front), so the screen is upright when the lid is open.

| read from | value | parameter |
| --- | --- | --- |
| size drawing, `Tab5.stl` | body 128.0 × 80.0 × 12.0, corner r 4 | `KIT_L`, `KIT_W`, `KIT_T`, `KIT_R` |
| size drawing | visible area x 6.0…116.4, y 9.8…71.4 (from the lower left) | `KIT_WIN_OFF` −2.8, `KIT_WIN_OFF_Y` −0.6; size = the 5" 16:9 active area |
| size drawing | camera Ø5, 4.45 from the right edge, half way up | `KIT_CAMERA` |
| size drawing | two microphone holes in the top bezel, 23.2 and 57.5 from the left, 3.3 below the top edge | `KIT_MICS` |
| `Tab5.stl`, size drawing (left side view) | USB-C opening 36.7…45.1 mm from the bottom edge, 7.2…9.7 behind the screen face | `KIT_USB_Y` 0, `KIT_USB_Z` (7.2, 9.7) |
| size drawing (left side view) | power button 7.5…16.7 mm below the top edge (`Tab5.stl`: 8.0…16.0) | `KIT_PWR_CAP_Y` (−32.5, −23.3) |
| size drawing (left side view) | USB-A receptacle 19.0…31.1 mm below the top edge, its shell from the back face to 5.2 behind the screen | `KIT_PORTS` usb_a: y −15.0, axis 8.6 behind the screen face |
| size drawing (left side view) | headset jack: round opening Ø6.2, 53.0 below the top edge, its centre 3 mm in front of the back face | `KIT_PORTS` jack: y 13.0, axis 9.0 |
| size drawing (left side view) | Grove (HY2.0-4P): 4 pins at 2 mm pitch round 66.0 below the top edge, 9.0 behind the screen face | `KIT_PORTS` grove: y 26.0, axis 9.3 |
| docs.m5stack.com | 120.9 g without battery | `KIT_MASS_G` |

The drawing is a bitmap (9.84 px/mm along the edge); positions read from it are good to about ±0.5 mm, read at the
centres of its lines. Where the housing model has the same feature (the power button's opening, the USB-C) the two agree
to 0.4 mm; the housing model has no openings for USB-A, the jack and Grove, so those three come from the drawing only.

The Tab5 is held between the bezel panel (a 2 mm rim round it, 0.2 mm a side) and three ribs from the ceiling on its back
cover (`KIT_RIBS_X`, left of the battery bay), 0.2 mm behind it. Nothing uses its M3 threads.

![How the Tab5 sits in the lid](../docs/images/kit_mount.png)

### The port bay

The Tab5's left edge (its ports) is 37.8 mm inside the lid's left end wall. That space is the **port bay**:

- **Panel**: open from a 3 mm frame along its left edge to the rim round the Tab5, over y −24.5…32.5, joined with the
  slot beside the power button (`port_bay_panel_cut`). The rim stays, so the Tab5 is still located at its corners.
- **End wall**: an opening per plug (`port_lanes`): the plug's size + 0.5 mm a side, merged where two come closer than
  2 mm. USB-A + USB-C: y −23.5…6.5, 4.1…13.0 mm behind the screen face; headset: y 8.75…17.25, 4.75…13.0; Grove:
  y 20.5…31.5, 6.3…12.2. Posts of 2.25 and 3.25 mm between them.
- **Ceiling**: nothing hangs in the bay (no guide ribs, no pillars: fingers need the room). The ports sit near the
  Tab5's back, so a 16 × 8 USB-A overmold and a Ø7.5 headset plug stand 0.4–0.6 mm above it; over those lanes (and the
  USB-C one between them) the ceiling is thinned from inside to 1.2 mm, end wall to Tab5, which leaves them 0.4 and
  0.25 mm. The lid's height does not change.
- A plug goes in through its opening (the cable stays there); a finger in the bay guides it into the port and pushes it
  home. Plugs to make room for (`KIT_PORTS` `plug`): USB-A 16 × 8 mm, USB-C 12 × 6.5, headset Ø7.5, Grove 10 × 5, all
  straight. With all four in, the nearest two are 1 mm apart. With the lid shut the bay faces the keyboard and the
  cables leave by the left end.
- The build checks each plug with a Ø4 cable out through the wall against the lid, the panel, the tray and the other
  plugs (`port_plugs`, `port_bay_log`).
- To keep the bay's ceiling whole, the A1 mini split of the lid and the panel moved to their right ends (x +72 and
  +75); the two pillars right of the Tab5 moved out to x 78.5, clear of the lid's seam. The piece files are named after
  their side (`piece_names`: `lid_A_right`, `panel_A_right`, `tray_A_left`).

The layers that close the openings are bridges across them; PrusaSlicer leaves the outer 0.3 mm of the 2 mm wall's faces
to the layer above there (the report lists them): at worst a faint line along the openings' edges.

### What the report says (`out/print_report.md`)

- **Hinges.** The lid side weighs 216 g (lid, panel, Tab5, half the hinges; no plugs); its moment about the axis is at
  most 0.108 N·m against 0.118…0.196 N·m of the two HG-MF08: 1.1× at the weak end of their tolerance. It holds, but a
  touch adds to it: a push at the middle of the screen the lid stands is 1.2…1.9 N at 120°, 0.8…1.5 N at 135°. Stiffer
  hinges need other seats; not drawn.
- **Tipping.** Lid on the table at 140°. The keyboard has to weigh 139 g for the device to stay upright up to there
  (93 g up to 120°). Not weighed.
- **Snap.** Simulated (`out/snap_sim.md`): 10 N to close and 13 N of hold with the lid where it was drawn, 6 N of hold
  with the lid 0.2 mm forward, none at 0.4 mm.
- **Print.** Plates 1–3: 154 g, 4 h 03 min (A1 mini, 0.4 nozzle, 0.2 layers, no supports); one-piece parts for a 220 mm
  bed: 152 g, 3 h 51 min.

### Not reachable in the lid

microSD and the expansion header (bottom edge), RS485 and the other side's connectors, the tripod nut and the M5-Bus
are inside the lid; the speaker faces the inside of the lid. The NP-F550 battery does not fit (the Tab5 would be
26.7 mm thick). With the keyboard's charge plug in the tray's back, the lid opens to 94°.

## Everything else

Hinge seats and covers, the snap and its simulation, the relief at the hinge side, the split parts with their splice
plates, the Bambu Studio projects, the coupons and the reproducibility checks are the PaperDIY version's and are
described in its [design notes](https://github.com/tsuyoshi-otake/paperdiy-pda-terminal/blob/main/cad/README.md).
The figures here are redrawn from this version's parts:

![Hinge screws](../docs/images/hinge_screws.png)
![Snap](../docs/images/latch.png)
![Snap, simulated](../docs/images/snap_sim.png)

## Changes vs. the original (for the licence "indicate changes")

None of the original meshes is used. The lid is a new hollow part that follows the original's outline (corner radii
halved to 3 mm, no chamfers) and parting surface, with a flat top, hinge pads and bosses, panel bosses, ribs, openings
for the ports in the left end wall, the hinge mortises and a snap lip on a thinned zone of the front wall; the bezel panel is new
(window, rim, camera and microphone holes, the port bay and a finger slot, countersunk holes, snap bumps). The tray is a new thin shell
with the original tray's outline (r 3), parting, keyboard room (as the opening of a deck flush with the rim) and rear
opening, plus hinge pads and bosses and a recess + groove for the snap lip. New parts: 4 hinge covers, the splice plates
and the test coupons. The original's knob hinge, label and Palma-specific openings are not used.

## Sources of measured dimensions

* M5Stack Tab5 size drawing `C145_Model_Size_page_01.png` and pin map `C145_Pinmap_Overview.png` (docs page of the Tab5):
  the ports on the left edge and their order.
* `m5stack/M5_Hardware`, `Products/C145_Tab5/Structures/Tab5.stl` (MIT): body size, which face is the screen, the
  power button's and the USB-C's openings.
* Sugatsune HG-MF spec table and 3D viewer, original enclosure geometry: as in the PaperDIY version.

## Licence & attribution

Derived from **"The PDA Terminal" / phone-enclosure by Un Kyu Lee** (https://github.com/unkyulee/phone-enclosure),
licensed **CC BY-NC 4.0**. The models and the images made from them (`out/`, `3mf/`, `renders/`, `../docs/images/`) are
under the same licence, non-commercial use only: see [LICENSE.md](LICENSE.md). The scripts (`src/`, `tools/`) and the
documentation are under the repository's [MIT License](../LICENSE).
