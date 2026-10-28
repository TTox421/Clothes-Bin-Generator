# alt:V Clothes.bin Generator & DLC Synchronizer

Automated generator and synchronizer for alt:V multiplayer `clothes.bin` and `dlc_names.json` database.

This tool automatically detects your GTA V installation (Steam / Epic Games / Rockstar Games Launcher), reads official DLC archives directly in memory using CodeWalker, strips console-exclusive `g9ec` offset bugs, and builds a **100% synchronized, gap-free `clothes.bin`** for both Male and Female multiplayer peds.

---

## 🚀 Key Features

* **Zero Manual Unpacking**: Reads `dlclist.xml` and all `_shop.meta` variations directly from encrypted `.rpf` archives in seconds using CodeWalker.
* **Fixes the "+9 Shift" Offset Bug**:
  * Older alt:V builds included PlayStation 5 / Xbox Series exclusive DLCs (`mpg9ec` and `mpsum2_g9ec`).
  * Because the PC version of GTA V never registers G9EC ped variations, older tools caused a +9 global ID shift on all newer clothes.
  * This generator cleanly strips all G9EC entries and realigns global IDs seamlessly.
* **Full Component & Prop Coverage**:
  * All **12 clothing components**: Tops, Legs, Shoes, Masks, Torso, Undershirts, Decals, Armor, Bags, Hair, Beard, Head.
  * All **8 prop slots**: Hats, Glasses, Ears, Watches, Bracelets, and accessories.
* **100% Pleb Masters & GTA V Alignment**:
  * Global IDs match the actual in-game memory indices 1:1 (e.g. `mp_m_2026_01` tops start at `612` and span 17 items to `628`).
* **Plug & Play**:
  * Requires only standard Python 3 and built-in Windows PowerShell.
  * No external `pip` dependencies needed.

---

## 📋 Requirements

1. **Windows 10 / 11**
2. **Python 3.8+** (installed and added to PATH)
3. **Grand Theft Auto V** (officially installed via Steam, Epic Games, or Rockstar Games Launcher)

---

## 🛠️ Quick Start

1. Double-click **`run.bat`** (or open terminal and run `python generator.py`).
2. The generator will:
   * Auto-detect your GTA V directory from the Windows registry.
   * Scan `update.rpf` and all `dlcpacks`.
   * Re-index baseline clothes and ingest all new DLCs.
   * Validate byte-level integrity.
3. Your new files will be created in the **`new/`** directory:
   * `new/clothes.bin`
   * `new/dlc_names.json`
4. Copy `new/clothes.bin` to your alt:V server (`data/clothes.bin`) and client CDN data (`data/clothes.bin`).

---

## 📂 Project Structure

```text
ClothesBinGenerator/
├── clothes.bin            # Official baseline clothes.bin
├── CodeWalker.Core.dll    # CodeWalker RPF parser library
├── dlc_names.json         # DLC hash-to-name dictionary
├── extract_meta.ps1       # In-memory RPF archive reader
├── generator.py           # Main generator and integrity validator
├── run.bat                # One-click launcher
└── new/                   # Output directory
    ├── clothes.bin        # Generated clean clothes.bin
    └── dlc_names.json     # Generated DLC names dictionary
```

---

## 👕 Supported Ped Components

| ID | Name | In-Game Variation |
|:--:|:-----|:------------------|
| **0** | `PV_COMP_HEAD` | Head / Face |
| **1** | `PV_COMP_BERD` | Beard / Mask |
| **2** | `PV_COMP_HAIR` | Hair Style |
| **3** | `PV_COMP_UPPR` | Torso / Upper Body |
| **4** | `PV_COMP_LOWR` | Legs / Pants |
| **5** | `PV_COMP_HAND` | Bags / Parachutes |
| **6** | `PV_COMP_FEET` | Shoes / Footwear |
| **7** | `PV_COMP_TEEF` | Teeth / Scarfs / Neck |
| **8** | `PV_COMP_ACCS` | Undershirt / T-Shirts |
| **9** | `PV_COMP_TASK` | Body Armor |
| **10** | `PV_COMP_DECL` | Decals / Badges |
| **11** | `PV_COMP_JBIB` | Tops / Jackets |

## 👓 Supported Prop Slots

| ID | Anchor Point | Prop Type |
|:--:|:-------------|:----------|
| **0** | `ANCHOR_HEAD` | Hats / Helmets |
| **1** | `ANCHOR_EYES` | Glasses |
| **2** | `ANCHOR_EARS` | Ear Accessories |
| **3** | `ANCHOR_MOUTH` | Mouth / Face |
| **4** | `ANCHOR_LEFT_CHEST` | Left Chest |
| **5** | `ANCHOR_RIGHT_CHEST` | Right Chest |
| **6** | `ANCHOR_LEFT_WRIST` | Watches |
| **7** | `ANCHOR_RIGHT_WRIST` | Bracelets |

---

## 📄 License

Open-source utility for the alt:V multiplayer community. Feel free to use and distribute.
