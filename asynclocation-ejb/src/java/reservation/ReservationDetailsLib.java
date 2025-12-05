package reservation;

import chatbot.ClassIA;

public class ReservationDetailsLib extends ReservationDetails implements ClassIA
{
    String libelleproduit;
    String categorieproduit;
    double montant;
    String categorieproduitlib;
    String libelleClient;
    String idVoitureLib;
    double kilometragecheckin, kilometragecheckout, charge_per_kilometre, valeur_actuelle, revient, marge, distancereelle;

    @Override
    public String getNomTableIA() {
        return "RESERVATIONDETAILS_LIB";
    }
    @Override
    public String getUrlListe() {
        return "/pages/module.jsp?but=reservation/reservation-liste.jsp&currentMenu=ELM001104006";
    }
    @Override
    public String getUrlSaisie() {
        return "/pages/module.jsp?but=reservation/reservation-simple-saisie.jsp&currentMenu=ELM001104005";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
    @Override
    public ClassIA getClassSaisie() {
        try {
            return new ReservationSimple();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public double getDistancereelle() {
        return distancereelle;
    }

    public void setDistancereelle(double distancereelle) {
        this.distancereelle = distancereelle;
    }

    public double getKilometragecheckin() {
        return kilometragecheckin;
    }

    public void setKilometragecheckin(double kilometragecheckin) {
        this.kilometragecheckin = kilometragecheckin;
    }

    public double getKilometragecheckout() {
        return kilometragecheckout;
    }

    public void setKilometragecheckout(double kilometragecheckout) {
        this.kilometragecheckout = kilometragecheckout;
    }

    public double getCharge_per_kilometre() {
        return charge_per_kilometre;
    }

    public void setCharge_per_kilometre(double charge_per_kilometre) {
        this.charge_per_kilometre = charge_per_kilometre;
    }

    public double getValeur_actuelle() {
        return valeur_actuelle;
    }

    public void setValeur_actuelle(double valeur_actuelle) {
        this.valeur_actuelle = valeur_actuelle;
    }

    public double getRevient() {
        return revient;
    }

    public void setRevient(double revient) {
        this.revient = revient;
    }

    public double getMarge() {
        return marge;
    }

    public void setMarge(double marge) {
        this.marge = marge;
    }

    public String getLibelleClient() {
        return libelleClient;
    }

    public void setLibelleClient(String libelleClient) {
        this.libelleClient = libelleClient;
    }

    public String getCategorieproduitlib() {
        return categorieproduitlib;
    }

    public void setCategorieproduitlib(String categorieproduitlib) {
        this.categorieproduitlib = categorieproduitlib;
    }

    public String getLibelleproduit() {
        return libelleproduit;
    }

    public void setLibelleproduit(String libelleproduit) {
        this.libelleproduit = libelleproduit;
    }

    public String getCategorieproduit() {
        return categorieproduit;
    }

    public void setCategorieproduit(String categorieproduit) {
        this.categorieproduit = categorieproduit;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getIdVoitureLib() {
        return idVoitureLib;
    }

    public void setIdVoitureLib(String idVoitureLib) {
        this.idVoitureLib = idVoitureLib;
    }

    public String getLibelleStatus() {
        String ret="disponible";
        if(this.getEtat()>=11) ret="occupe";
        if(this.getEtat()<11) ret="en-attente";
        return ret;
    }

    public ReservationDetailsLib() throws Exception {
        super();
        setNomTable("RESERVATIONDETAILS_LIB");
    }
}
