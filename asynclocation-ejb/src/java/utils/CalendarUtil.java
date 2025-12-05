package utils;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;

public class CalendarUtil {

    public static String[] getDebutEtFinDeSemaine(String dateStr) {
        String[] debutEtFinDeSemaine = new String[4];
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // Conversion de la chaîne vers LocalDate
        LocalDate date = LocalDate.parse(dateStr, formatter);

        // Début et fin de la semaine courante
        LocalDate debutSemaine = date.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate finSemaine = date.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));

        // Dernier jour de la semaine précédente (dimanche avant lundi courant)
        LocalDate dernierJourSemainePrecedente = debutSemaine.minusDays(1);

        // Premier jour de la semaine suivante (lundi après dimanche courant)
        LocalDate premierJourSemaineSuivante = finSemaine.plusDays(1);

        // Remplissage du tableau
        debutEtFinDeSemaine[0] = debutSemaine.format(formatter);
        debutEtFinDeSemaine[1] = finSemaine.format(formatter);
        debutEtFinDeSemaine[2] = dernierJourSemainePrecedente.format(formatter);
        debutEtFinDeSemaine[3] = premierJourSemaineSuivante.format(formatter);

        return debutEtFinDeSemaine;
    }

    public static String[] getDebutEtFinDuMois(String dateStr) {
        String[] debutEtFinDeSemaine = new String[4];
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // Conversion de la chaîne vers LocalDate
        LocalDate date = LocalDate.parse(dateStr, formatter);

        // Début et fin de la semaine courante
        LocalDate debutSemaine = date.with(TemporalAdjusters.firstDayOfMonth());
        LocalDate finSemaine = date.with(TemporalAdjusters.lastDayOfMonth());

        // Dernier jour de la semaine précédente (dimanche avant lundi courant)
        LocalDate dernierJourSemainePrecedente = debutSemaine.minusDays(1);

        // Premier jour de la semaine suivante (lundi après dimanche courant)
        LocalDate premierJourSemaineSuivante = finSemaine.plusDays(1);

        // Remplissage du tableau
        debutEtFinDeSemaine[0] = debutSemaine.format(formatter);
        debutEtFinDeSemaine[1] = finSemaine.format(formatter);
        debutEtFinDeSemaine[2] = dernierJourSemainePrecedente.format(formatter);
        debutEtFinDeSemaine[3] = premierJourSemaineSuivante.format(formatter);

        return debutEtFinDeSemaine;
    }
}
