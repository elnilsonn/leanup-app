# AGENTS.md - LeanUp iPhone App

Contexto operativo actual del proyecto. Leer esto antes de hacer cambios grandes.

## Estado real actual

LeanUp para iPhone ya no esta en etapa hibrida.

- La app arranca en una shell nativa `SwiftUI-first`.
- `Dashboard`, `Malla`, `Perfil` y `Configuracion` ya son pantallas nativas.
- El IPA ya no depende de `Capacitor`, `WKWebView` ni `cap sync ios`.
- El bundle iOS ya no empaqueta `public/index.html`.
- `www/index.html` se conserva en el repo solo como referencia historica temporal por decision del usuario.

## Arquitectura activa

La app iPhone actual queda asi:

```
LeanUp iPhone
├── NativeRootViewController
├── LeanUpNativeRootView
│   ├── Dashboard
│   ├── Malla
│   ├── Perfil
│   └── Configuracion
├── LeanUpAppModel
└── native-academics.json + UserDefaults
```

## Archivos importantes ahora

| Archivo | Rol actual |
|---------|------------|
| `ios/App/App/NativeFoundation/NativeRoot.swift` | Shell nativa y raiz SwiftUI |
| `ios/App/App/NativeFoundation/LeanUpModels.swift` | Modelo de estado, persistencia y base academica |
| `ios/App/App/NativeScreens/*.swift` | Pantallas nativas principales |
| `ios/App/App/NativeUI/LeanUpSharedUI.swift` | Componentes compartidos |
| `ios/App/App/AppDelegate.swift` | Arranque base de la app |
| `ios/App/App/native-academics.json` | Recurso academico nativo empaquetado |
| `docs/apple-ios26-guide.md` | Guia viva de arquitectura y criterios Apple |
| `docs/migration-log.md` | Bitacora viva de lo ya hecho |
| `www/index.html` | Referencia historica temporal, no runtime activo |

## Persistencia activa

- Fuente de verdad: `UserDefaults`
- Snapshot del usuario: clave `leanup_v4_backup`
- Base academica: `native-academics.json`
- Respaldo adicional: cache nativa de la base academica

## Build actual

- GitHub Actions compila directamente con `xcodebuild`
- Ya no hay paso de `npm install`
- Ya no hay paso de `npx cap sync ios`

## Criterio para nuevas tareas

1. Preferir `SwiftUI` antes que HTML.
2. No reintroducir `WKWebView` ni bridge hibrido para funciones nuevas.
3. Usar `www/index.html` solo si hace falta consultar contenido legado.
4. Consultar siempre:
   - `docs/apple-ios26-guide.md`
   - `docs/migration-log.md`
   - `docs/error-log.md`
5. La siguiente fase principal ya no es migracion tecnica, sino polish visual, consistencia UX y nuevas funciones nativas.
