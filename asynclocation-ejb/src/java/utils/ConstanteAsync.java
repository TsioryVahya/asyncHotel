package utils;

import annexe.ProduitLib;
import chatbot.ClassIA;
import fabrication.FabricationFilleCpl2;
import faturefournisseur.FactureFournisseurDetailsCpl;
import prevision.PrevisionComplet;
import produits.DisponibiliteChambre;
import reservation.ReservationDetailsLib;
import reservation.ReservationSimple;
import utilitaire.Utilitaire;
import vente.VenteDetailsLib;

public class ConstanteAsync {
    public static Class<? extends ClassIA>[] iaClasses = new Class[]{VenteDetailsLib.class, FactureFournisseurDetailsCpl.class, FabricationFilleCpl2.class, PrevisionComplet.class, ProduitLib.class, ReservationSimple.class, ReservationDetailsLib.class, DisponibiliteChambre.class};
    public static final String API_KEY = "AIzaSyBp79rk0qe1FEPYeKPx6TuORYABQrV2c4I";
    public static final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=" + API_KEY;
    public static final String heureCheckout="12:00:00";
    public static final double propAvance=0.33;
    public static final String categService="CAT002";
    public static final String categorieChambre="CAT001";
    public static final String CATEGORIE_VOITURE="CAT003";
    public static final String MagasinDefaut="PNT000122";
    public static final String CompteChargeVoiture ="60000";
    public static final String[] heureFanaterana={"07:00","12:00","17:00"};

    public static String getHeureTranche(String tranche){
        if(tranche.equalsIgnoreCase("AM")){
            return heureFanaterana[0];
        }
        return heureFanaterana[1];
    }
    
    public static String getAMPM(String heure)
    {
        int ecart= Utilitaire.diffDeuxheures(heureFanaterana[1],heure);
        //int avant8h=Utilitaire.diffDeuxheures(heure,heureFanaterana[0]);
        if(ecart>0) return "PM";
        return "AM";
    }
    public static int calculerNombreDemiJournee(java.sql.Date dInitial, String heureInitiale,java.sql.Date dFinal,String heureFinale )
    {
        if(heureFinale==null||heureFinale.equals(""))heureFinale=Utilitaire.heureCouranteHM();
        int diffJour=Utilitaire.diffJourDaty(dFinal,dInitial);
        if(diffJour==0)diffJour=1;
        int diffJourDemi=diffJour*2;
        String initAMPM=getAMPM(heureInitiale);
        String finalAMPM=getAMPM(heureFinale);
        if (initAMPM.compareToIgnoreCase("PM") == 0) diffJourDemi = diffJourDemi - 1;
        if (finalAMPM.compareToIgnoreCase("AM") == 0) diffJourDemi = diffJourDemi - 1;
        if(Utilitaire.diffDeuxheures(heureFinale,ConstanteAsync.heureFanaterana[0])>=0) diffJourDemi = diffJourDemi - 1;
        return diffJourDemi;
    }
}
