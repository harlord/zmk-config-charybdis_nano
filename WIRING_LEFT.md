# Charybdis Nano — LEFT Half Hand-Wiring

Wiring guide for the **LEFT** half switch matrix to its
**nice!nano / ProMicro nRF52840** controller, derived from this ZMK config
(`charybdis.dtsi` + `charybdis_left.overlay`). LEDs are omitted.

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

### Columns (`charybdis_left.overlay`)

| Matrix | pro_micro | nRF GPIO | Board label | Used? |
|--------|-----------|----------|-------------|-------|
| Col 0  | 19        | P0.02    | **002**     | **No** — unused (see note) |
| Col 1  | 20        | P0.29    | **029**     | Yes |
| Col 2  | 10        | P0.09    | **009**     | Yes |
| Col 3  | 16        | P0.10    | **010**     | Yes |
| Col 4  | 7         | P0.11    | **011**     | Yes |
| Col 5  | 8         | P1.04    | **104**     | Yes |

> **Col 0 is not used.** The keymap selects `five_column_transform`
> (`config/charybdis.keymap`), which maps only matrix columns 1–5 on the left half.
> Matrix column 0 (`RC(r,0)`) is never referenced, so any switch wired to pin `002`
> would do nothing. The left half therefore has **5 functional columns** — you can
> skip pin `002` entirely.

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
Col 0 is unused (see note above), so it is left empty.

### LEFT half (18 keys: 15 alphas + 3 thumbs)

```
          C0      C1      C2      C3      C4      C5
        (002)   (029)   (009)   (010)   (011)   (104)
R0(115)   –       Q       W       F       P       B
R1(024)   –       A       R       S       T       G
R2(022)   –       Z       X       C       D       V
R3(106)   –      TAB*     –      DEL*    BSPC*    –     ← thumbs (3)
```

`*` Thumb keys are layer-/mod-taps — the label is the **tap** action:
- **TAB**  at Col1 = `&base_th_mo_kp_hp SNIPETOP TAB` (hold → SNIPETOP layer)
- **DEL**  at Col3 = `&base_th_mo_kp_hp FUNC DEL` (hold → FUNC layer)
- **BSPC** at Col4 = `&lm_homerow_short LSHFT BACKSPACE` (hold → LSHFT)

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

This answers "where do the cathodes of B, G, V go?" — they **all join the single
Col 5 rail**, which then runs to pin `104`:

```
   Row0 (115) ──○ B ○──┤►├──┐
                            │
   Row1 (024) ──○ G ○──┤►├──┤   ← all three diode cathodes (stripe) tie
                            │     onto the SAME Col 5 rail
   Row2 (022) ──○ V ○──┤►├──┤
                            │
                            ▼
                        Col 5 rail ──► pin 104
```

Every column works the same way: all diode cathodes in that column meet on one
vertical rail wire, which goes to that column's pin.

### 3. Full left half

Read it as: each **row** is a horizontal wire (left edge → row pin); each **column**
is a vertical rail (bottom → column pin). At every `[key]►|`, the switch bridges its
row wire to its column rail through a diode (stripe `►|` pointing at the rail).
Col 0 has no switches (`n/c`).

```
            Col0      Col1      Col2      Col3      Col4      Col5
          (unused)   (029)     (009)     (010)     (011)     (104)
                       ║         ║         ║         ║         ║      ║ = column rail
                       ║         ║         ║         ║         ║
 Row0 ────n/c────[Q]►|═╝   [W]►|═╝   [F]►|═╝   [P]►|═╝   [B]►|═╝
 (115) ──────────────┐ each diode cathode (►|) joins the rail (═╝) of ITS column
                     │
 Row1 ────n/c────[A]►|═╗   [R]►|═╗   [S]►|═╗   [T]►|═╗   [G]►|═╗
 (024)                 ║         ║         ║         ║         ║
                       ║         ║         ║         ║         ║
 Row2 ────n/c────[Z]►|═╣   [X]►|═╣   [C]►|═╣   [D]►|═╣   [V]►|═╣
 (022)                 ║         ║         ║         ║         ║
                       ║         ║         ║         ║         ║
 Row3 ────n/c───[TAB]►|═╣   n/c     [DEL]►|═╣  [BSPC]►|═╣   n/c
 (106)                 ║                   ║         ║
                       ▼         ▼         ▼         ▼         ▼
                      029       009       010       011       104
                   (col pins — each rail collects all its column's cathodes)
```

LEFT Row 3 thumbs are at **Col1, Col3, Col4** → keys **TAB, DEL, BSPC**.

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
   `029`, `009`, `010`, `011`, `104`. **Skip `002` (Col 0) — it is unused.**
4. **Thumbs:** Only wire the Row 3 keys **TAB (Col1), DEL (Col3), BSPC (Col4)**.

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
