import SwiftUI

struct LeanUpDashboardView: View {
    @ObservedObject var model: LeanUpAppModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                LeanUpDashboardHero(model: model)
                LeanUpDashboardSnapshotBand(model: model)
                LeanUpDashboardAcademicStageCard(model: model)
                LeanUpDashboardMomentumCard(model: model)
                LeanUpDashboardDirectionCard(model: model)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(LeanUpPageBackground())
        .navigationTitle("LeanUp")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct LeanUpDashboardHero: View {
    @ObservedObject var model: LeanUpAppModel
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(heroGradient)

            Circle()
                .stroke(Color.white.opacity(0.20), lineWidth: 1)
                .frame(width: 220, height: 220)
                .offset(x: 170, y: -82)

            Circle()
                .fill(Color.unadGold.opacity(0.16))
                .frame(width: 110, height: 110)
                .offset(x: 190, y: -18)

            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Panel de avance")
                            .font(.caption.weight(.bold))
                            .tracking(1.2)
                            .foregroundStyle(Color.white.opacity(0.74))

                        Text("Hola, \(model.snapshot.username)")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text(heroMessage)
                            .font(.subheadline)
                            .foregroundStyle(Color.white.opacity(0.82))
                    }

                    Spacer(minLength: 12)

                    VStack(alignment: .trailing, spacing: 8) {
                        Image(systemName: "sparkles.rectangle.stack.fill")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(Color.unadGold)

                        Text("\(model.careerReadinessPercent)%")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)

                        Text("Traccion")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.white.opacity(0.68))
                    }
                }

                HStack(spacing: 12) {
                    LeanUpInlineMetric(title: "Malla cerrada", value: model.completionPercentText)
                    LeanUpInlineMetric(title: "Periodo foco", value: periodFocusText)
                }

                HStack(spacing: 10) {
                    LeanUpPill(text: "\(model.earnedCredits) creditos", icon: "bolt.fill")
                    LeanUpPill(text: "\(model.registeredCount) notas", icon: "chart.bar.fill")
                    LeanUpPill(text: model.themeDescription, icon: "circle.lefthalf.filled")
                }
            }
            .padding(24)
        }
        .shadow(color: Color.unadNavy.opacity(scheme == .dark ? 0.16 : 0.10), radius: 12, x: 0, y: 8)
    }

    private var heroGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.unadNavy.opacity(scheme == .dark ? 0.98 : 0.94),
                Color.unadBlue.opacity(scheme == .dark ? 0.90 : 0.86),
                Color.unadCyan.opacity(scheme == .dark ? 0.76 : 0.70)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var heroMessage: String {
        if model.failedCount > 0 {
            return "Tu avance ya es real, pero conviene corregir primero lo que hoy esta empujando el promedio hacia abajo."
        }

        if model.electiveGroupsWithoutSelection > 0 {
            return "Ya tienes base academica suficiente para empezar a orientar mejor el perfil. El siguiente paso es definir las electivas que faltan."
        }

        if let role = model.recommendedRoles.first {
            return "Tu progreso ya empieza a dibujar una ruta profesional clara hacia \(role)."
        }

        return "Tu progreso esta bien organizado y listo para crecer con una lectura mas clara de carrera."
    }

    private var periodFocusText: String {
        model.focusPeriod.map(String.init) ?? "Listo"
    }
}

struct LeanUpDashboardSnapshotBand: View {
    @ObservedObject var model: LeanUpAppModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            LeanUpDashboardStatTile(
                eyebrow: "Promedio",
                value: model.averageText,
                subtitle: "Rendimiento general",
                tint: .unadBlue,
                icon: "waveform.path.ecg"
            )
            LeanUpDashboardStatTile(
                eyebrow: "Creditos",
                value: "\(model.earnedCredits)",
                subtitle: "Ganados hasta hoy",
                tint: .unadGold,
                icon: "bolt.badge.checkmark.fill"
            )
            LeanUpDashboardStatTile(
                eyebrow: "Aprobadas",
                value: "\(model.approvedCount)",
                subtitle: "Base consolidada",
                tint: .green,
                icon: "checkmark.seal.fill"
            )
            LeanUpDashboardStatTile(
                eyebrow: "Pendientes",
                value: "\(model.pendingCount)",
                subtitle: "Frentes abiertos",
                tint: model.failedCount > 0 ? .orange : .unadCyan,
                icon: "scope"
            )
        }
    }
}

struct LeanUpDashboardAcademicStageCard: View {
    @ObservedObject var model: LeanUpAppModel

    var body: some View {
        LeanUpSurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
                LeanUpSectionHeader(
                    eyebrow: "Momento academico",
                    title: stageTitle,
                    detail: stageDetail
                )

                HStack(spacing: 12) {
                    LeanUpDashboardAccentStat(
                        title: "Alertas",
                        value: "\(model.failedCount)",
                        caption: model.failedCount > 0 ? "Por recuperar" : "Sin rojos",
                        tint: model.failedCount > 0 ? .red : .green
                    )

                    LeanUpDashboardAccentStat(
                        title: "Electivas",
                        value: "\(model.electiveGroupsWithoutSelection)",
                        caption: "Por definir",
                        tint: .unadGold
                    )

                    LeanUpDashboardAccentStat(
                        title: "Impulso",
                        value: model.completionPercentText,
                        caption: "Malla cerrada",
                        tint: .unadCyan
                    )
                }

                LeanUpProgressTrack(
                    title: "Tramo completado de la malla",
                    valueText: model.completionPercentText,
                    progress: completionRatio,
                    tint: .unadBlue
                )

                LeanUpProgressTrack(
                    title: "Lectura de preparación profesional",
                    valueText: "\(model.careerReadinessPercent)%",
                    progress: Double(model.careerReadinessPercent) / 100.0,
                    tint: .unadGold
                )
            }
        }
    }

    private var completionRatio: Double {
        guard model.totalTrackableItems > 0 else { return 0 }
        return Double(model.approvedCount) / Double(model.totalTrackableItems)
    }

    private var stageTitle: String {
        if model.failedCount > 0 {
            return "Hay progreso, pero toca proteger el promedio."
        }

        if model.electiveGroupsWithoutSelection > 0 {
            return "El siguiente salto esta en cerrar tu direccion."
        }

        return "Tu recorrido ya tiene una base academica consistente."
    }

    private var stageDetail: String {
        if model.failedCount > 0 {
            return "Antes de empujar mas carga nueva, conviene recuperar lo reprobado para que el avance se sienta mas solido."
        }

        if model.electiveGroupsWithoutSelection > 0 {
            return "Definir las electivas pendientes va a hacer que Perfil y recomendaciones se vuelvan mas precisas y mas utiles."
        }

        return "Ya puedes leer tu progreso no solo como notas sueltas, sino como una historia academica con direccion."
    }
}

struct LeanUpDashboardMomentumCard: View {
    @ObservedObject var model: LeanUpAppModel

    var body: some View {
        LeanUpSurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
                LeanUpSectionHeader(
                    eyebrow: "Siguiente movimiento",
                    title: nextMoveTitle,
                    detail: model.nextProfessionalMove
                )

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(priorityItems) { item in
                        LeanUpPriorityRow(
                            icon: item.icon,
                            tint: item.tint,
                            title: item.title,
                            detail: item.detail
                        )
                    }
                }

                if !periodRows.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Pulso por periodos")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)

                        ForEach(periodRows) { row in
                            LeanUpDashboardPeriodRow(row: row)
                        }
                    }
                }
            }
        }
    }

    private var nextMoveTitle: String {
        if model.failedCount > 0 {
            return "Recuperar ahora vale mas que abrir mas frentes."
        }

        if model.electiveGroupsWithoutSelection > 0 {
            return "Tus decisiones de electivas ya empiezan a pesar."
        }

        return model.focusPeriod.map { "El periodo \($0) es tu siguiente tramo fuerte." } ?? "Tu mapa academico ya tiene inercia."
    }

    private var priorityItems: [LeanUpDashboardPriorityItem] {
        [
            LeanUpDashboardPriorityItem(
                icon: model.failedCount > 0 ? "exclamationmark.triangle.fill" : "checkmark.circle.fill",
                tint: model.failedCount > 0 ? .red : .green,
                title: model.failedCount > 0 ? "\(model.failedCount) elementos necesitan recuperacion" : "No tienes alertas criticas",
                detail: model.failedCount > 0
                    ? "Esa es la accion con mas impacto inmediato sobre el promedio y la tranquilidad del semestre."
                    : "Tu base actual esta limpia y te deja enfocarte en avanzar con orden."
            ),
            LeanUpDashboardPriorityItem(
                icon: "flag.fill",
                tint: .unadBlue,
                title: model.focusPeriod.map { "Periodo foco: \($0)" } ?? "Ruta general activa",
                detail: model.focusPeriod.map { _ in
                    "Ese bloque es donde conviene concentrar energia para que el avance se note rapido."
                } ?? "Tu avance actual te permite seguir construyendo desde varias areas sin perder coherencia."
            ),
            LeanUpDashboardPriorityItem(
                icon: "square.grid.2x2.fill",
                tint: .unadGold,
                title: model.electiveGroupsWithoutSelection == 0
                    ? "Las electivas ya tienen rumbo"
                    : "\(model.electiveGroupsWithoutSelection) grupos electivos esperan decision",
                detail: model.electiveGroupsWithoutSelection == 0
                    ? "Eso ya esta empujando una narrativa profesional mas clara."
                    : "Resolverlo pronto te va a ayudar a conectar mejor lo academico con el perfil que quieres mostrar."
            ),
        ]
    }

    private var periodRows: [LeanUpDashboardPeriodSummary] {
        model.periods.prefix(4).map { period in
            let progress = model.progress(for: period)
            return LeanUpDashboardPeriodSummary(
                period: period,
                approved: progress.approved,
                failed: progress.failed,
                total: progress.total,
                ratio: progress.completionRatio,
                isFocus: model.focusPeriod == period
            )
        }
    }
}

struct LeanUpDashboardDirectionCard: View {
    @ObservedObject var model: LeanUpAppModel

    var body: some View {
        LeanUpSurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
                LeanUpSectionHeader(
                    eyebrow: "Direccion profesional",
                    title: model.professionalHeadline,
                    detail: model.professionalSummary
                )

                if !focusItems.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Focos que ya se estan notando")
                            .font(.subheadline.weight(.semibold))
                        FlowTagList(items: focusItems)
                    }
                }

                if !roleItems.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Roles que ya empiezan a tomar forma")
                            .font(.subheadline.weight(.semibold))
                        ForEach(roleItems, id: \.self) { role in
                            LeanUpChecklistRow(text: role)
                        }
                    }
                }

                LeanUpDashboardSignalStrip(
                    readiness: "\(model.careerReadinessPercent)%",
                    electives: "\(model.selectedElectivesCount)",
                    evidence: "\(model.approvedCount)"
                )
            }
        }
    }

    private var focusItems: [String] {
        Array(model.activeFocusNames.prefix(4))
    }

    private var roleItems: [String] {
        Array(model.recommendedRoles.prefix(3))
    }
}

struct LeanUpDashboardStatTile: View {
    let eyebrow: String
    let value: String
    let subtitle: String
    let tint: Color
    let icon: String

    var body: some View {
        LeanUpSurfaceCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(eyebrow.uppercased())
                        .font(.caption.weight(.bold))
                        .tracking(1.0)
                        .foregroundStyle(tint)
                    Spacer()
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(tint)
                }

                Text(value)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct LeanUpDashboardAccentStat: View {
    let title: String
    let value: String
    let caption: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.bold))
                .tracking(0.8)
                .foregroundStyle(tint)
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
            Text(caption)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(tint.opacity(0.10))
        )
    }
}

struct LeanUpDashboardSignalStrip: View {
    let readiness: String
    let electives: String
    let evidence: String

    var body: some View {
        HStack(spacing: 12) {
            LeanUpDashboardSignalPill(label: "Preparacion", value: readiness, tint: .unadBlue)
            LeanUpDashboardSignalPill(label: "Electivas", value: electives, tint: .unadGold)
            LeanUpDashboardSignalPill(label: "Evidencia", value: evidence, tint: .green)
        }
    }
}

struct LeanUpDashboardSignalPill: View {
    let label: String
    let value: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(tint.opacity(0.10))
        )
    }
}

struct LeanUpDashboardPeriodRow: View {
    let row: LeanUpDashboardPeriodSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Text("Periodo \(row.period)")
                        .font(.subheadline.weight(.semibold))
                    if row.isFocus {
                        Text("FOCO")
                            .font(.caption2.weight(.bold))
                            .tracking(0.8)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(Color.unadGold.opacity(0.18)))
                            .foregroundStyle(Color.unadGold)
                    }
                }
                Spacer()
                Text("\(row.approved)/\(row.total)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(row.isFocus ? Color.unadBlue : .secondary)
            }

            GeometryReader { proxy in
                let width = max(proxy.size.width, 0)
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.08))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.unadBlue.opacity(0.55), Color.unadCyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(width * row.ratio, 10))
                }
            }
            .frame(height: 8)

            Text(row.detailText)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.primary.opacity(0.05))
        )
    }
}

struct LeanUpDashboardPriorityItem: Identifiable {
    let id = UUID()
    let icon: String
    let tint: Color
    let title: String
    let detail: String
}

struct LeanUpDashboardPeriodSummary: Identifiable {
    var id: Int { period }

    let period: Int
    let approved: Int
    let failed: Int
    let total: Int
    let ratio: Double
    let isFocus: Bool

    var detailText: String {
        if failed > 0 {
            return "\(failed) elementos en rojo. Conviene estabilizar este bloque antes de seguir acelerando."
        }

        if approved == total {
            return "Este periodo ya se ve muy bien cerrado y aporta solidez al perfil."
        }

        return "Tiene avance, pero aun guarda espacio claro para seguir sumando evidencia academica."
    }
}
