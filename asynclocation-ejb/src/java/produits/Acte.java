package produits;

import bean.ClassEtat;
import reservation.ReservationDetails;
import reservation.Reservation;
import reservation.Check;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import vente.VenteDetails;

public class Acte extends ClassEtat
{
    String id;
    String idproduit;
    String libelle;
    String idclient;
    private String libelleproduit,idclientlib,etatlib, idchambre;
    double kilomerageParcouru,charge;
    private double montant;

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getKilomerageParcouru() {
        return kilomerageParcouru;
    }

    public void setKilomerageParcouru(double kilomerageParcouru) {
        this.kilomerageParcouru = kilomerageParcouru;
    }
    public double getMarge()
    {
        return getMontant()-getCharge();
    }
    public double getCharge() {
        return charge;
    }

    public void setCharge(double charge) {
        this.charge = charge;
    }

    public String getLibelleproduit() {
        return libelleproduit;
    }
    public void setLibelleproduit(String libelleproduit) {
        this.libelleproduit = libelleproduit;
    }
    public String getIdclientlib() {
        return idclientlib;
    }
    public void setIdclientlib(String idclientlib) {
        this.idclientlib = idclientlib;
    }
    public String getEtatlib() {
        return etatlib;
    }
    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getIdchambre() {
        return idchambre;
    }

    public void setIdchambre(String idchambre) {
        this.idchambre = idchambre;
    }

    /**
     * id Chekc In no ato anatiny
     */
    String idreservation,compte_vente;
    Date daty;
    double pu, qte,tva;

    public double getMontantCalc()
    {
        return this.getPu()*this.getQte();
    }
    public String getCompte_vente() {
        return compte_vente;
    }

    public void setCompte_vente(String compte_vente) {
        this.compte_vente = compte_vente;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
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

    public void setPu(double pu) {
        this.pu = pu;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception{
        if(this.getMode().compareToIgnoreCase("modif")==0&&qte<=0) throw new Exception("Quantite non valide");
        this.qte = qte;
    }

    public Acte() {
        setNomTable("acte");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getIdclient() {
        return idclient;
    }

    public void setIdclient(String idclient) {
        this.idclient = idclient;
    }

    public String getIdreservation() {
        return idreservation;
    }

    public void setIdreservation(String idreservation) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0&&idreservation==null||idreservation.compareToIgnoreCase("")==0) throw new Exception("Reservation obligatoire");
        this.idreservation = idreservation;
    }

    public String getIdproduit() {
        return idproduit;
    }

    public void setIdproduit(String idproduit) {
        this.idproduit = idproduit;
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("ACT", "GETSEQACTE");
        this.setId(makePK(c));
    }
    @Override
    public String[] getMotCles() {
        String[] motCles={"id","libelle"};
        return motCles;
    }

    /***
     * Ity miova group by am location voiture
     * @return
     * @throws Exception
     */
    public vente.VenteDetails genererVenteDetails()throws Exception{
        VenteDetails retour=new VenteDetails();
        retour.setIdProduit(getIdproduit());
        retour.setIdOrigine(this.getId());
        retour.setQte(getQte());
        retour.setTva(getTva());
        retour.setPu(this.getPu());
        retour.setIdDevise("AR");
        retour.setTauxDeChange(1);
        retour.setDesignation(this.getLibelle());
        retour.setCompte(getCompte_vente());
        retour.setDatereservation(this.getDaty());
        return retour;
    }

    public void createReservation(String u, Connection c) throws Exception{
        Reservation r= new Reservation();
        r.setIdclient(this.getIdclient());
        r.setDaty(this.getDaty());
        r.setRemarque("Reservation sur place");
        r.createObject(u, c);
        ReservationDetails rd= new ReservationDetails();
        rd.setIdmere(r.getId());
        rd.setDaty(this.getDaty());
        rd.setIdproduit(this.getIdproduit());
        rd.setPu(this.getPu());
        rd.setQte(this.getQte());
        rd.setRemarque(this.getLibelle());
        rd.createObject(u, c);
        r.validerObject(u,c);
        this.setIdreservation(r.getId());
    }
    
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            Object o= super.validerObject(u, c);
            if(estOuvert) {c.commit();}
            return o;
        }
        catch (Exception e) {
            c.rollback();
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null){c.close();}
        }
    }
}
