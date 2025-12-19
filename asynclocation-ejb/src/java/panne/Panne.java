package panne;

import bean.ClassMere;
import java.sql.Connection;
import java.sql.Date;

public class Panne extends ClassMere {
    String id;
    String idVoiture;
    Date datepanne;
    String motif;

    public Panne() throws Exception {
        setNomTable("panne");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdVoiture() {
        return idVoiture;
    }

    public void setIdVoiture(String idVoiture) {
        this.idVoiture = idVoiture;
    }

    public Date getDatepanne() {
        return datepanne;
    }

    public void setDatepanne(Date datepanne) {
        this.datepanne = datepanne;
    }

    public String getMotif() {
        return motif;
    }

    public void setMotif(String motif) {
        this.motif = motif;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        // Ajoutez des règles si nécessaire
    }

    @Override
    public void controlerDelete(Connection c) throws Exception {
        super.controlerDelete(c);
    }
}
