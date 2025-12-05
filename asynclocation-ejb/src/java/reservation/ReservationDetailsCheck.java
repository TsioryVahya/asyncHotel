package reservation;

public class ReservationDetailsCheck extends ReservationDetails{

    private String idclient;
    private String produitlib;


    public String getProduitlib() {
        return produitlib;
    }

    public void setProduitlib(String produitlib) {
        this.produitlib = produitlib;
    }

    public ReservationDetailsCheck() throws Exception {
       setNomTable("RESERVATIONDETSANSCI");
    }

    public String getIdclient() {
        return idclient;
    }

    public void setIdclient(String idclient) {
        this.idclient = idclient;
    }

}
