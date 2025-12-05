package produits;

public class IngredientsLib extends Ingredients
{
    String idcategorieingredient;
    String idcategorie;
    String compte;
    String idVoitureLib, immatriculation;

    public String getIdcategorieingredient() {
        return idcategorieingredient;
    }

    public void setIdcategorieingredient(String idcategorieingredient) {
        this.idcategorieingredient = idcategorieingredient;
    }

    public String getIdcategorie() {
        return idcategorie;
    }

    public void setIdcategorie(String idcategorie) {
        this.idcategorie = idcategorie;
    }

    public IngredientsLib() {
        setNomTable("AS_INGREDIENTS_LIB");
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","libelle","unite", "pu","idVoitureLib","immatriculation"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"libelle","unite", "pu","idVoitureLib","immatriculation"};
        return motCles;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public String getIdVoitureLib() {
        return idVoitureLib;
    }

    public void setIdVoitureLib(String idVoitureLib) {
        this.idVoitureLib = idVoitureLib;
    }

    public String getImmatriculation() {
        return immatriculation;
    }

    public void setImmatriculation(String immatriculation) {
        this.immatriculation = immatriculation;
    }
}
