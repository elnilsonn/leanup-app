# LeanUp data contract

Updated: 2026-03-21
Purpose: define the exact data shape shared by the current web app and the future native iOS app

## Why this exists

Before moving screens from HTML to SwiftUI, we need one stable data contract.

In plain language:

- the current app already knows how to save data
- the future native app must read and write the same information
- if both sides agree on the same format, we can migrate screen by screen without losing user progress

## Current save key

- Web local storage key: `leanup_v4`
- Native iOS backup key: `leanup_v4_backup`

The web side stores normal JSON in `localStorage`.
The native iOS side stores the same JSON encoded as Base64 inside `UserDefaults`.

## Current payload shape

```json
{
  "notas": {
    "1": 4.2,
    "2": 3.5
  },
  "electivosSeleccionados": {
    "Electivo Componente Economico-Administrativo": "120002"
  },
  "electivosNotas": {
    "Electivo Componente Economico-Administrativo:::120002": 4.0
  },
  "username": "Nelson",
  "darkMode": false,
  "themeMode": "system"
}
```

## Field by field

### `notas`

Dictionary of regular course grades.

- key: course `id` converted to string
- value: grade from `1.0` to `5.0`

Examples:

- `"1": 4.5`
- `"38": 3.0`

### `electivosSeleccionados`

Dictionary of elective selection by group.

- key: elective group name
- value: selected elective code

Example:

```json
{
  "Electivo Componente Social-Solidario": "700004"
}
```

### `electivosNotas`

Dictionary of elective grades.

- key format: `grupo:::codigo`
- value: grade from `1.0` to `5.0`

Important rule:

- only the selected elective in each group should keep a grade
- grades for non-selected options must be removed during normalization

Example:

```json
{
  "Electivo Componente Social-Solidario:::700004": 4.3
}
```

### `username`

Display name shown inside the app.

- type: string
- default: `"Usuario"`

### `darkMode`

Legacy compatibility field.

- type: boolean
- kept because the current web app still reads it as fallback

### `themeMode`

Preferred theme source of truth.

- type: string
- allowed values: `light`, `dark`, `system`

Compatibility rule:

- if `themeMode` exists, it should drive the theme
- if `themeMode` is missing, the app may fall back to `darkMode`

## Normalization rules

Any future native code should follow these rules before saving:

1. Remove elective grades for options that are not currently selected.
2. Keep `username` non-empty. If empty, use `"Usuario"`.
3. Keep `themeMode` in the allowed set: `light`, `dark`, `system`.
4. Keep `darkMode` as a compatibility mirror for older logic.
5. Save numeric grades as numbers, not strings.

## Migration rules

When a native SwiftUI screen starts editing data:

1. It must read from this contract.
2. It must write back to this contract.
3. It must not invent a second save format.
4. It must preserve unknown-compatible data whenever possible.

This allows a gradual migration:

- some screens stay web
- some screens become native
- all of them still share the same saved progress

## Recommended native model names

- `LeanUpSnapshot`
- `LeanUpThemeMode`
- `LeanUpSnapshotStore`

## Source of truth today

This contract was extracted from:

- `www/index.html`
- `ios/App/App/AppDelegate.swift`

