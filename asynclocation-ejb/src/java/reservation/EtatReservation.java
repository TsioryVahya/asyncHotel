package reservation;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import org.apache.poi.ss.excelant.ExcelAntPrecision;
import produits.Voiture;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;
import produits.Ingredients;
import utils.ConstanteAsync;

public class EtatReservation {
     String[] listeDate;
    String[] listeDateDayOfMonth;
    HashMap<String, Vector> listeReservation;
    Voiture[] listeVtr;
    HashMap<String, Double> listeMontant;
    String[] listeVoiture;
    String[] listeIdVoiture;
    String[] numeroVoiture;

    public HashMap<String, Double> getListeMontant() {
        return listeMontant;
    }

    public String[] getListeIdVoiture() {
        return listeIdVoiture;
    }

    public void setListeIdVoiture(String[] listeIdVoiture) {
        this.listeIdVoiture = listeIdVoiture;
    }

    public String[] getListeVoiture() {
        return listeVoiture;
    }

    public void setListeVoiture(String[] listeVoiture) {
        this.listeVoiture = listeVoiture;
    }

    public Voiture[] getListeVtr() {
        return listeVtr;
    }

    public void setListeVtr(Voiture[] listeVtr) {
        this.listeVtr = listeVtr;
    }

    public String[] getListeDate() {
        return listeDate;
    }

    public String[] getNumeroVoiture() {
        return numeroVoiture;
    }

    public void setNumeroVoiture(String[] numeroVoiture) {
        this.numeroVoiture = numeroVoiture;
    }

    public HashMap<String, Vector> getListeReservation() {
        return listeReservation;
    }
    public EtatReservation(String nTChambre,String nTResa,String dtMin, String dMax) throws Exception {
        Connection c=null;
        this.setListeDate(dtMin, dMax);
        try {
            c = new UtilDB().GetConn();
            setListeVoiture(nTChambre, c);
            this.setListeReservation(nTResa,c,dtMin,dMax);
            this.setListeMontant();
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(c!=null)c.close();
        }
    }
    public void setListeDate(String dtMin, String dMax) throws Exception {
        //if(Utilitaire.compareDaty(dMax,dtMin)<0) throw new Exception("Date sup inferieur a date Inf");
        if(Utilitaire.diffJourDaty(dMax,dtMin)<0)throw new Exception("Date sup inferieur a date Inf");
        int day = Utilitaire.diffJourDaty(dMax, dtMin);
        String liste[]=new String[day];
        String listedayofmonth[]=new String[day];
        for (int i = 0; i < day; i++) {
            liste[i]=Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(dtMin,i))  ;

            //Date oldDate = Utilitaire.ajoutJourDate(dtMin, i);
            //LocalDate localDate = oldDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
            //listedayofmonth[i] = String.valueOf(localDate.getDayOfMonth());
            listedayofmonth[i] = String.valueOf(Utilitaire.ajoutJourDate(dtMin,i).getDate());
        }
        this.listeDateDayOfMonth=listedayofmonth;
        this.listeDate = liste;
    }

    public String[] getListeDateDayOfMonth() {
        return listeDateDayOfMonth;
    }

    public void setListeDateDayOfMonth(String[] listeDateDayOfMonth) {
        this.listeDateDayOfMonth = listeDateDayOfMonth;
    }

    public void setListeDate(String[] listeDate) {
        this.listeDate = listeDate;
    }

    public void setListeReservation(HashMap<String, Vector> listeReservation) {
        this.listeReservation = listeReservation;
    }

    public void setListeMontant(HashMap<String, Double> listeMontant) {
        this.listeMontant = listeMontant;
    }

    public void setListeReservation(String nTResa, Connection c, String dMin, String dMax) throws Exception {
        reservation.ReservationDetailsLib res=new reservation.ReservationDetailsLib();
        if(nTResa!=null)res.setNomTable(nTResa);
        if(dMin==null||dMin.compareToIgnoreCase("")==0)dMin=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
        String[] colInt={"daty"};
        String[] valInt={dMin,dMax};
        HashMap<String,Vector> valiny=CGenUtil.rechercher2D(res,colInt,valInt,"daty",c,"");
        listeReservation=valiny;
    }
    public void setListeMontant() throws Exception {
        HashMap<String, Double> montant=new HashMap<>();
        for (Map.Entry<String, Vector> entry : listeReservation.entrySet()) {
            String key = entry.getKey();
            Vector v = entry.getValue();
            reservation.ReservationDetailsLib[] listeR=new reservation.ReservationDetailsLib[v.size()];
            v.copyInto(listeR);
            montant.put(key,new Double(AdminGen.calculSommeDouble(listeR,"montantCalcule")));
        }
        listeMontant=montant;
    }
    public double getSommeBydate(String daty) throws Exception {
        Double l=listeMontant.get(daty);
        if(l==null)return 0;
        return listeMontant.get(daty).doubleValue();
    }
    public String[] getValeur(String daty,String chambre) throws Exception
    {
        Vector v=listeReservation.get(daty);
        if(v==null)return null;
        String[] attrEt={"libelleproduit"};
        String[] valEt={chambre};
        reservation.ReservationDetailsLib[] r= (reservation.ReservationDetailsLib[]) AdminGen.find(v,attrEt,valEt);
        if(r==null)return null;
        String[] ret=new String[r.length];
        for(int i=0;i<r.length;i++)
            ret[i]= Utilitaire.remplacerNull(r[i].getLibelleClient());
        return ret;
    }


    public String[] getValeurById(String daty,String idChambre) throws Exception
    {
        String[] retour={""};
        Vector v=listeReservation.get(daty);
        if(v==null)return retour;
        String[] attrEt={"idproduit"};
        String[] valEt={idChambre};
        reservation.ReservationDetailsLib[] r= (reservation.ReservationDetailsLib[]) AdminGen.find(v,attrEt,valEt);
        if(r==null)return retour;
        String[] ret=new String[r.length];
        for(int i=0;i<r.length;i++)
            ret[i]= Utilitaire.remplacerNull(r[i].getLibelleClient());
        return ret;
    }
    public  reservation.ReservationDetailsLib[] getResaById(String daty,String idChambre) throws Exception
    {
        Vector v=listeReservation.get(daty);
        if(v==null)return null;
        String[] attrEt={"idproduit"};
        String[] valEt={idChambre};
        reservation.ReservationDetailsLib[] r= (reservation.ReservationDetailsLib[]) AdminGen.find(v,attrEt,valEt);
        return r;
    }

    public  reservation.ReservationDetailsLib[] getResaById(String daty,String idVoiture,String tranche) throws Exception
    {
        Vector v=listeReservation.get(daty);
        if(v==null)return null;
        String[] attrEt={"idVoiture","tranche"};
        String[] valEt={idVoiture,tranche};
        reservation.ReservationDetailsLib[] r= (reservation.ReservationDetailsLib[]) AdminGen.find(v,attrEt,valEt);
        return r;
    }

    public void setListeVoiture(String nT,Connection c) throws Exception {
        Voiture crt=new Voiture();
        if(nT!=null)crt.setNomTable(nT);
        Voiture[] liste=(Voiture[]) CGenUtil.rechercher(crt,null,null,c," order by priorite asc");
        String[] ret=new String[liste.length];
        String[] retId=new String[liste.length];
        String[] numero = new String[liste.length];
        this.listeVtr=liste;
        for(int i=0;i<liste.length;i++){
            ret[i]=liste[i].getNom();
            retId[i]=liste[i].getId();
            numero[i]=liste[i].getNumero();
        }
        listeVoiture=ret;
        listeIdVoiture=retId;
        numeroVoiture=numero;
    }
}
