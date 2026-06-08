# Events System (`.events` files)

`.events` files define animation-driven visual/audio effects for a ship or subsystem — death explosions, damage smoke, weapon-fire flashes. They are optional; most ships use vanilla defaults. Only ships with custom death sequences or unique fire animations need one.

## File Structure

```lua
effects =
{
    animations = { ... },
    events     = { ... },
}
```

### `animations` block

Each named entry defines a clip that events can reference:

```lua
animation1 =
{
    name    = "Death",   -- clip name as it exists in the .hod
    length  = 4,         -- seconds
    loop    = 0,         -- 0 = play once, 1 = loop
    parent  = "",        -- "" = always active; "Damage" = only when damaged
    minimum = 0,         -- damage threshold to start (0–1, fraction of maxhealth lost)
    maximum = 0,         -- damage threshold to stop (0 = no upper bound)
    markers = {""}       -- optional marker names exported from the .hod
}
```

**Damage-state animations** use `parent="Damage"` with `minimum`/`maximum` to gate playback by damage fraction — e.g. `dmg01` smoke at 0.25–1, heavier `dmg02` at 0.5+, heaviest `dmg03` at 0.75+ (all `loop=1`).

### `events` block

Each entry fires effects at a point in a named animation. Only `anim` and `animtime` are required:

```lua
event1 =
{
    { "anim",     "death" },          -- clip to listen to (case-insensitive)
    { "animtime", "0.1" },            -- normalized time (0–1) within that clip
    { "marker",   "marker1,marker2" },-- comma-separated .hod marker names
    { "fx",       "dmg_cloud_explosion_large" }, -- ETG particle effect
    { "sound",    "Explosion/Large/ETG_Explode_Large_Firey" },
    { "fx_scale", "2.5" },            -- uniform scale multiplier
    { "fx_sm",    "on" },             -- screen-mesh (large screen-space overlay)
    { "fx_nlips", "on" },             -- no LIPSYNC — ignore speaker animation
}
```

| Key | Type | Description |
|-----|------|-------------|
| `anim` | string | Animation clip name (matches an `animations` entry) |
| `animtime` | float string | Normalized time: `0`=start, `1`=end, `-1`=fires every loop iteration (on `loop=1` clips) |
| `marker` | string | Comma-separated `.hod` marker name(s); effects spawn at each |
| `fx` | string | ETG particle effect (comma-separated for multiple at one marker) |
| `sound` | string | Sound event path |
| `fx_scale` | float string | Scale multiplier for all `fx` at this event |
| `fx_sm` | `"on"` | Screen-mesh mode (large final-explosion overlays) |
| `fx_nlips` | `"on"` | Disables LIPSYNC constraint |

## Typical Death Sequence (capital ships)

Builds from small peripheral explosions to a central detonation:

1. **Stages 0–0.7**: scattered `dmg_cloud_explosion_large` at numbered hull markers, staggered `animtime` (0, 0.025, 0.05, …).
2. **Stage 0.7**: `dmg_capital_burn_ring` at `Root` — the glowing stress ring.
3. **Stage 0.85**: `dmg_capital_explosion_combo` + `DMG_MASSIVE_MESH_SPHERE_RING` at `Root` with `fx_sm="on"` — final screen-filling detonation.

## Weapon Fire Events

Non-death events wire animation clips to muzzle-flash effects. Example (ion cannon): a charge effect at `animtime "0"` on `Fire_IonCannons` at the muzzle marker, then a steam-discharge effect partway through (e.g. `animtime "0.4444"`) at a spray marker — each with its own `fx`/`sound`.

## Bulk-editing weapon FX via CSV

For batch changes across many ships' fire animations, use the export/import pair under `tools/`:

```powershell
pwsh tools\export-weapon-events.ps1                  # → .tmp\weapon-events.csv
pwsh tools\export-weapon-events.ps1 -OutputPath C:\out\fx.csv
pwsh tools\import-weapon-events.ps1                  # write CSV changes back into src\<...>\<name>.events
pwsh tools\import-weapon-events.ps1 -DryRun
```

Export joins each `StartShipWeaponConfig`/`StartSubSystemWeaponConfig` to events whose `anim` matches the weapon's 4th argument, resolving `.events` next to the `.ship`/`.subs` first, then vanilla `refs\homeworld2-big\...` as fallback. Import reverses it: copies vanilla files into `src/` on demand and rewrites **only** weapon-fire events — Death/damage events and the `animations` block are preserved. Identity columns (`Ship or Subs Path`, `Weapon Hardpoint`, `Weapon Name`) are read-only keys; `.ship`/`.subs` files are never modified.

## Ships with Custom `.events`

`hgn_destroyer` (death + ion cannon fire), `hgn_heavybattlecruiser`, `hgn_interceptor`, `meg_slipgate` (activation FX), `sri_commandbase`, `sri_dreadnaught`, `sri_sajuuk`, `vgr_heavybattlecruiser` (all death sequences). Ships without `.events` fall back to vanilla engine defaults for their class.
</content>
