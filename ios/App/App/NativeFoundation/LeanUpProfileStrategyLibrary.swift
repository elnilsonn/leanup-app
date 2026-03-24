import Foundation

enum LeanUpProfileInsightTone {
    case blue
    case green
    case gold
    case orange
    case red
}

enum LeanUpPortfolioReadinessState {
    case ready
    case almostReady
    case missingBase

    var title: String {
        switch self {
        case .ready: return "Ya puedes empezarlo"
        case .almostReady: return "Casi listo"
        case .missingBase: return "Aun te falta base"
        }
    }
}

enum LeanUpFreelancerChecklistStatus {
    case ready
    case inProgress
    case pending

    var title: String {
        switch self {
        case .ready: return "Listo"
        case .inProgress: return "En progreso"
        case .pending: return "Pendiente"
        }
    }
}

struct LeanUpProfileAlignmentInsight {
    let statusTitle: String
    let title: String
    let detail: String
    let detectedAreas: [String]
    let recommendation: String
    let confidenceText: String
    let tone: LeanUpProfileInsightTone
}

struct LeanUpMilestoneInsight {
    let title: String
    let detail: String
    let badgeText: String
    let targetPercent: Int
    let creditsRemaining: Int
    let progress: Double
}

struct LeanUpSubjectTypeCount: Identifiable, Hashable {
    var id: String { type }

    let type: String
    let approved: Int
    let remaining: Int
}

struct LeanUpSubjectTypeMap {
    let entries: [LeanUpSubjectTypeCount]
    let dominantType: String?
    let laggingType: String?
    let summary: String
}

struct LeanUpServiceRecommendation {
    let title: String
    let summary: String
    let whyYouCanOfferIt: String
    let priceText: String
    let nextEvidence: String
    let confidenceText: String
    let supportingSignals: [String]
    let tone: LeanUpProfileInsightTone
}

struct LeanUpPortfolioRoadmapItem: Identifiable, Hashable {
    let id: String
    let title: String
    let objective: String
    let whyItMatters: String
    let readiness: LeanUpPortfolioReadinessState
    let supportingSignals: [String]
}

struct LeanUpFreelancerChecklistItem: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
    let status: LeanUpFreelancerChecklistStatus
}

struct LeanUpFreelancerChecklist {
    let items: [LeanUpFreelancerChecklistItem]
    let overallTitle: String
    let overallDetail: String
}

struct LeanUpElectiveClusterRule {
    let area: String
    let keywords: [String]
}

struct LeanUpServiceRule {
    let id: String
    let title: String
    let summary: String
    let requiredAreas: [String]
    let keywords: [String]
    let minCredits: Int
    let priceRangeUSD: ClosedRange<Int>
    let nextEvidence: String
}

struct LeanUpPortfolioRule {
    let id: String
    let title: String
    let objective: String
    let whyItMatters: String
    let keywords: [String]
}

enum LeanUpProfileStrategyLibrary {
    static let trackedSubjectTypes = [
        "Teórica",
        "Práctica",
        "Lectura",
        "Números"
    ]

    static let electiveClusters: [LeanUpElectiveClusterRule] = [
        LeanUpElectiveClusterRule(
            area: "Marketing y growth",
            keywords: ["inbound marketing", "marketing digital", "analitica web", "seo", "sem", "email marketing", "growth", "marketing fundamentals"]
        ),
        LeanUpElectiveClusterRule(
            area: "Contenido y comunicación",
            keywords: ["narrativas digitales", "copywriting", "social media", "contenido", "diseno para redes", "comunicacion", "relaciones publicas", "video marketing"]
        ),
        LeanUpElectiveClusterRule(
            area: "Investigación y estrategia",
            keywords: ["investigacion", "analista estrategico", "planner", "buyer persona", "customer journey", "mercados", "insights", "diagnostico empresarial"]
        ),
        LeanUpElectiveClusterRule(
            area: "Analítica y datos",
            keywords: ["big data", "analitica web", "tableau", "analista de datos", "metricas", "estadistica", "data-driven", "dashboard"]
        ),
        LeanUpElectiveClusterRule(
            area: "Negocios e innovación",
            keywords: ["innovacion", "intraemprendimiento", "emprendimiento", "modelos de negocio", "product manager", "toma de decisiones"]
        ),
        LeanUpElectiveClusterRule(
            area: "Finanzas y pricing",
            keywords: ["finanzas", "matematica financiera", "pricing", "costos", "presupuestos", "rentabilidad", "roi"]
        ),
        LeanUpElectiveClusterRule(
            area: "Internacionalización",
            keywords: ["internacional", "exportaciones", "importaciones", "mercados globales", "marketing internacional", "entry strategy", "trade", "localizacion"]
        ),
        LeanUpElectiveClusterRule(
            area: "Sostenibilidad e impacto",
            keywords: ["sostenibilidad", "comercio justo", "gestion ambiental", "esg", "impacto social", "economia circular", "stakeholder"]
        )
    ]

    static let serviceRules: [LeanUpServiceRule] = [
        LeanUpServiceRule(
            id: "research",
            title: "Research express de cliente y buyer persona",
            summary: "Un entregable simple para ayudar a una marca pequena a entender mejor a su cliente ideal antes de vender o crear contenido.",
            requiredAreas: ["Investigación y estrategia"],
            keywords: ["investigacion", "buyer persona", "customer journey", "insights", "encuesta", "focus group"],
            minCredits: 18,
            priceRangeUSD: 60...120,
            nextEvidence: "Un caso corto con encuesta, hallazgos y buyer persona te haria ver mucho mas cobrable."
        ),
        LeanUpServiceRule(
            id: "content",
            title: "Kit basico de contenido para redes",
            summary: "Un paquete inicial de ideas, copies y piezas para una marca local que necesita moverse mejor en redes.",
            requiredAreas: ["Contenido y comunicación", "Marketing y growth"],
            keywords: ["contenido", "copywriting", "narrativas digitales", "social media", "diseno para redes", "video marketing"],
            minCredits: 15,
            priceRangeUSD: 80...160,
            nextEvidence: "Tener un mini portafolio con 5 a 10 piezas reales subiria mucho la confianza de esta oferta."
        ),
        LeanUpServiceRule(
            id: "dashboard",
            title: "Dashboard basico de metricas y rendimiento",
            summary: "Una lectura inicial de ventas, trafico o conversion para negocios pequenos que aun no miran sus datos con orden.",
            requiredAreas: ["Analítica y datos", "Finanzas y pricing"],
            keywords: ["tableau", "analitica web", "estadistica", "dashboard", "metricas", "pricing", "roi"],
            minCredits: 24,
            priceRangeUSD: 90...180,
            nextEvidence: "Un dashboard con KPIs y una recomendacion escrita te daria una prueba mucho mas vendible."
        ),
        LeanUpServiceRule(
            id: "strategy",
            title: "Diagnostico inicial de marketing digital",
            summary: "Una auditoria prudente para revisar canales, mensaje y oportunidades rapidas de mejora sin prometer una consultoria completa.",
            requiredAreas: ["Marketing y growth", "Investigación y estrategia"],
            keywords: ["marketing digital", "seo", "sem", "analitica web", "diagnostico", "plan", "estrategia"],
            minCredits: 30,
            priceRangeUSD: 120...220,
            nextEvidence: "Una auditoria con hallazgos priorizados y plan de 30 dias te pondria mas cerca de cobrarlo sin friccion."
        ),
        LeanUpServiceRule(
            id: "pricing",
            title: "Recomendacion inicial de pricing y rentabilidad",
            summary: "Una lectura sencilla para negocios que quieren revisar precio, margen y punto de equilibrio antes de escalar.",
            requiredAreas: ["Finanzas y pricing", "Negocios e innovación"],
            keywords: ["pricing", "finanzas", "costos", "presupuestos", "rentabilidad", "matematica financiera"],
            minCredits: 27,
            priceRangeUSD: 110...200,
            nextEvidence: "Un caso con estructura de costos y propuesta de precios reforzaria mucho esta oferta."
        )
    ]

    static let portfolioRules: [LeanUpPortfolioRule] = [
        LeanUpPortfolioRule(
            id: "marketing-audit",
            title: "Auditoria de marketing y plan de 30 dias",
            objective: "Analizar una marca real, detectar puntos flojos y proponer acciones concretas por canal.",
            whyItMatters: "Te sirve para vender pensamiento estrategico, no solo ejecucion.",
            keywords: ["marketing digital", "seo", "sem", "analitica web", "marketing fundamentals", "estrategia"]
        ),
        LeanUpPortfolioRule(
            id: "buyer-persona",
            title: "Buyer persona + customer journey",
            objective: "Construir un perfil de cliente completo con insights, dolores, motivaciones y etapas de decision.",
            whyItMatters: "Es una pieza muy util para research, branding y contenido.",
            keywords: ["investigacion", "buyer persona", "customer journey", "insights", "encuesta", "focus group"]
        ),
        LeanUpPortfolioRule(
            id: "content-pack",
            title: "Pack de contenido multicanal",
            objective: "Crear un paquete de piezas y copies listo para Instagram, TikTok o LinkedIn.",
            whyItMatters: "Te deja mostrar ejecucion visual y criterio de comunicacion al mismo tiempo.",
            keywords: ["contenido", "copywriting", "narrativas digitales", "social media", "diseno para redes", "video marketing"]
        ),
        LeanUpPortfolioRule(
            id: "analytics-dashboard",
            title: "Dashboard de KPIs con recomendaciones",
            objective: "Montar una vista clara de metricas, interpretar lo que pasa y dejar decisiones sugeridas.",
            whyItMatters: "Hace visible tu lado data-driven aunque aun no tengas experiencia laboral.",
            keywords: ["dashboard", "estadistica", "analitica web", "tableau", "metricas", "roi"]
        ),
        LeanUpPortfolioRule(
            id: "pricing-case",
            title: "Caso de pricing y rentabilidad",
            objective: "Justificar una propuesta de precio con datos, costos y escenario financiero simple.",
            whyItMatters: "Te diferencia de perfiles que solo hablan de creatividad sin criterio de negocio.",
            keywords: ["pricing", "finanzas", "costos", "presupuestos", "rentabilidad", "matematica financiera"]
        ),
        LeanUpPortfolioRule(
            id: "international-entry",
            title: "Plan de entrada a mercado internacional",
            objective: "Elegir un mercado, adaptar oferta y proponer un roadmap inicial de expansion.",
            whyItMatters: "Te posiciona para consultoria junior, trade o marketing internacional.",
            keywords: ["internacional", "exportaciones", "importaciones", "mercados globales", "localizacion", "entry strategy"]
        )
    ]

    static let toolKeywords = [
        "google workspace",
        "google sheets",
        "tableau",
        "excel",
        "dashboard",
        "trabajo remoto",
        "gestion de proyectos digitales",
        "analitica web",
        "email marketing"
    ]

    static func priceText(for range: ClosedRange<Int>) -> String {
        "$\(range.lowerBound)-$\(range.upperBound) USD"
    }
}

extension String {
    var leanUpProfileKey: String {
        folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
