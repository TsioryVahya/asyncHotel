package panne;

import bean.ClassFille;
import java.sql.Connection;
import java.sql.Date;

public class FinPanne extends ClassFille {
    String id;
    String idmere; // id de la panne
    Date datefin;

    public FinPanne() throws Exception {
        setNomTable("finpanne");
        setLiaisonMere("idpanne");
        setNomClasseMere("panne.Panne");
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getIdmere() { return idmere; }
    public void setIdmere(String idmere) { this.idmere = idmere; }

    public Date getDatefin() { return datefin; }
    public void setDatefin(Date datefin) { this.datefin = datefin; }

    @Override
    public String getTuppleID() { return id; }

    @Override
    public String getAttributIDName() { return "id"; }

    @Override
    public String getNomClasseMere() { return "panne.Panne"; }

    @Override
    public String getLiaisonMere() { return "idpanne"; }

    @Override
    public void controlerUpdate(Connection c) throws Exception { }
}
