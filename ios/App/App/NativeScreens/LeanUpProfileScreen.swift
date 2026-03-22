import UIKit
import SwiftUI
import UniformTypeIdentifiers

struct LeanUpProfileView: View {
    @ObservedObject var model: LeanUpAppModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                LeanUpProfileHeroCard(model: model)
                LeanUpProfileStrategyCard(model: model)

                if !model.highlightedCareerItems.isEmpty {
                    LeanUpSurfaceCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Evidencia de tu avance", systemImage: "checkmark.seal.fill")
                                .font(.headline.weight(.semibold))

                            Text("Estas materias y electivas ya funcionan como pruebas concretas de lo que vienes construyendo.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(model.highlightedCareerItems) { item in
                                    LeanUpCareerEvidenceCard(item: item)
                                }
                            }
                        }
                    }
                }

                LeanUpSurfaceCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("LinkedIn listo para adaptar", systemImage: "text.badge.checkmark")
                            .font(.headline.weight(.semibold))

                        if model.linkedinHighlights.isEmpty {
                            Text("Cuando acumules mas evidencia academica, aqui apareceran textos que te ayuden a describir mejor tu perfil en LinkedIn.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(model.linkedinHighlights.prefix(3))) { item in
                                    LeanUpLinkedInCard(item: item)
                                }
                            }
                        }
                    }
                }

                LeanUpSurfaceCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Portafolio con lo que ya sabes", systemImage: "folder.fill.badge.plus")
                            .font(.headline.weight(.semibold))

                        if model.portfolioHighlights.isEmpty {
                            Text("Aqui iran apareciendo ideas de proyecto a medida que tu recorrido deje mas evidencia util para portafolio.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(Array(model.portfolioHighlights.prefix(3))) { item in
                                    LeanUpPortfolioCard(item: item)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(LeanUpPageBackground())
        .navigationTitle("Perfil")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct LeanUpProfileHeroCard: View {
    @ObservedObject var model: LeanUpAppModel

    var body: some View {
        LeanUpSurfaceCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(model.snapshot.username)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        Text(model.profileHeadline)
                            .font(.title3.weight(.bold))
                        Text(model.profileSummary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(.system(size: 34))
                        .foregroundStyle(Color.unadBlue)
                }

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    LeanUpInlineMetric(title: "Preparacion", value: "\(model.careerReadinessPercent)%")
                    LeanUpInlineMetric(title: "Aprobadas", value: "\(model.approvedCount)")
                    LeanUpInlineMetric(title: "Habilidades", value: "\(model.standoutSkills.count)")
                    LeanUpInlineMetric(title: "Evidencias", value: "\(model.careerItems.count)")
                }
            }
        }
    }
}

struct LeanUpProfileStrategyCard: View {
    @ObservedObject var model: LeanUpAppModel

    var body: some View {
        LeanUpSurfaceCard {
            VStack(alignment: .leading, spacing: 12) {
                Label("Panorama profesional", systemImage: "waveform.path.ecg.rectangle.fill")
                    .font(.headline.weight(.semibold))

                Text(model.nextProfessionalMove)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 12) {
                    LeanUpPriorityRow(
                        icon: "chart.bar.fill",
                        tint: .unadBlue,
                        title: "\(model.earnedCredits) creditos ya respaldan tu perfil",
                        detail: "Tu avance academico ya no es abstracto. Ya tienes una base cuantificable para hablar de progreso real."
                    )

                    LeanUpPriorityRow(
                        icon: model.standoutSkills.isEmpty ? "sparkles" : "star.square.on.square.fill",
                        tint: model.standoutSkills.isEmpty ? .secondary : .green,
                        title: model.standoutSkills.isEmpty ? "Aun faltan habilidades visibles" : "\(model.standoutSkills.count) habilidades empiezan a repetirse",
                        detail: model.standoutSkills.isEmpty
                            ? "Cuando apruebes mas materias y electivas, esta lectura se volvera mas precisa."
                            : "Cuando una habilidad aparece varias veces en tu recorrido, ya empieza a sentirse como una senal profesional."
                    )

                    LeanUpPriorityRow(
                        icon: model.careerItems.isEmpty ? "clock.fill" : "folder.fill.badge.plus",
                        tint: model.careerItems.isEmpty ? .orange : .unadGold,
                        title: model.careerItems.isEmpty ? "Aun no hay evidencia lista para mostrar" : "\(model.careerItems.count) piezas ya alimentan tu narrativa",
                        detail: model.careerItems.isEmpty
                            ? "Registra mas notas aprobadas para que Perfil conecte mejor tu malla con salidas reales."
                            : "Tus materias y electivas aprobadas ya se convierten en texto, skills y proyectos concretos."
                    )
                }

                if !model.activeFocusNames.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rutas activas")
                            .font(.subheadline.weight(.semibold))
                        FlowTagList(items: Array(model.activeFocusNames.prefix(6)))
                    }
                }

                if !model.recommendedRoles.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Roles que toman forma")
                            .font(.subheadline.weight(.semibold))

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ],
                            spacing: 12
                        ) {
                            ForEach(Array(model.recommendedRoles.prefix(6)), id: \.self) { role in
                                LeanUpRoleCard(role: role)
                            }
                        }
                    }
                }

                if !model.standoutSkills.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Habilidades mas visibles")
                            .font(.subheadline.weight(.semibold))
                        FlowTagList(items: Array(model.standoutSkills.prefix(8)))
                    }
                }
            }
        }
    }
}

struct LeanUpCareerEvidenceCard: View {
    let item: LeanUpCareerItem

    var body: some View {
        LeanUpSurfaceInsetCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.subheadline.weight(.semibold))
                        Text("Periodo \(item.period)\(item.isElective ? " - Electiva" : " - Materia")")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: item.isElective ? "square.grid.2x2.fill" : "book.closed.fill")
                        .foregroundStyle(item.isElective ? Color.unadGold : Color.unadBlue)
                }

                Text(item.summary)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                Text(item.outcomes)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.primary)

                if !item.skills.isEmpty {
                    FlowTagList(items: Array(item.skills.prefix(4)))
                }
            }
        }
    }
}

struct LeanUpRoleCard: View {
    let role: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "briefcase.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(Color.unadBlue)
            Text(role)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 88, alignment: .topLeading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.unadBlue.opacity(0.08))
        )
    }
}

struct LeanUpLinkedInCard: View {
    let item: LeanUpCareerItem
    @State private var copied = false

    var body: some View {
        LeanUpSurfaceInsetCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.name)
                            .font(.subheadline.weight(.semibold))
                        Text("Periodo \(item.period)\(item.isElective ? " - Electiva" : "")")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        UIPasteboard.general.setItems(
                            [[UTType.plainText.identifier: item.linkedinText]],
                            options: [:]
                        )
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.75)) {
                            copied = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                                copied = false
                            }
                        }
                    } label: {
                        Label(copied ? "Copiado" : "Copiar", systemImage: copied ? "checkmark.circle.fill" : "doc.on.doc")
                            .font(.caption.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .foregroundStyle(copied ? Color.white : Color.primary)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(copied ? Color.green : Color.primary.opacity(0.08))
                    )
                    .frame(width: 108)
                    .scaleEffect(copied ? 1.03 : 1.0)
                    .animation(.spring(response: 0.22, dampingFraction: 0.72), value: copied)
                }

                Text(item.linkedinText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct LeanUpPortfolioCard: View {
    let item: LeanUpCareerItem

    var body: some View {
        LeanUpSurfaceInsetCard {
            VStack(alignment: .leading, spacing: 10) {
                Text(item.name)
                    .font(.subheadline.weight(.semibold))

                Text(item.portfolioProject)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                if !item.skills.isEmpty {
                    FlowTagList(items: Array(item.skills.prefix(4)))
                }
            }
        }
    }
}

struct LeanUpSurfaceInsetCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.primary.opacity(0.04))
            )
    }
}
