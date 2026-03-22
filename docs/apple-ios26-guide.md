# LeanUp - Guia Apple iOS 26 y Liquid Glass

Actualizado: 2026-03-21
Estado: guia viva para decisiones de arquitectura, diseno e implementacion. Fase tecnica de migracion cerrada.

## Objetivo

Este documento consolida:

- El contexto actual de LeanUp.
- La guia oficial de Apple relevante para iOS 26 y Liquid Glass.
- Reglas practicas para implementar UI nativa con criterio.
- Una recomendacion clara sobre si debemos seguir hibrido, migrar a Swift, o hacer una migracion por fases.

La idea es usar esta guia como referencia antes de hacer cambios grandes en la base nativa, en los modelos compartidos o al introducir nuevas pantallas y componentes de iPhone.

## Resumen ejecutivo

LeanUp ya completo la migracion tecnica principal hacia una base nativa. La app ahora arranca en una shell `SwiftUI-first`, usa pantallas nativas reales y ya no depende de `WKWebView`, `Capacitor` ni del bundle web para su runtime en iPhone.

Conclusion recomendada y ya aplicada:

1. No conviene hacer una reescritura total e inmediata de todo a Swift.
2. Si conviene dejar de depender de un unico `www/index.html` como centro de toda la app.
3. Si conviene migrar por fases hacia una arquitectura SwiftUI-first, manteniendo partes web solo como puente temporal.
4. Si conviene priorizar primero navegacion, barras, busqueda, paneles y configuracion en SwiftUI, porque ahi es donde iOS 26 aporta mas valor automatico.
5. Tras cerrar esa migracion, el siguiente valor pasa a ser consistencia visual, polish y nuevas funciones nativas.

## Estado actual de LeanUp

Estado tecnico actual del repo:

- La app iOS arranca desde `NativeRootViewController` y renderiza `Dashboard`, `Malla`, `Perfil` y `Configuracion` en SwiftUI.
- `ios/App/App/AppDelegate.swift` ya esta reducido al arranque base.
- La base academica se carga desde `native-academics.json` y cache nativa local.
- El target iOS ya no empaqueta `public/index.html`, ni usa `Capacitor`, ni ejecuta `cap sync` para compilar el IPA.
- `www/index.html` puede seguir existiendo en el repo como referencia historica, pero ya no es parte de la arquitectura activa del iPhone.

Implicacion:

- La deuda estructural principal de la migracion ya quedo resuelta.
- El foco pendiente antes de nuevas features grandes es polish visual, consistencia de producto y nuevas capacidades nativas.

## Que deja claro Apple en iOS 26

### 1. Liquid Glass vive sobre la capa de navegacion, no sobre todo el contenido

Apple explica que Liquid Glass debe reservarse para la capa funcional que flota sobre el contenido: navegacion, toolbars, tab bars, sidebars, menus, sheets y controles destacados.

Implicacion para LeanUp:

- No debemos intentar "vidriar" toda la interfaz web como si todo fuera glass.
- El contenido academico, listas, notas, materias y paneles de detalle deben seguir priorizando legibilidad y jerarquia.
- El glass debe usarse donde aporta estructura y enfoque, no como decoracion general.

### 2. Los componentes estandar obtienen mucho comportamiento automaticamente

Apple muestra que al compilar con los SDK de Xcode 26:

- `TabView`, `NavigationSplitView`, sheets, toolbars y search adoptan el nuevo sistema.
- Los tab bars pueden flotar sobre el contenido y minimizarse al hacer scroll.
- Las toolbars agrupan acciones automaticamente.
- Los scroll edge effects mantienen legibilidad sin capas falsas ni overlays manuales.

Implicacion para LeanUp:

- Cuanto mas dependamos de componentes nativos reales, menos hacks necesitaremos para "parecer iOS".
- Cuanto mas dependamos de HTML dentro de `WKWebView`, menos beneficios automaticos obtenemos del sistema.

### 3. Apple recomienda limpiar customizaciones viejas de barras

Apple insiste en quitar fondos, bordes y decoraciones extra en barras si antes se usaban para dar peso visual.

Implicacion para LeanUp:

- Nuestra barra nativa actual puede seguir existiendo, pero debe simplificarse y alinearse con APIs del sistema cuando sea posible.
- Si migramos a `TabView` real en SwiftUI, obtendremos una base mas estable y mas cercana al comportamiento del sistema.

### 4. Glass sobre glass es una mala practica

Apple es clara:

- Evitar `glass on glass`.
- Si hay elementos de glass cercanos, deben compartir contexto de muestreo.
- En SwiftUI eso se resuelve con `GlassEffectContainer` solo cuando hay multiples elementos hermanos.

Implicacion para LeanUp:

- Las reglas internas actuales del proyecto van en la direccion correcta.
- Debemos mantener la norma de no anidar `glassEffect` dentro de otro glass.

### 5. El sistema premia estructura, no solo efecto visual

La narrativa de Apple no es "agrega blur y listo". Es:

- estructura correcta
- jerarquia correcta
- navegacion correcta
- agrupacion correcta
- continuidad entre dispositivos

Implicacion para LeanUp:

- Profesionalizar LeanUp no es solo cambiar colores o meter blur.
- El paso realmente profesional es separar responsabilidades y adoptar estructura nativa donde tenga sentido.

## Reglas practicas de Liquid Glass para LeanUp

### Reglas que debemos seguir siempre

1. Aplicar `.glassEffect()` al final de la cadena de modificadores.
2. No anidar glass dentro de glass.
3. Usar `GlassEffectContainer` solo cuando varios elementos glass hermanos deban comportarse como conjunto.
4. Usar glass principalmente en navegacion, controles persistentes, menus, sheets y elementos clave.
5. Usar tint solo para acciones primarias.
6. No mezclar `regular` y `clear` sin una razon fuerte.
7. Si se usa `clear`, debe existir una capa de dimming que preserve legibilidad.
8. No usar scroll edge effects como decoracion.
9. No apilar varios efectos de borde en una misma vista.
10. Mantener texto y controles por encima de fondos extendidos para evitar distorsion visual.

### Cuando usar `regular`

Usar `regular` por defecto cuando:

- el elemento debe ser legible sobre cualquier fondo
- el control es pequeno o mediano
- el elemento es interactivo
- no queremos depender de una capa extra de dimming

### Cuando usar `clear`

Usar `clear` solo si se cumplen las tres condiciones que Apple marca:

1. El elemento esta sobre contenido rico visualmente.
2. Una capa de dimming no arruina el contenido.
3. El contenido encima del glass es bold y brillante.

Para LeanUp, esto probablemente aplica solo a:

- heroes o encabezados visuales futuros
- algun panel promocional o portada

No aplica como default para:

- la malla
- tablas de notas
- formularios
- listas densas

### Donde si tiene sentido en LeanUp

- tab bar principal
- boton back nativo
- search UI nativa futura
- sheets y menus
- toolbar o acciones persistentes
- cards de accion destacada muy puntuales

### Donde no deberia ser la solucion principal

- filas de materias
- tabla de progreso
- bloques largos de texto
- formularios con muchas entradas
- toda la app web completa

## APIs de Apple que mas nos convienen

### SwiftUI

- `TabView`
- `NavigationStack`
- `NavigationSplitView`
- `safeAreaBar`
- `tabBarMinimizeBehavior`
- `tabViewBottomAccessory`
- `backgroundExtensionEffect`
- `scrollEdgeEffectStyle`
- `glassEffect`
- `GlassEffectContainer`
- `glassEffectID`
- `GlassButtonStyle`
- `GlassProminentButtonStyle`

### UIKit

- `UITabBarController`
- `UISplitViewController`
- `UISearchController`
- `UINavigationItem`
- `UIVisualEffectView` + `UIGlassEffect`
- `UIGlassContainerEffect`
- `UIScrollEdgeEffect`
- `UIBackgroundExtensionView`

### Web / puente

- `WKWebView`
- `WKScriptMessageHandler`
- `WKUserContentController`

## Lo que esto significa para una app hibrida como LeanUp

### Lo bueno de la arquitectura actual

- Permite iterar rapido.
- Reutiliza la PWA.
- Ya tiene una capa nativa util para tab bar, back button, haptics y persistencia.
- Es una buena base de prototipo avanzado.

### Lo que limita a la app actual

- La mayor parte de la UI sigue siendo HTML dentro de `WKWebView`.
- Los componentes web no reciben automaticamente el nuevo comportamiento del sistema.
- Liquid Glass real del sistema no se aplica a la mayor parte de la experiencia.
- Muchos ajustes dependen de inyeccion JS y de sincronizacion entre dos mundos.
- El costo mental de mantener un `index.html` gigante y un `AppDelegate.swift` gigante es alto.

### Inferencia importante

Esto es una inferencia basada en la documentacion y sesiones oficiales de Apple:

Apple no prohibe usar web content, pero todo el discurso de iOS 26 y Liquid Glass esta construido alrededor de componentes nativos. Si nuestro objetivo es que LeanUp se sienta como una app Apple moderna y no como una web app embebida, entonces si conviene mover gradualmente la experiencia principal a SwiftUI.

## Recomendacion de arquitectura para LeanUp

### Recomendacion final

Adoptar una estrategia de migracion por fases hacia una arquitectura `SwiftUI-first`, no una reescritura total inmediata.

### Arquitectura objetivo

- Shell nativo en SwiftUI para navegacion, tabs, search, sheets, paneles y configuracion.
- Estado y modelos compartidos en Swift.
- Persistencia local nativa como fuente de verdad.
- `WKWebView` solo para contenido temporal o secciones aun no migradas.
- Capa web desacoplada por modulos, no un solo `index.html`.

### Por que no recomiendo una reescritura total ya mismo

- Riesgo alto de romper funciones academicas ya estabilizadas.
- Duplicaria trabajo si no definimos antes modelos, navegacion y persistencia.
- Hoy el repo aun necesita primero una profesionalizacion de estructura.

### Por que si recomiendo migrar

- SwiftUI y UIKit en iOS 26 dan mucho gratis: barras, tab bar, search, sheets, edge effects y comportamiento tactil.
- El diseno se vuelve mas consistente con Apple.
- La deuda tecnica baja si dejamos de inyectar tantos parches JS.
- A largo plazo sera mas facil mantener y ampliar la app.

## Plan recomendado por fases

### Fase 0 - Profesionalizar sin romper

Objetivo:

- dejar de depender de dos archivos gigantes

Acciones:

- separar `www/index.html` en `www/index.html`, `www/styles/*.css`, `www/scripts/*.js`
- separar `AppDelegate.swift` en archivos nuevos por responsabilidad
- extraer bridge, overlays, persistence, gestures y liquid glass a tipos separados
- documentar el modelo de datos actual de `leanup_v4`

Resultado:

- seguimos hibridos, pero con una base mantenible

### Fase 1 - Shell nativo real

Objetivo:

- mover la estructura de app a SwiftUI

Acciones:

- reemplazar la tab bar overlay por `TabView` nativo
- integrar busqueda nativa en la estructura correcta
- usar sheets nativos para flujos secundarios
- mover configuracion y perfil general a vistas SwiftUI

Resultado:

- la app ya empieza a sentirse iOS de verdad

### Fase 2 - Migrar las pantallas clave

Prioridad sugerida:

1. Dashboard
2. Malla curricular
3. Panel de detalle
4. Configuracion
5. Perfil profesional

Motivo:

- son las pantallas donde mas se nota la diferencia entre HTML y UI nativa

### Fase 3 - Reducir el area web

Dejar en web temporalmente si hace falta:

- bloques textuales largos
- contenidos editoriales
- prompts y portfolio mientras migramos

Objetivo:

- que el WebView deje de ser el centro de la app

## Estado de cumplimiento actual

- Fase 0 cumplida en lo que sigue importando para la app iOS actual:
  - `AppDelegate.swift` se separo
  - la capa nativa se modularizo
  - el modelo de datos quedo documentado
- Fase 1 cumplida:
  - shell nativa real en SwiftUI
  - tabs y estructura principales ya son nativos
- Fase 2 cumplida:
  - `Dashboard`, `Malla`, `Perfil` y `Configuracion` ya son pantallas nativas funcionales
- Fase 3 cumplida para iPhone:
  - el runtime iOS ya no depende de `WKWebView`
  - el bundle iOS ya no empaqueta `index.html`
  - el build del IPA ya no depende de `Capacitor`

Conclusión:

- La guia queda cumplida al 100% en su parte tecnica y arquitectonica para iPhone.
- Lo que sigue ya no es migracion estructural, sino polish visual final, refinamiento UX y nuevas funciones.

## Decisiones de implementacion para futuras tareas

### Decision 1

Para nuevas funciones importantes de iOS, preferir SwiftUI antes que HTML.

Ejemplos:

- search
- configuracion
- notificaciones
- paneles
- stats
- cards de progreso

### Decision 2

No crear mas logica grande directamente dentro de `AppDelegate.swift`.

Crear modulos nuevos para:

- `NativeUIBridge`
- `PersistenceController`
- `GlassOverlayCoordinator`
- `PanelGestureCoordinator`
- `WebViewRestoreController`

### Decision 3

No agregar mas features grandes al `index.html` monolitico sin antes considerar extraerlas.

### Decision 4

Cuando queramos "verse mas Apple", primero buscar si existe un componente estandar del sistema antes de inventar una solucion custom.

## Checklist de revision antes de implementar UI nueva

1. Existe un componente estandar de SwiftUI o UIKit que ya resuelva esto.
2. Esta UI pertenece a navegacion o a contenido.
3. Si lleva Liquid Glass, esta en la capa correcta.
4. La legibilidad sigue siendo buena sobre contenido claro y oscuro.
5. No estamos apilando glass sobre glass.
6. No estamos tapando contenido con overlays innecesarios.
7. El comportamiento en scroll esta alineado con edge effects del sistema.
8. La solucion mejora la app en iPhone y no solo en una captura bonita.
9. La solucion reduce deuda tecnica o al menos no la aumenta.
10. Si se queda en web temporalmente, existe un plan claro para migrarla.

## Recomendacion concreta para el siguiente paso

El siguiente paso recomendado ya no es otra migracion tecnica grande.

Ahora conviene:

1. hacer una pasada fuerte de polish visual y consistencia total
2. elevar jerarquia visual, navegacion y microinteracciones
3. despues sumar nuevas funciones nativas de valor

- `Malla curricular`, pero solo despues de definir bien modelos, navegacion y persistencia

## Fuentes oficiales de Apple consultadas

Estas fueron las fuentes principales y oficiales usadas para esta guia:

- [Liquid Glass overview](https://developer.apple.com/documentation/technologyoverviews/liquid-glass)
- [Meet Liquid Glass - WWDC25](https://developer.apple.com/videos/play/wwdc2025/219/)
- [Get to know the new design system - WWDC25](https://developer.apple.com/videos/play/wwdc2025/356/)
- [Build a SwiftUI app with the new design - WWDC25](https://developer.apple.com/videos/play/wwdc2025/323/)
- [Build a UIKit app with the new design - WWDC25](https://developer.apple.com/videos/play/wwdc2025/284/)
- [Meet WebKit for SwiftUI - WWDC25](https://developer.apple.com/videos/play/wwdc2025/231/)
- [Scroll views - Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/scroll-views)
- [GlassEffectTransition docs hub](https://developer.apple.com/documentation/swiftui/glasseffecttransition)
- [safeAreaBar](https://developer.apple.com/documentation/swiftui/view/safeareabar%28edge%3Aalignment%3Aspacing%3Acontent%3A%29)
- [backgroundExtensionEffect](https://developer.apple.com/documentation/swiftui/view/backgroundextensioneffect%28isenabled%3A%29)
- [tabViewBottomAccessory](https://developer.apple.com/documentation/swiftui/view/tabviewbottomaccessory%28content%3A%29)
- [TabBarMinimizeBehavior](https://developer.apple.com/documentation/swiftui/tabbarminimizebehavior)
- [Landmarks: Building an app with Liquid Glass](https://developer.apple.com/documentation/swiftui/landmarks-building-an-app-with-liquid-glass)

## Nota final para LeanUp

LeanUp ya paso la etapa de idea. Ya existe una app funcional y con valor real.

Lo que sigue no es "hacerla bonita" solamente. Lo que sigue es pasar de:

- prototipo potente

a:

- producto iOS con estructura profesional

La mejor forma de hacerlo no es destruir lo que ya funciona.

La mejor forma es:

- ordenar
- modularizar
- migrar con criterio
- adoptar lo nativo donde Apple ya nos regala calidad
