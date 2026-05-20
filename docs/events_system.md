# Events System (`.events` files)

`.events` files define animation-driven visual and audio effects for a ship or subsystem — death explosions, damage smoke, weapon fire flashes. They are optional; most ships rely on vanilla defaults. Only ships with custom death sequences or unique fire animations need one.

## File Structure

```lua
effects =
{
    animations = { ... },
    events     = { ... },
}
```

### `animations` block

Each named entry defines an animation clip that can be referenced by events:

```lua
animation1 =
{
    name    = "Death",      -- clip name as it exists in the .hod file
    length  = 4,            -- clip length in seconds
    loop    = 0,            -- 0 = play once, 1 = loop
    parent  = "",           -- "" = always active; "Damage" = only when ship is damaged
    minimum = 0,            -- damage threshold to start this clip (0–1, fraction of maxhealth lost)
    maximum = 0,            -- damage threshold to stop (0 = no upper bound)
    markers = {""}          -- optional marker names exported from the .hod
}
```

**Damage-state animations** use `parent = "Damage"` with `minimum`/`maximum` to gate playback:

```lua
-- plays dmg01 smoke when ship is between 25% and 100% damaged
animation2 = { name="dmg01", loop=1, parent="Damage", minimum=0.25, maximum=1, ... }
-- plays heavier smoke when 50%+ damaged
animation3 = { name="dmg02", loop=1, parent="Damage", minimum=0.5,  maximum=1, ... }
-- plays heaviest smoke when 75%+ damaged
animation4 = { name="dmg03", loop=1, parent="Damage", minimum=0.75, maximum=1, ... }
```

### `events` block

Each entry fires effects at a specific point during a named animation:

```lua
event1 =
{
    { "anim",     "death" },              -- animation clip to listen to (case-insensitive)
    { "animtime", "0.1" },                -- normalized time (0–1) within that clip
    { "marker",   "marker1,marker2" },   -- comma-separated .hod hardpoint/marker names
    { "fx",       "dmg_cloud_explosion_large" }, -- ETG particle effect name
    { "sound",    "Explosion/Large/ETG_Explode_Large_Firey" }, -- sound path
    { "fx_scale", "2.5" },               -- uniform scale multiplier for the effect
    { "fx_sm",    "on" },                -- screen-mesh effect (large screen-space overlay)
    { "fx_nlips", "on" },                -- no LIPSYNC — effect ignores speaker animation
}
```

Only `anim` and `animtime` are required. All other keys are optional.

| Key | Type | Description |
|-----|------|-------------|
| `anim` | string | Animation clip name (matches an entry in `animations`) |
| `animtime` | float string | Normalized time within the clip: `0` = start, `1` = end, `-1` = loop trigger |
| `marker` | string | Comma-separated marker name(s) from the .hod; effects spawn at each marker |
| `fx` | string | ETG particle effect (comma-separated for multi-effect at same marker) |
| `sound` | string | Sound event path |
| `fx_scale` | float string | Scale multiplier applied to all `fx` at this event |
| `fx_sm` | `"on"` | Activates screen-mesh mode (used for large final explosion overlays) |
| `fx_nlips` | `"on"` | Disables LIPSYNC constraint on the effect |

**`animtime = "-1"`** on a looping animation (`loop=1`) means the event fires on every loop iteration.

## Typical Death Sequence Pattern

Capital ships use a multi-stage death that builds from small peripheral explosions to a central catastrophic detonation:

1. **Stages 0–0.7**: Scattered `dmg_cloud_explosion_large` events at numbered markers around the hull, with staggered `animtime` values (0, 0.025, 0.05 …)
2. **Stage 0.7**: `dmg_capital_burn_ring` at `Root` — the glowing stress ring
3. **Stage 0.85**: `dmg_capital_explosion_combo` + `DMG_MASSIVE_MESH_SPHERE_RING` at `Root` with `fx_sm = "on"` — the final screen-filling detonation

## Weapon Fire Events

Non-death events wire animation clips to muzzle-flash effects. Example (ion cannon):

```lua
-- muzzle charge at frame 0
event31 = {
    { "anim",     "Fire_IonCannons" },
    { "animtime", "0" },
    { "marker",   "Weapon_IonCannon_Muzzle" },
    { "fx",       "ion_beam_charge_combo" },
    { "sound",    "WEAPON/FRIGATE/FIRE/WEAPON_FRIGATE_ION_CANNON_BEAM" },
    { "fx_scale", "1.5" },
}
-- steam discharge at 44% through the animation
event32 = {
    { "anim",     "Fire_IonCannons" },
    { "animtime", "0.4444" },
    { "marker",   "marker_SteamSpray1" },
    { "fx",       "ion_cannon_steam_spray" },
    { "sound",    "DAMAGE/SMOKE/ION_BEAM_DISCHARGE" },
}
```

## Bulk-editing weapon FX via CSV

For batch changes across many ships' fire animations, use the export/import pair under `tools/`:

```powershell
# Dump every weapon config + its matching events to a CSV.
pwsh tools\export-weapon-events.ps1                              # → .tmp\weapon-events.csv
pwsh tools\export-weapon-events.ps1 -OutputPath C:\out\fx.csv

# After editing the CSV, write the changes back into src/<...>/<name>.events.
pwsh tools\import-weapon-events.ps1
pwsh tools\import-weapon-events.ps1 -DryRun
```

The export joins each `StartShipWeaponConfig` / `StartSubSystemWeaponConfig` to events whose `anim` matches the weapon's 4th argument. Events files are resolved next to the `.ship`/`.subs` first, then vanilla `refs\homeworld2-big\<ship|subsystem>\<name>\<name>.events`. The import reverses that: it copies vanilla files into `src/` on demand and only rewrites weapon-fire events — Death/damage events and the animations block are preserved. Identity columns (`Ship or Subs Path`, `Weapon Hardpoint`, `Weapon Name`) are read-only keys; `.ship`/`.subs` files are not modified by the import.

## Ships with Custom `.events` Files

| Ship | Notes |
|------|-------|
| `hgn_destroyer` | Full death sequence + ion cannon fire animation |
| `hgn_heavybattlecruiser` | Death sequence |
| `hgn_interceptor` | Death sequence |
| `meg_slipgate` | Slipgate activation FX |
| `sri_commandbase` | Death sequence |
| `sri_dreadnaught` | Death sequence |
| `sri_sajuuk` | Death sequence |
| `vgr_heavybattlecruiser` | Death sequence |

Ships without `.events` files fall back to vanilla HW2 engine defaults for their ship class.
