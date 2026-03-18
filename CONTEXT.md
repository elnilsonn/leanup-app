# LeanUp — Contexto del Proyecto para Claude Code

## ¿Qué es LeanUp?
App universitaria para estudiantes de **Marketing y Negocios Digitales en la UNAD Colombia** (SNIES 116376), modalidad 100% virtual. Permite gestionar la malla curricular completa, registrar notas, ver el perfil profesional, salidas laborales, portafolio de proyectos y contenido para LinkedIn.

## Repositorio y URLs
- **GitHub:** https://github.com/elnilsonn/leanup-app
- **PWA (Netlify):** desplegada por el usuario en Netlify
- **Release IPA:** https://github.com/elnilsonn/leanup-app/releases/tag/v1.0
- **Source SideStore:** https://raw.githubusercontent.com/elnilsonn/leanup-app/main/source.json

## Archivos del proyecto
```
C:\Users\nsoli\leanup-app\
├── www/
│   └── index.html          ← LeanUp_PWA.html (la app completa)
├── ios/                    ← Proyecto Xcode generado por Capacitor
├── .github/
│   └── workflows/
│       └── build.yml       ← GitHub Actions para compilar IPA
├── ExportOptions.plist     ← Opciones de export para Xcode
├── source.json             ← Fuente para SideStore
├── capacitor.config.json   ← Config de Capacitor
├── package.json
└── CONTEXT.md              ← Este archivo
```

## Stack técnico
- **App:** HTML + CSS + JavaScript vanilla — un solo archivo `index.html`
- **Sin frameworks:** todo vanilla, sin React, sin Vue
- **PWA:** manifest embebido, service worker inline, viewport con `user-scalable=no`
- **iOS nativo:** Capacitor + GitHub Actions (Mac virtual) → IPA sin firma
- **Distribución:** SideStore (tienda alternativa iOS, UE)
- **Storage:** `localStorage` con clave `leanup_v4`
- **Fuentes:** Sora + IBM Plex Mono (Google Fonts)

## Colores UNAD
```css
--unad-navy: #001B50
--unad-blue: #0046AD
--unad-cyan: #009DC4
--unad-gold: #FFB81C
```

## Estructura de la app (vistas)
1. **Dashboard** — stats (%, promedio, aprobadas, créditos), barras de progreso por periodo
2. **Malla Curricular** — 38 materias + electivas organizadas por periodo y acordeón
3. **Perfil Profesional** — timeline dinámico basado en notas reales
4. **Salida Laboral** — roles profesionales por área
5. **Portafolio** — 38 proyectos con descripción mejorada + botón "🤖 Copiar prompt para IA"
6. **LinkedIn** — 68 textos profesionales reescritos
7. **Configuración** — nombre de usuario, modo oscuro, contacto

## Datos académicos
- **Programa:** Marketing y Negocios Digitales UNAD
- **Total créditos:** 144 (8 periodos × 18 créditos)
- **Materias obligatorias:** 38
- **Grupos de electivas:** múltiples, con 2-3 opciones por grupo
- **Escala de notas:** 1.0 a 5.0 (nota aprobatoria ≥ 3.0)

## Funcionalidades clave implementadas

### Notas
- `parseNota()` — acepta "35" como "3.5", valida rango 1.0-5.0
- `saveNota(id)` — guarda sin re-renderizar el panel
- `editNota(id)` — cambia el display a widget de edición inline
- `adjNota(id, delta)` — botones +/- para ajustar nota
- Electivas tienen sus propias funciones: `saveElecNota`, `editElecNota`, `adjElecNota`
- Estado visual: ✅ verde (≥3.0), ❌ rojo (<3.0), pendiente (sin nota)

### Malla Curricular
- Acordeones por periodo con animación `max-height + opacity`
- `toggleMalla(id)` — nunca llama `renderMalla()`, manipula DOM directamente
- `togglePer(section, per)` — igual, sin rerender
- Panel de detalle: columna derecha en desktop, overlay fullscreen en móvil
- `selMat(id)` — muestra detalle de materia normal
- `selElec(grupo, cod)` — selecciona electiva Y muestra su detalle
- Click-outside cierra el panel EXCEPTO si se toca `.malla-acc-header` o `.malla-acc-body`

### Electivas
- Una sola electiva seleccionada por grupo
- Al cambiar electiva: limpia nota de la anterior, desmarca el mat-row anterior
- Se muestran como mat-row completo cuando están seleccionadas (con nota badge y tag estado)
- Incluidas en stats del dashboard

### Portafolio
- 38 proyectos con `po` (descripción mejorada) y `prompt` (prompt tutor para IA)
- `copyPrompt(txt, btn)` — copia al portapapeles con feedback visual
- Prompts en modo tutor: la IA explica, pregunta y guía — NO hace el proyecto completo
- Sin datos personales en los prompts (ningún nombre, ciudad ni edad)

### Guardar / Reiniciar
- `saveData()` — guarda en localStorage, muestra feedback verde
- `resetChanges()` — restaura último guardado
- Punto dorado en botón Guardar cuando hay cambios sin guardar (`markUnsaved()`)

## PWA Mobile (iOS)

### Viewport
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
```

### Bottom Navigation
- 4 tabs: Inicio, Malla, Perfil, Más
- "Más" abre menú con: Salida Laboral, Portafolio, Configuración
- `setBottomNav(id)` — activa el tab correcto
- Liquid Glass con `backdrop-filter: blur(24px) saturate(200%)`

### Panel de detalle en móvil
- `#detailPanel` vive en el `body` (fuera del grid de malla)
- En desktop: JS lo mueve al `.malla-grid` al cargar
- En móvil: overlay `position:fixed` sobre toda la pantalla
- Se abre con clase `mobile-open` + `body.panel-open`
- Se cierra con botón ← en topbar O con swipe desde borde izquierdo
- `mobileOpenPanel()` — abre y hace `scrollTop=0`
- `mobileClosePanelOrBack()` — cierra y limpia selección

### Swipe-back (iOS style)
```js
touchstart en los primeros 30px del borde izquierdo
touchend con dx > 60px y dy < 80px → cierra panel
```

### Anti-zoom en inputs
```css
input, select, textarea { font-size: 16px !important }
* { touch-action: manipulation }
```

### Safe area
```css
padding-top: calc(env(safe-area-inset-top) + 56px);   /* topbar */
padding-bottom: calc(env(safe-area-inset-bottom) + 64px); /* bottom nav */
```

## Liquid Glass (solo móvil)
Aplicado con `@supports(backdrop-filter:blur(1px))` en:
- **Topbar:** `rgba(240,244,250,0.72)` + `blur(20px) saturate(180%)`
- **Bottom nav:** `rgba(0,27,80,0.78)` + `blur(24px) saturate(200%)`
- **Acordeones:** `rgba(238,243,251,0.65)` + `blur(16px) saturate(160%)`
- **Panel detalle:** `rgba(240,244,250,0.85)` + `blur(28px) saturate(180%)`
- Soporte dark mode en todos los elementos

## Modo oscuro
- Toggle en Configuración: `toggleDark(on)`
- Clase `body.dark` activa las variables CSS alternativas
- Persiste en localStorage

## Build IPA (GitHub Actions)
### Proceso
1. Push a `main` → dispara `build.yml`
2. `npm install` + `chmod +x node_modules/.bin/cap`
3. `npx cap sync ios` — sincroniza www al proyecto Xcode
4. `xcodebuild archive` con `CODE_SIGNING_ALLOWED=NO`
5. Crea IPA manualmente: `cp App.app → Payload/ → zip → LeanUp.ipa`
6. Upload como artifact de GitHub Actions

### Comando clave de build manual
```bash
mkdir -p build/output/Payload
cp -r build/App.xcarchive/Products/Applications/App.app build/output/Payload/
cd build/output && zip -r LeanUp.ipa Payload
```

### Node.js requerido
Capacitor CLI requiere Node.js >= 22.0.0

## Distribución SideStore
### source.json
```json
{
  "name": "LeanUp",
  "identifier": "io.leanup.source",
  "sourceURL": "https://raw.githubusercontent.com/elnilsonn/leanup-app/main/source.json",
  "apps": [{
    "bundleIdentifier": "io.leanup.app",
    "versions": [{
      "version": "1.0",
      "downloadURL": "https://github.com/elnilsonn/leanup-app/releases/download/v1.0/LeanUp-IPA.zip"
    }]
  }]
}
```
### URL para agregar en SideStore
```
https://raw.githubusercontent.com/elnilsonn/leanup-app/main/source.json
```

## Proceso para publicar una actualización
1. Editar `www/index.html`
2. `git add . && git commit -m "update vX.X" && git push`
3. Esperar que Actions compile (10-20 min)
4. Descargar artifact `LeanUp-IPA` → extraer `LeanUp.ipa` → comprimir a `LeanUp-IPA.zip`
5. Crear nuevo release en GitHub con tag `vX.X`, subir el zip en Assets
6. Actualizar `source.json`: `version`, `date`, `downloadURL`
7. `git add . && git commit -m "bump vX.X" && git push`

## Bugs conocidos resueltos (no tocar)
- Panel no desaparece al editar nota → `saveNota/editNota` actualizan inline sin rerenderizar
- Panel desaparecía al abrir/cerrar acordeón → `.malla-acc-header` en excepciones de click-outside
- `selElec` no llamaba `renderMalla()` — ahora actualiza DOM directamente
- Scroll loco en panel móvil → panel vive en body, no en el grid
- Espacios en blanco en panel móvil → padding solo en `.detail-panel` interno, no en `#detailPanel`
- Doble tap zoom → `user-scalable=no` + `touch-action:manipulation`
- Zoom en inputs → `font-size:16px !important` en todos los inputs
- Botón atrás no aparecía → se eliminó `style="display:none"` inline del HTML

## Mejoras pendientes / ideas
- [ ] Scroll bugs en panel móvil (pendiente verificar con usuario)
- [ ] Notificaciones de recordatorio de notas
- [ ] Compartir progreso como imagen
- [ ] Modo estudio con temporizador Pomodoro
- [ ] Calculadora de promedio ponderado
- [ ] Exportar malla a PDF

## Contacto del proyecto
- **GitHub:** elnilsonn
- **Email:** nsolisasprilla@icloud.com
- **WhatsApp:** https://wa.me/34645568327
