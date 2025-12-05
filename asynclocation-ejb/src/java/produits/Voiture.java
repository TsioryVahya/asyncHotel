package produits;

import bean.ClassMAPTable;

import java.sql.Connection;

public class Voiture extends ClassMAPTable {
    private String id,nom,couleur,numero,gps,energie,categorie,categorieLibelle;

    private double charge_per_kilometre,consommation,montantResa,charge,marge;

    int nbPlace,estEnPanne,etatGenerale, priorite;

    public int getPriorite() {
        return priorite;
    }

    public void setPriorite(int priorite) {
        this.priorite = priorite;
    }

    public double getMontantResa() {
        return montantResa;
    }

    public void setMontantResa(double montantResa) {
        this.montantResa = montantResa;
    }

    public double getCharge() {
        return charge;
    }

    public void setCharge(double charge) {
        this.charge = charge;
    }

    public double getMarge() {
        return marge;
    }

    public void setMarge(double marge) {
        this.marge = marge;
    }

    public String getCategorie() {
        return categorie;
    }
    public String getEstFonctionnel()
    {
        if(this.getEstEnPanne()>0)return "en panne";
        return "fonctionnel";
    }
    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public String getCategorieLibelle() {
        return categorieLibelle;
    }

    public void setCategorieLibelle(String categorieLibelle) {
        this.categorieLibelle = categorieLibelle;
    }

    public int getNbPlace() {
        return nbPlace;
    }

    public void setNbPlace(int nbPlace) {
        this.nbPlace = nbPlace;
    }

    public int getEstEnPanne() {
        return estEnPanne;
    }

    public void setEstEnPanne(int estEnPanne) {
        this.estEnPanne = estEnPanne;
    }

    public int getEtatGenerale() {
        return etatGenerale;
    }

    public void setEtatGenerale(int etatGenerale) {
        this.etatGenerale = etatGenerale;
    }

    public double getCharge_per_kilometre() {
        return charge_per_kilometre;
    }

    public void setCharge_per_kilometre(double charge_per_kilometre) {
        this.charge_per_kilometre = charge_per_kilometre;
    }

    public String getEnergie() {
        return energie;
    }

    public void setEnergie(String energie) {
        this.energie = energie;
    }

    public double getConsommation() {
        return consommation;
    }

    public void setConsommation(double consommation) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0 &&(consommation<=0||consommation>=100))throw new Exception("Consommation invalide");
        this.consommation = consommation;
    }

    public double getValeur_actuelle() {
        return valeur_actuelle;
    }

    public void setValeur_actuelle(double valeur_actuelle) {
        this.valeur_actuelle = valeur_actuelle;
    }

    public double getKilometrage_actuel() {
        return kilometrage_actuel;
    }

    public void setKilometrage_actuel(double kilometrage_actuel) {
        this.kilometrage_actuel = kilometrage_actuel;
    }

    private double valeur_actuelle;
    private double kilometrage_actuel;


    public Voiture() {
        setNomTable("VOITURE");
    }

    public String getCouleur() {
        return couleur;
    }

    public void setCouleur(String couleur) {
        this.couleur = couleur;
    }

    public String getGps() {
        return gps;
    }

    public void setGps(String gps) {
        this.gps = gps;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
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
        this.preparePk("VTR", "get_seq_Voiture");
        this.setId(makePK(c));
    }
    public String[] getMotCles() {
        return new String[]{"id","nom"};
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }
}
