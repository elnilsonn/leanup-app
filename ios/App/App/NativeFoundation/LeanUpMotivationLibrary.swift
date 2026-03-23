import Foundation

enum LeanUpMotivationLibrary {
    static let titles: [String] = [
        "Hoy tambien cuenta, aunque no lo sientas enorme.",
        "No todo avance hace ruido, y eso no le quita valor.",
        "Tu carrera tambien se construye en dias tranquilos.",
        "Lo que hoy ordenas te ahorra peso despues.",
        "No necesitas sentirte perfecta para seguir avanzando.",
        "Incluso un paso pequeno puede cambiarte la semana.",
        "Seguir presente ya es una decision importante.",
        "Hay dias para correr y dias para sostenerse.",
        "No subestimes lo que estas logrando con constancia.",
        "La claridad que ganas hoy tambien es progreso.",
        "Tu esfuerzo merece una lectura mas justa.",
        "No todo se mide por velocidad.",
        "La carrera no te pide perfeccion, te pide continuidad.",
        "Respirar y reorganizar tambien cuenta como avanzar.",
        "Lo que hoy te pesa tambien puede ordenarse.",
        "Tu proceso tiene mas valor del que a veces le das.",
        "Seguir mirando de frente la malla ya es valentia.",
        "Hay progreso incluso cuando el dia se siente discreto.",
        "No te hables como si fueras tarde para todo.",
        "Avanzar con calma sigue siendo avanzar."
    ]

    static let endings: [String] = [
        "Si hoy solo puedes dejar una cosa mejor ubicada, ya hiciste algo valioso por ti.",
        "Tu cerebro descansa mas cuando sabe exactamente que sigue, y por eso ordenar importa tanto.",
        "No hace falta resolver el semestre entero en una tarde para sentir que recuperaste el control.",
        "A veces lo mas sano es bajar el ruido y enfocarte en una sola decision buena.",
        "La forma en que te acompanas tambien influye en como atraviesas la carrera.",
        "Mirar tu avance con calma no te quita ambicion; te da mas aire para sostenerla.",
        "No todo dia trae grandes victorias, pero muchos dias pequenos bien llevados construyen algo serio.",
        "Tu proceso merece menos castigo automatico y mas lectura honesta de lo que si estas haciendo.",
        "Cuando eliges no soltarte del todo, incluso cansada, estas defendiendo algo importante de ti.",
        "Tu valor no depende de un dia perfecto; depende mucho mas de volver, ordenar y seguir."
    ]

    static var totalCount: Int {
        titles.count * endings.count
    }
}
