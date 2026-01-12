package panne;

import bean.ClassFille;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;

public class FinPanne extends ClassFille {
    String id;
    String idmere; // id de la panne
    String idpanne; // colonne réelle en base
    Date datefin;
    BigDecimal montant; // montant d'entretien

    public FinPanne() throws Exception {
        setNomTable("finpanne");
        setLiaisonMere("idpanne");
        setNomClasseMere("panne.Panne");
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getIdmere() { return idmere; }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
        // Garder idmere et idpanne synchronisés pour le mapping en base
        this.idpanne = idmere;
    }

    public String getIdpanne() { return idpanne; }

    public void setIdpanne(String idpanne) {
        this.idpanne = idpanne;
        // Si on fixe directement idpanne, refléter aussi dans idmere
        this.idmere = idpanne;
    }

    public BigDecimal getMontant() { return montant; }

    public void setMontant(BigDecimal montant) { this.montant = montant; }

    public Date getDatefin() { return datefin; }
    public void setDatefin(Date datefin) { this.datefin = datefin; }

    @Override
    public void construirePK(Connection c) throws Exception {
        // Laisser la base (trigger/sequence FINPANNE) générer l'identifiant.
        // Ne pas appeler preparePk/makePK ici pour éviter GETSEQEXECUTIONS.
    }

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
