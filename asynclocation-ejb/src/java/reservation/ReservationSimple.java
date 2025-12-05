package reservation;

import bean.ClassMAPTable;
import chatbot.ClassIA;

import java.sql.Connection;

public class ReservationSimple extends Reservation implements ClassIA
{
    String idProduit;
    double qte;


    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }

    private String heure ;


    @Override
    public String getNomTableIA() {
        return "RESERVATIONSIMPLE";
    }
    @Override
    public String getUrlSaisie() {
        return "/pages/module.jsp?but=reservation/reservation-simple-saisie.jsp&currentMenu=ELM001104005";
    }
    @Override
    public ClassIA getClassSaisie() {
        return this;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }

    public ReservationSimple() throws Exception {
        super();
        setNomTable("RESERVATIONSIMPLE");
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception
    {
        Reservation rs = this.genererReservation(c);
        return rs.createObject(u, c);
    }

    public Reservation genererReservation(Connection c) throws Exception {
        Reservation res = new Reservation();
        produits.Ingredients i = (produits.Ingredients)new produits.Ingredients().getById(this.getIdProduit(),null,c) ;
        if(i==null)throw new Exception("Voiture non existante");
        ReservationDetails[] resDetails = new ReservationDetails[1];
        try
        {
            res.setDaty(this.getDaty());
            res.setIdclient(this.getIdclient());
            res.setRemarque(this.getRemarque());
            resDetails[0] = new ReservationDetails();
            resDetails[0].setIdproduit(this.getIdProduit());
            resDetails[0].setQte(this.getQte());
            resDetails[0].setDaty(this.getDaty());
            resDetails[0].setPu(i.getPu());
            res.setFille(resDetails);
        }
        catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Generer reservation failed");
        }
        return res;
    }
}
