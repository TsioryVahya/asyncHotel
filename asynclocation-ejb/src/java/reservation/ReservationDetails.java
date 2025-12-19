package reservation;

import annexe.Unite;
import bean.CGenUtil;
import bean.ClassFille;
import produits.Ingredients;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ReservationDetails extends ClassFille
{
    String id;
    String idmere;
    String idproduit;
    String remarque;
    String heure; 
    double qte, pu, distanceestimation;
    Date daty;
    String tranche;
    int nbDemiJournee;
    String idVoiture;
    String idResadetails;
    String acteur;

    public double getMontantCalcule()
    {
        return this.getQte()*this.getPu();
    }

    public String getActeur() {
        return acteur;
    }
    
    public void setActeur(String acteur) {
        this.acteur = acteur;
    }

    public  String getNomClasseMere() {
        return "reservation.Reservation";
    }
    public String getLiaisonMere() {
        return "idmere";
    }

    public String getId() {
        return id;
    }
    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    public String getIdproduit() {
        return idproduit;
    }

    public void setIdproduit(String idproduits) {
        this.idproduit = idproduits;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception {
        if(this.getMode().equals("modif")){
            if(qte <= 0){
                throw new Exception("Quantité insuffisante pour une ligne");
            }
        }
        this.qte = qte;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getPu() {
        return pu;
    }

    public String getIdVoiture() {
        return idVoiture;
    }

    public void setIdVoiture(String idVoiture) {
        this.idVoiture = idVoiture;
    }

    public void setPu(double pu) throws Exception {
        if(this.getMode().equals("modif")){
            if(pu <= 0){
                throw new Exception("Prix unitaire invalide pour une ligne");
            }

        }
        this.pu = pu;
    }

    public double getDistanceestimation() {
        return distanceestimation;
    }

    public void setDistanceestimation(double distanceestimation) {
        this.distanceestimation = distanceestimation;
    }

    public int getNbDemiJournee() throws Exception {
        if (qte <= 0) {
            throw new IllegalStateException(
                    "Impossible de calculer nbDemiJournee à partir d'une qte non positive : " + qte);
        }
        Ingredients ingredients = (Ingredients) new Ingredients().getById(this.getIdproduit(),null,null);
        Unite unite = (Unite) new Unite().getById(ingredients.getUnite(),"AS_UNITE",null);
        double nbDem = unite.getEquivalence() * this.getQte();
        // 1 jour = 2 demi-journées
//        this.nbDemiJournee = (int) Math.round(this.qte * 2);
        this.setNbDemiJournee((int)Math.round(nbDem));
        return nbDemiJournee;
    }

    public String getIdResadetails() {
        return idResadetails;
    }

    public void setIdResadetails(String idResadetails) {
        this.idResadetails = idResadetails;
    }

    public void setNbDemiJournee(int nbDemiJournee) {
        this.nbDemiJournee = nbDemiJournee;
    }

    public String getTranche() {
        return tranche;
    }

    public void setTranche(String tranche) {
        this.tranche = tranche;
    }

    public ReservationDetails() throws Exception {
        setNomTable("reservationdetails");
        setLiaisonMere("idmere");
        setNomClasseMere("reservation.Reservation");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("RESADET", "GETSEQRESERVATIONDETAILS");
        this.setId(makePK(c));
    }


    private String resolveVoitureId(Connection c) throws Exception {
        if (this.getIdVoiture() != null && !this.getIdVoiture().trim().isEmpty()) {
            return this.getIdVoiture();
        }
        if (this.getIdproduit() == null || this.getIdproduit().trim().isEmpty()) {
            return null;
        }
        boolean openedHere = false;
        try {
            if (c == null) { c = new utilitaire.UtilDB().GetConn(); openedHere = true; }
            String sql = "SELECT idvoiture FROM AS_INGREDIENTS_LIB WHERE id = ?";
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, this.getIdproduit());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getString(1);
                }
            }
            return null;
        } finally {
            if (openedHere && c != null) try { c.close(); } catch (Exception ignore) {}
        }
    }
    private void assertNoOpenPanne(Connection c) throws Exception {
        // Si pas de date ou pas de voiture à vérifier, on ne bloque pas
        if (this.getDaty() == null) return;
        String voitureId = resolveVoitureId(c);
        if (voitureId == null || voitureId.trim().isEmpty()) return;
    
        boolean openedHere = false;
        try {
            if (c == null) { c = new utilitaire.UtilDB().GetConn(); openedHere = true; }
    
            // Panne ouverte si: existe p dans PANNE pour la voiture avec p.DATEPANNE <= daty
            // et il n'existe pas de FINPANNE avec datefin < daty
            String sql =
                "SELECT 1 " +
                "FROM PANNE p " +
                "WHERE p.IDVOITURE = ? " +
                "  AND p.DATEPANNE <= ? " +
                "  AND NOT EXISTS ( " +
                "        SELECT 1 FROM FINPANNE f " +
                "        WHERE f.IDPANNE = p.ID " +
                "          AND f.DATEFIN < ? " +
                "  ) " +
                "  AND ROWNUM = 1";
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, voitureId);
                ps.setDate(2, this.getDaty());
                ps.setDate(3, this.getDaty());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        throw new Exception("Voiture indisponible: panne ouverte pour " + voitureId +
                            " à la date " + this.getDaty() + ".");
                    }
                }
            }
        } finally {
            if (openedHere && c != null) try { c.close(); } catch (Exception ignore) {}
        }
    }

    public List<ReservationDetails> decomposer() throws Exception {
        List<ReservationDetails> res = new ArrayList<ReservationDetails>();
        for(int i=1;i<=this.getQte();i++) {
            ReservationDetails r = (ReservationDetails) this.dupliquerSansBase();
            r.setQte(1);
            r.setDaty(Utilitaire.ajoutJourDate(this.getDaty(),i-1));
            res.add(r);
        }
        return res;
    }
    public ReservationDetails[] decomposerEnTableau() throws Exception {
        List<ReservationDetails> res=decomposer();
        return res.toArray (new ReservationDetails[res.size()]);
    }

    public ReservationDetails[] genererAutres() throws Exception{
        int n = this.getNbDemiJournee();

        ReservationDetails[] result = new ReservationDetails[n];
        String[] tranches = { "AM", "PM" };
        Date dateDebut = this.getDaty();
        int jourCourant = 0;
        if(n <= 1){
            int isAfterNoon = Utilitaire.diffDeuxheures(this.heure,"12:00");
            ReservationDetails copie = new ReservationDetails();
            copie = (ReservationDetails) this.dupliquerSansBase();
            copie.setDaty(dateDebut);
            copie.tranche = (this.heure != null && isAfterNoon < 0) ? "PM" : "AM";
            copie.setIdResadetails(this.getId());
            copie.setId(null);
            result[0] = copie;
            return result;
        } else {
            for (int i = 0; i < n; i++) {
                ReservationDetails copie = new ReservationDetails();
                copie = (ReservationDetails) this.dupliquerSansBase();
                copie.setIdResadetails(this.getId());
                copie.setId(null);
                copie.tranche = tranches[i % 2]; // alterne AM / PM
                if (i % 2 == 0 && i > 0) {
                    jourCourant++;
                }
                copie.daty = Utilitaire.ajoutJourDate(dateDebut, jourCourant);
                result[i] = copie;
            }
        }
        return result;
    }

    public boolean isDisponible(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            ReservationDetails res = new ReservationDetails();
            res.setNomTable("reservationPlaninngVise");
            res.setIdVoiture(this.getIdVoiture());
            //System.out.println("TRANCHE ======= "+this.getTranche());
            res.setTranche(this.tranche);
            String[] colInt = {"daty"};
            String[] valInt = {Utilitaire.datetostring(this.daty),Utilitaire.datetostring(this.daty)};
            ReservationDetails[] reservationDetails = (ReservationDetails[]) CGenUtil.rechercher(res,colInt,valInt,c,"");
            if(reservationDetails.length > 0){
                return false;
            }else {
                return true;
            }
        }catch (Exception e){
            e.printStackTrace();
            throw e;
        }finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }


    @Override
    public String toString() {
        return "ReservationDetails{" +
                "daty=" + daty +
                ", id='" + id + '\'' +
                ", idmere='" + idmere + '\'' +
                ", idproduit='" + idproduit + '\'' +
                ", remarque='" + remarque + '\'' +
                ", heure='" + heure + '\'' +
                ", qte=" + qte +
                ", pu=" + pu +
                ", tranche='" + tranche + '\'' +
                ", nbDemiJournee=" + nbDemiJournee +
                '}';
    }
    @Override
    public void controlerInsert(Connection c) throws Exception {
        if (this.getIdmere() == null || this.getIdmere().trim().compareTo("") == 0) {
            throw new Exception("Id mere obligatoire pour une fille");
        }
        // Bloquer si panne ouverte
        assertNoOpenPanne(c);
    }

    @Override
    public void controlerDelete(Connection c) throws Exception {
        if(this.getNomTable().equals("RESERVATIONPLANNING")){
            return;
        }
        super.controlerDelete(c);
    }
    @Override
    public void controlerUpdate(Connection c) throws Exception {
        // super.controlerUpdate(c); // Eviter NPE dans ClassFille
        if (this.getIdmere() == null || this.getIdmere().trim().compareTo("") == 0) {
            throw new Exception("Id mere obligatoire pour une fille");
        }
        assertNoOpenPanne(c);
        
        // Règle métier: sur toute baisse de PU, appliquer la politique selon l'acteur
        try {
            // Charger l'état actuel en base pour comparaison
            // On utilise explicitement "reservationdetails" pour éviter les soucis de casse
            ReservationDetails courant = (ReservationDetails) new ReservationDetails().getById(this.getId(), "reservationdetails", c);
            if (courant != null) {
                double oldPu = courant.getPu();
                double newPu = this.getPu();

                // Acteur envoyé par le formulaire (bouton Loueur/Locataire)
                String acteur = null;
                try { acteur = this.getActeur(); } catch (Exception ignore) {}

                if (acteur != null && acteur.equalsIgnoreCase("LOUEUR")) {
                    // Cas LOUEUR:
                    if (newPu < oldPu) {
                        // Remise 10% sur le nouveau prix soumis (ex: 100000 -> 90000)
                        double puRemise = Math.round(newPu * 0.9);
                        this.setPu(puRemise);
                    } else if (newPu > oldPu) {
                        // Interdire la hausse pour Loueur -> garder l'ancien PU
                        this.setPu(oldPu);
                    }
                    // Si égal, on ne change rien
                } else {
                    // Cas NON-LOUEUR (Locataire, etc.)
                    if (newPu < oldPu) {
                        // Interdire la baisse -> garder l'ancien PU
                        this.setPu(oldPu);
                    }
                    // Si >= ancien, on laisse tel quel (hausse autorisée)
                }
            }
        } catch (Exception ex) {
            // Ne pas bloquer l'update si la comparaison échoue; laisser les autres contrôles s'appliquer
            // (Optionnel: log)
        }
    }
}