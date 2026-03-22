# LeanUp - Contexto Actual del Proyecto

Actualizado: 2026-03-21

## Resumen

LeanUp es ahora una app nativa de iPhone centrada en estudiantes de Marketing y Negocios Digitales de la UNAD Colombia.

El proyecto ya completo la migracion tecnica principal:

- shell nativa en SwiftUI
- pantallas principales nativas
- datos academicos cargados desde recurso nativo
- build iOS desacoplado de Capacitor

## Lo que sigue activo

- `ios/App/App/NativeFoundation/NativeRoot.swift`
- `ios/App/App/NativeFoundation/LeanUpModels.swift`
- `ios/App/App/NativeScreens/LeanUpDashboardScreen.swift`
- `ios/App/App/NativeScreens/LeanUpMallaScreen.swift`
- `ios/App/App/NativeScreens/LeanUpProfileScreen.swift`
- `ios/App/App/NativeScreens/LeanUpSettingsScreen.swift`
- `ios/App/App/NativeUI/LeanUpSharedUI.swift`
- `ios/App/App/native-academics.json`

## Lo que ya no forma parte del runtime iPhone

- `Capacitor`
- `WKWebView`
- `public/index.html`
- `cap sync ios`
- bridge hibrido de interfaz

## Lo que se conserva por referencia

- `www/index.html`

Se mantiene solo porque el usuario pidio conservarlo temporalmente para futuras consultas o rescate de contenido puntual. No debe tratarse como arquitectura activa.

## Estado del producto

Ya validado en GitHub Actions y en iPhone:

- compila bien
- abre bien
- las materias cargan bien

## Prioridad actual

La siguiente etapa recomendada es:

1. polish visual
2. consistencia entre pantallas
3. refinamiento UX
4. luego nuevas funciones nativas

## Documentos de referencia

- `docs/apple-ios26-guide.md`
- `docs/migration-log.md`
