package location;

import java.sql.Connection;
import java.sql.Date;
import bean.*;
import faturefournisseur.FactureFournisseur;
import faturefournisseur.FactureFournisseurDetails;
import produits.Ingredients;
import utilitaire.Utilitaire;
import utils.ConstanteAsync;
import vente.Vente;

public class ChargeVoiture extends ClassEtat{

    String id,idvoiture,designation,idfournisseur,idproduit;
    double quantite,pu,kilometrage,tva;
    Date daty;

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public Date getDaty() {
        return daty;
    }
    public void setDaty(Date daty) {
        this.daty = daty;
    }
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public String getIdvoiture() {
        return idvoiture;
    }
    public void setIdvoiture(String idvoiture) {
        this.idvoiture = idvoiture;
    }
    public String getDesignation() {
        return designation;
    }
    public void setDesignation(String designation) {
        this.designation = designation;
    }
    public String getIdfournisseur() {
        return idfournisseur;
    }
    public void setIdfournisseur(String idfournisseur) {
        this.idfournisseur = idfournisseur;
    }
    public String getIdproduit() {
        return idproduit;
    }
    public void setIdproduit(String idproduit) {
        this.idproduit = idproduit;
    }
    public double getQuantite() {
        return quantite;
    }
    public void setQuantite(double quantite) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0 & quantite<=0) throw new Exception("quantite non valide"); 
        this.quantite = quantite;
    }
    public double getPu() {
        return pu;
    }
     public void setPu(double pu) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0 & pu<=0) throw new Exception("PU non valide"); 
        this.pu = pu;
    }
    public double getKilometrage() {
        return kilometrage;
    }
    public void setKilometrage(double kilometrage) {
        this.kilometrage = kilometrage;
    }
    public ChargeVoiture()
    {
        setNomTable("chargevoiture");
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
        this.preparePk("CHRG", "GETSEQ_chargevoiture");
        this.setId(makePK(c));
    }


    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {

        FactureFournisseur facture = new FactureFournisseur();
        facture.setIdFournisseur(this.getIdfournisseur());
        facture.setTaux(1);
        facture.setIdMagasin(ConstanteAsync.MagasinDefaut);
        facture.setDaty(Utilitaire.dateDuJourSql());
        facture.setReference(this.getIdvoiture());
        facture.setDateEcheancePaiement(Utilitaire.dateDuJourSql());
        facture.setDesignation("Facture Charge Voiture "+this.getIdvoiture()+" et kilometrage "+this.getKilometrage());

        FactureFournisseurDetails factureFournisseurDetails[] = new FactureFournisseurDetails[1];
        factureFournisseurDetails[0] = new FactureFournisseurDetails();
        factureFournisseurDetails[0].setIdProduit(this.getIdproduit());
        factureFournisseurDetails[0].setQte(this.getQuantite());
        factureFournisseurDetails[0].setPu(this.getPu());
        factureFournisseurDetails[0].setTva(20);
        factureFournisseurDetails[0].setCompte(ConstanteAsync.CompteChargeVoiture);
        factureFournisseurDetails[0].setTva(this.getTva());
        factureFournisseurDetails[0].setKilometrage(this.getKilometrage());
        factureFournisseurDetails[0].setIdvoiture(this.getIdvoiture());
        facture.setFille(factureFournisseurDetails);

        return facture.createObject(u,c);
    }
}
