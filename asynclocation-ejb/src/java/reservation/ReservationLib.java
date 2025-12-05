package reservation;

public class ReservationLib extends Reservation
{
    String idclientlib;
    String etatlib;
    double montant, montantTva,montantTTC,paye,resteAPayer, revient, marge;


    String idVoiture;

    public String getIdVoiture() {
        return idVoiture;
    }

    public void setIdVoiture(String idVoiture) {
        this.idVoiture = idVoiture;
    }

    public double getPaye() {
        return paye;
    }

    public void setPaye(double paye) {
        this.paye = paye;
    }

    public double getResteAPayer() {
        return resteAPayer;
    }

    public void setResteAPayer(double resteAPayer) {
        this.resteAPayer = resteAPayer;
    }

    public double getMontantTva() {
        return montantTva;
    }

    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public void setMontantTva(double montantTva) {
        this.montantTva = montantTva;
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

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
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

    public ReservationLib() throws Exception {
        super();
        setNomTable("RESERVATION_LIB");
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","idclientlib","daty","etatlib"};
        return motCles;
    }
}
