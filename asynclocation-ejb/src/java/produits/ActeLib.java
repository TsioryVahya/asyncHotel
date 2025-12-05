package produits;

import java.sql.Connection;

public class ActeLib extends Acte{
    

    String idchambre, chambre;

    public ActeLib()
    {
        this.setNomTable("acte_lib");
    }


    @Override
    public String getIdchambre() {
        return idchambre;
    }

    @Override
    public void setIdchambre(String idchambre) {
        this.idchambre = idchambre;
    }

    public String getChambre() {
        return chambre;
    }

    public void setChambre(String chambre) {
        this.chambre = chambre;
    }
}
