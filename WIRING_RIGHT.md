# Charybdis Nano — RIGHT Half Hand-Wiring

Wiring guide for the **RIGHT** half switch matrix to its
**nice!nano / ProMicro nRF52840** controller, derived from this ZMK config
(`charybdis.dtsi` + `charybdis_right.overlay`). LEDs and the trackball are omitted.

---

## Pin mapping

`pro_micro N` → nRF52840 GPIO → **label printed on the board** (e.g. `115` = P1.15).

### Rows (`charybdis.dtsi`)

| Matrix | pro_micro | nRF GPIO | Board label |
|--------|-----------|----------|-------------|
| Row 0  | 18        | P1.15    | **115** |
| Row 1  | 5         | P0.24    | **024** |
| Row 2  | 4         | P0.22    | **022** |
| Row 3  | 9         | P1.06    | **106** |

### Columns (`charybdis_right.overlay`)

| Matrix | pro_micro | nRF GPIO | Board label | Used? |
|--------|-----------|----------|-------------|-------|
| Col 0  | 19        | P0.02    | **002**     | **No** — unused (see note) |
| Col 1  | 20        | P0.29    | **029**     | Yes |
| Col 2  | 10        | P0.09    | **009**     | Yes |
| Col 3  | 6         | P1.00    | **100**     | Yes |
| Col 4  | 7         | P0.11    | **011**     | Yes |
| Col 5  | 8         | P1.04    | **104**     | Yes |

> **Col 0 is not used.** The keymap selects `five_column_transform` with
> `col-offset = <5>` on the right half (`charybdis_right.overlay`). The right
> controller only maps physical columns **1–5** to keys (matrix columns 6–10).
> Physical column 0 (`002`) is never referenced — skip it.

> **Col 3 differs from the left half:** right uses pin **`100`** (P1.00);
> left uses **`010`** (P0.10).

---

## Diode direction: `row2col`

Current flows from **ROW → diode → COLUMN**, so the diode **cathode (striped side)
must face the COLUMN**.

```
ROW wire ──────┤ switch ├──────▶|────── COLUMN wire
                            (stripe → col)
   anode side ───────────── cathode (stripe) side
```

- One switch terminal → ROW wire
- Other switch terminal → diode **anode**
- Diode **cathode (stripe)** → COLUMN wire

---

## Electrical matrix — which intersections have a key

Each cell shows the **base-layer key** at that intersection. `–` = no switch (skip).
Col 0 is unused (see note above).

### RIGHT half (17 keys: 15 alphas + 2 thumbs)

```
          C0      C1      C2      C3      C4      C5
        (002)   (029)   (009)   (100)   (011)   (104)
R0(115)   –       '       Y       U       L       J
R1(024)   –       O       I       E       N       M
R2(022)   –       /       .       ,       H       K
R3(106)   –      ENT*     –      SPC*     –       –     ← thumbs (2)
```

`*` Thumb keys are layer-/mod-taps — the label is the **tap** action:
- **ENT** at Col1 = `&base_th_mo_kp_hp RAISE ENTER` (hold → RAISE layer)
- **SPC** at Col3 = `&spacelm LOWER SPACE` (hold → LOWER layer)

---

## Matrix wiring schematic

### 1. One key (the building block)

```
   ROW wire ──○ switch ○──┤►├──● COLUMN rail
              terminal A   diode  terminal B
                          (stripe → column)
```

- terminal A → the **row** wire
- terminal B → diode **anode**; diode **cathode (stripe)** → the **column rail**

### 2. One column = one shared rail (example: Col 5 → pin `104`)

All keys in the same column share **one vertical rail**. For Col 5, the cathodes
of **J, M, K** all tie to the same rail, then to pin `104`:

```
   Row0 (115) ──○ J ○──┤►├──┐
                            │
   Row1 (024) ──○ M ○──┤►├──┤   ← all three diode cathodes (stripe) tie
                            │     onto the SAME Col 5 rail
   Row2 (022) ──○ K ○──┤►├──┤
                            │
                            ▼
                        Col 5 rail ──► pin 104
```

Every column works the same way: all diode cathodes in that column meet on one
vertical rail wire, which goes to that column's pin.

### 3. Full right half

Read it as: each **row** is a horizontal wire (left edge → row pin); each **column**
is a vertical rail (bottom → column pin). At every `[key]►|`, the switch bridges its
row wire to its column rail through a diode (stripe `►|` pointing at the rail).
Col 0 has no switches (`n/c`).

```
            Col0      Col1      Col2      Col3      Col4      Col5
          (unused)   (029)     (009)     (100)     (011)     (104)
                       ║         ║         ║         ║         ║      ║ = column rail
                       ║         ║         ║         ║         ║
 Row0 ────n/c────[']►|═╝   [Y]►|═╝   [U]►|═╝   [L]►|═╝   [J]►|═╝
 (115) ──────────────┐ each diode cathode (►|) joins the rail (═╝) of ITS column
                     │
 Row1 ────n/c────[O]►|═╗   [I]►|═╗   [E]►|═╗   [N]►|═╗   [M]►|═╗
 (024)                 ║         ║         ║         ║         ║
                       ║         ║         ║         ║         ║
 Row2 ────n/c────[/]►|═╣   [.]►|═╣   [,]►|═╣   [H]►|═╣   [K]►|═╣
 (022)                 ║         ║         ║         ║         ║
                       ║         ║         ║         ║         ║
 Row3 ────n/c───[ENT]►|═╣   n/c    [SPC]►|═╣   n/c       n/c
 (106)                 ║                   ║
                       ▼         ▼         ▼         ▼         ▼
                      029       009       100       011       104
                   (col pins — each rail collects all its column's cathodes)
```

RIGHT Row 3 thumbs are at **Col1, Col3** → keys **ENT, SPC**.

> The horizontal `──` lines are **row** wires (one per row, shared by all keys in
> that row). The vertical `║` lines are **column rails** (one per column, shared by
> all diode cathodes in that column). They only connect through a switch+diode.

---

## Wiring steps

1. **Rows:** Run 4 horizontal bus wires. Connect Row0→`115`, Row1→`024`,
   Row2→`022`, Row3→`106`. One pin of every switch in a row joins its row wire.
2. **Diodes:** On the other terminal of each switch, solder a diode with the
   **stripe pointing away from the switch, toward the column wire**.
3. **Columns:** Join all diode cathodes (stripe ends) in a column to one vertical
   bus wire, then to the column pin. Use only the **5 active columns**:
   `029`, `009`, `100`, `011`, `104`. **Skip `002` (Col 0) — it is unused.**
4. **Thumbs:** Only wire the Row 3 keys **ENT (Col1), SPC (Col3)**.

---

## Trackball (PMW3610)

Wiring for the **PMW3610 module** (RIGHT half only). Pins taken from
`charybdis_right.overlay` (`&spi0` + `trackball@0`). The module uses **3-wire SPI**:
its single `SDIO` data line is shared MOSI/MISO, which is why the config maps both
`SPIM_MOSI` and `SPIM_MISO` to the same pin `P0.17`.

| Module pin | Function                | nRF pin | Board label |
|------------|-------------------------|---------|-------------|
| **SDIO**   | SPI data (MOSI + MISO)  | P0.17   | **017** |
| **SCLK**   | SPI clock               | P0.08   | **008** |
| **NCS**    | chip select (CS)        | P0.20   | **020** |
| **MOT**    | motion interrupt (IRQ)  | P0.06   | **006** |
| **NRESET** | sensor reset            | 3.3 V   | **VCC** *(tie high — see note)* |
| **VDD**    | core power              | 3.3 V   | **VCC** |
| **VDDIO**  | I/O power               | 3.3 V   | **VCC** |
| **GND**    | ground                  | GND     | **GND** |

```
   PMW3610 module                         nice!nano / ProMicro
   ┌───────────────┐
   │ SDIO ─────────┼───────────────────►  017   (P0.17, MOSI+MISO)
   │ SCLK ─────────┼───────────────────►  008   (P0.08, SCK)
   │ NCS  ─────────┼───────────────────►  020   (P0.20, CS)
   │ NRESET ───────┼───────────────────►  VCC   (3.3 V, pull high)
   │ MOT  ─────────┼───────────────────►  006   (P0.06, IRQ)
   │               │
   │ GND  ─────────┼───────────────────►  GND
   │ VDDIO ────────┼───────────────────►  VCC   (3.3 V)
   │ VDD  ─────────┼───────────────────►  VCC   (3.3 V)
   └───────────────┘
```

Notes:
- **Power:** Connect **VDD** and **VDDIO** both to **3.3 V** (the `VCC` pin), and
  **GND** to **GND**. Do **not** use RAW/5 V — the PMW3610 is a 3.3 V part.
- **NRESET:** Active-low reset. Tie it to **3.3 V (VCC)** so the sensor stays out of
  reset. If your module already has an internal/onboard pull-up on NRESET you may
  leave it unconnected, but tying it high is the safe default.
- **SDIO:** Run a single wire from the module's `SDIO` pad to pin `017`. The nRF
  drives this as a bidirectional 3-wire SPI line (no separate MISO wire).
- These trackball pins are **independent of the key matrix** — they do not touch any
  row/column wire.

---

## GND / Power wiring

The switch matrix does **not** use GND — rows and columns never connect to ground.
GND is only used for the battery, the power switch, and (optionally) a reset button.

```
                 ┌──────── B+ pad  ◄── battery + (red)
   Li-Po  ───────┤
                 └──[ SW ]── B- pad  ◄── battery − (black) = GND
                  (power switch inline on the − / GND lead)

   Reset button:  RST pad ──[ button ]── GND pad   (momentary)
```

5. **Battery −/GND:** Solder the battery **negative (black)** lead to the **`B-`**
   pad. `B-` is the board's ground reference.
6. **Battery +:** Solder the battery **positive (red)** lead to the **`B+`** pad.
7. **Power switch (optional):** Put an SPST switch **inline on the negative/GND
   lead** between the battery − and `B-` (or on the + lead to `B+`). This fully
   cuts battery power when off.
8. **Reset button (optional):** Wire a momentary button between a **`GND`** pin
   and the **`RST`** pin. Pressing it resets the board; double-press enters the
   UF2 bootloader for flashing.

> Note: The matrix column/row pins listed above are **never** tied to GND.
> Only the battery −, power switch, and reset button use GND.

---

## Difference from the LEFT half

| Item | LEFT | RIGHT |
|------|------|-------|
| Col 3 pin | **010** (P0.10) | **100** (P1.00) |
| Thumb keys | TAB, DEL, BSPC (3) | ENT, SPC (2) |
| Active keys | 18 | 17 |

Both halves skip physical Col 0 (`002`) under `five_column_transform`.
