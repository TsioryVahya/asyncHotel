/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package client;
import bean.CGenUtil;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;

import mg.cnaps.compta.ComptaCompte;
import pertegain.Tiers;
/**
 *
 * @author SAFIDY
 */
public class Client extends Tiers{

    private String cin;
    private Date datecin;
    private String cinpath;
    private String permis;
    private Date datepermis;
    private String permispath;
    private String photoproflepath;
    private String passeport;

    public String getPasseport() {
        return passeport;
    }

    public void setPasseport(String passeport) {
        this.passeport = passeport;
    }

    public String getCin() {
        return cin;
    }

    public void setCin(String cin) {
        this.cin = cin;
    }

    public Date getDatecin() {
        return datecin;
    }

    public void setDatecin(Date datecin) {
        this.datecin = datecin;
    }

    public String getCinpath() {
        return cinpath;
    }

    public void setCinpath(String cinpath) {
        this.cinpath = cinpath;
    }

    public String getPermis() {
        return permis;
    }

    public void setPermis(String permis) {
        this.permis = permis;
    }

    public Date getDatepermis() {
        return datepermis;
    }

    public void setDatepermis(Date datepermis) {
        this.datepermis = datepermis;
    }

    public String getPermispath() {
        return permispath;
    }

    public void setPermispath(String permispath) {
        this.permispath = permispath;
    }

    public String getPhotoproflepath() {
        return photoproflepath;
    }

    public void setPhotoproflepath(String photoproflepath) {
        this.photoproflepath = photoproflepath;
    }

    private String telephone;

    private String remarque;

    public Client(){
         this.setNomTable("CLIENT");
    }
    

   

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

   

   

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

   
    
    
    
    
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CLI", "getSeqClient");
        this.setId(makePK(c));
    }
    
    
    @Override
    public String getValColLibelle() {
        return this.getNom();
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","nom","telephone"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"nom","telephone"};
        return motCles;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        String compteVente = this.getCompte();
        ComptaCompte cc = new ComptaCompte();
        cc.setCompte(compteVente);

        ComptaCompte[] listeCompte = (ComptaCompte[]) CGenUtil.rechercher(cc, null, null, c, "");

        Client client = new Client();
        client.setCompte(compteVente);

        Client[] listeClient = (Client[]) CGenUtil.rechercher(client, null, null, c, "");

        if(listeClient!=null && listeClient.length>0){
           // throw new Exception("Le compte "+compteVente+" est d&eacute;j&agrave; utilis&eacute; par le client "+listeClient[0].getNom()+" ("+listeClient[0].getId()+")");
        }
        System.out.println("Compta compte length "+listeCompte.length);
        if(listeCompte.length<1){
            System.out.println("Creation du compte client "+compteVente+" pour le client "+this.getNom());
            ComptaCompte cc2 = new ComptaCompte();
            cc2.setCompte(compteVente);
            cc2.setLibelle("Compte client "+this.getNom());
            cc2.setTypeCompte("1");
            cc2.setClassy("4");
            cc2.setIdjournal("COMP000044");

            cc2.createObject(u, c);
            this.setCompte(cc2.getCompte());
        }

        return super.createObject(u, c);
    }

}
