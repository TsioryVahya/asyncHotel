package location;

public class ChargeVoitureLib extends ChargeVoiture{
  
    double montant;
    String idproduitlib,idvoiturelib,idfournisseurlib;
    String etatlib;

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }
    public String getIdproduitlib() {
        return idproduitlib;
    }

    public void setIdproduitlib(String idproduitlib) {
        this.idproduitlib = idproduitlib;
    }

    public String getIdvoiturelib() {
        return idvoiturelib;
    }

    public void setIdvoiturelib(String idvoiturelib) {
        this.idvoiturelib = idvoiturelib;
    }

    public String getIdfournisseurlib() {
        return idfournisseurlib;
    }

    public void setIdfournisseurlib(String idfournisseurlib) {
        this.idfournisseurlib = idfournisseurlib;
    }


    public ChargeVoitureLib() {
        setNomTable("chargevoiturelib");
    }
}
