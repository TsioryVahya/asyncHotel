package reservation;

import utilitaire.ConstanteEtat;
import utils.ConstanteAsync;
import produits.Acte;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import bean.CGenUtil;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
public class CheckOut extends Check {
    Check checkIn;
    double distancereelle;
    double kilometragecheckout;
    double quantite;

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) {
        this.quantite = quantite;
    }

    public double getDistancereelle() {
        return distancereelle;
    }

    public void setDistancereelle(double distancereelle) {
        this.distancereelle = distancereelle;
    }

    public double getKilometragecheckout() {
        return kilometragecheckout;
    }

    public void setKilometragecheckout(double kilometragecheckout) {
        this.kilometragecheckout = kilometragecheckout;
    }

    public Check getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(Check checkIn) {
        this.checkIn = checkIn;
    }

    public CheckOut() {
        setNomTable("CHECKOUT");
    }

    public CheckOut(String nT) {
        super(nT);
    }
    @Override
    public void construirePK(Connection c) throws Exception {
         this.preparePk("COT", "get_seqCheckOut");
        this.setId(makePK(c));
    }
    public Check getCheckIn(String nT, Connection c)throws Exception {
        reservation.Check checkIn = new reservation.Check();
        checkIn.setId(this.getReservation());
        if(nT!=null&&nT.compareToIgnoreCase("")!=0)checkIn.setNomTable(nT);
        Check[] retour=(Check[]) CGenUtil.rechercher(checkIn,null,null,c,"");
        if(retour.length==0){return null;}
        return retour[0];
    }
    public static Acte[] genererActe(String idCheckIn,String datyFin,Connection c) throws Exception
    {
        CheckOut checkOut = new CheckOut("");
        checkOut.setDaty(Utilitaire.string_date("dd/MM/yyyy",datyFin));
        checkOut.setReservation(idCheckIn);
        checkOut.setCheckIn(checkOut.getCheckIn("checkInLibelle",c));
        return checkOut.genererActe(c);
    }
    public Acte[] genererActe(Connection c)throws Exception
    {
        reservation.Check checkIn = this.getCheckIn();
        if(checkIn==null) checkIn= this.getCheckIn("checkInLibelle",c);
        int nbDemiJournee=ConstanteAsync.calculerNombreDemiJournee(checkIn.getDaty(),checkIn.getHeure(),this.getDaty(),this.getHeure());

        Acte[] retour=new Acte[1];
        double qte=Utilitaire.arrondiSupEntier((double)nbDemiJournee/(double)checkIn.equivalence);
        retour[0]=new Acte();
        retour[0].setIdproduit(checkIn.getIdProduit());
        retour[0].setLibelle(checkIn.getProduitLibelle());
        retour[0].setQte(qte);
        retour[0].setPu(checkIn.getPu());
        retour[0].setIdreservation(checkIn.getId());
        retour[0].setDaty(this.getDaty());
        retour[0].setEtat(ConstanteEtat.getEtatCreer());
        retour[0].setIdclient(checkIn.getIdClient());
        retour[0].setTva(checkIn.getTva());
        retour[0].setCompte_vente(checkIn.getCompteVente());
        retour[0].setMontant(retour[0].getQte()*retour[0].getPu());
//        }
        return retour;
    }
    
    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            Check ch = getCheckIn("checkInLibelle", c);
            if(ch.getCheckOut()!=null&&ch.getCheckOut().compareTo(this.getId())!=0) throw new Exception ("Exsistance de check out en doublons");
            if(ch.getEtat() == 1) {
//                throw new Exception("Check in pas encore valid&eacute;e");
                ch.validerObject(u, c);
            } else if(ch.getEtat() < 1){
                throw new Exception("Check in annul&eacute;e");
            }
            //this.setCheckIn(ch);
            Acte[] listeActe = genererActe(c);
            for(Acte a:listeActe)
            {
                a.createObject(u,c);
                a.validerObject(u,c);
            }
            //if(Utilitaire.comparerHeure(this.getHeure(), ConstanteAsync.heureCheckout)>0) this.setDaty(Utilitaire.ajoutJourDate(this.getDaty(),1));

            ReservationDetails[] planningAannule = getPlanningAannule(c);
            if(planningAannule!=null && planningAannule.length>0){
                for (ReservationDetails a : planningAannule) {
                    a.deleteToTableWithHisto(u,c);
                }
            }
            rectifierValeurResa(c);

            Object o=super.validerObject(u, c);
            if(estOuvert==true)c.commit();
            return o;
        }
        catch (Exception e) {
            c.rollback();
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null){c.close();}
        }
    }
    /*public void setDaty(java.sql.Date daty) throws Exception {

        Check in=getCheckIn("Checkin",null);
        if (Utilitaire.compareDaty(daty,in.getDaty())==-1)
        { 
            throw new Exception("La date du Check-Out doit &ecirc;tre sup&eacute;rieur &agrave; la date du Check-In");
        } 
        super.setDaty(daty);
    }*/

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        Check in=getCheckIn("Checkin",c);
        if (Utilitaire.compareDaty(this.getDaty(),in.getDaty())==-1)
        { 
            throw new Exception("La date du Check-Out doit etre superieur a la date du Check-In");
        } 
        return super.createObject(u, c);
    }


    /**
     * Récupère toutes les réservations futures (après la date de checkout)
     */
    private ReservationDetails[] getReservationsFutures(Check checkin, Date dateCheckout, Connection c) throws Exception {
        ReservationDetails planning = new ReservationDetails();
        planning.setNomTable("RESERVATIONPLANNING");
        planning.setIdResadetails(checkin.getReservation());
        planning.setIdmere(checkin.getIdReservationMere());

        String apresWhere = " AND daty > TO_DATE('" + Utilitaire.datetostring(dateCheckout) + "', 'DD/MM/YYYY') " +
                " ORDER BY daty ASC, tranche ASC ";

        return (ReservationDetails[]) CGenUtil.rechercher(planning, null, null, c, apresWhere);
    }

    /**
     * Récupère les réservations du jour même
     */
    private ReservationDetails[] getReservationsJourMeme(Check checkin, Date dateCheckout, Connection c) throws Exception {
        ReservationDetails planning = new ReservationDetails();
        planning.setNomTable("RESERVATIONPLANNING");
        planning.setIdResadetails(checkin.getReservation());
        planning.setIdmere(checkin.getIdReservationMere());

        String[] colInt = {"daty"};
        String[] valInt = {Utilitaire.datetostring(dateCheckout), Utilitaire.datetostring(dateCheckout)};
        String apresWhere = " ORDER BY tranche ASC ";

        return (ReservationDetails[]) CGenUtil.rechercher(planning, colInt, valInt, c, apresWhere);
    }

    public ReservationDetails[] getPlanningAannule(Connection c) throws Exception{
        boolean estOuvert = false;
        List<ReservationDetails> reservationsAnnulees = new ArrayList<>();

        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }

            // 1. Récupérer le check-in correspondant
            Check checkin = getCheckIn("checkInLibelle", c);
            if (checkin == null) {
                throw new Exception("Aucun check-in trouve pour cette reservation");
            }

            // 2. Déterminer la tranche du checkout (AM/PM)
            String trancheCheckout = ConstanteAsync.getAMPM(this.getHeure());
            Date dateCheckout = this.getDaty();

            // 3. Récupérer toutes les réservations futures (après la date de checkout)
            ReservationDetails[] reservationsFutures = getReservationsFutures(checkin, dateCheckout, c);

            // 4. Récupérer les réservations du jour même si checkout en AM
            ReservationDetails[] reservationsJourMeme = null;
            if ("AM".equalsIgnoreCase(trancheCheckout)) {
                reservationsJourMeme = getReservationsJourMeme(checkin, dateCheckout, c);
            }

            // 5. Ajouter au liste a annule
            reservationsAnnulees.addAll(Arrays.asList(reservationsFutures));

            if (reservationsJourMeme != null) {
                // Pour le jour même, annuler seulement la tranche PM si checkout en AM
                for (ReservationDetails resa : reservationsJourMeme) {
                    if ("PM".equalsIgnoreCase(resa.getTranche())) {
                        reservationsAnnulees.add(resa);
                    }
                }
            }

            return reservationsAnnulees.toArray(new ReservationDetails[0]);

        } catch (Exception e) {
            throw e;
        } finally {
            if (estOuvert && c != null) {
                c.close();
            }
        }
    }

    public void rectifierValeurResa(Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            Check checkin = getCheckIn("checkInLibelle", c);

            ReservationDetails reservationDetails = new ReservationDetails();
            reservationDetails.setId(checkin.getReservation());
            reservationDetails.setIdmere(checkin.getIdReservationMere());

            ReservationDetails[] reservationDetails1 = (ReservationDetails[]) CGenUtil.rechercher(reservationDetails,null,null,"");
            double qte = calculerVraiQte(checkin ,c);

            for (int i = 0; i < reservationDetails1.length; i++) {
                reservationDetails1[i].setQte(qte);
                System.out.println(reservationDetails1[i].toString());
                reservationDetails1[i].updateToTable(c);
            }

        } catch (Exception e) {
            throw e;

        } finally {
            if (estOuvert && c != null) {
                c.close();
            }
        }

    }

    public double calculerVraiQte(Check checkIn ,Connection c)throws Exception{
        if(checkIn==null) checkIn= this.getCheckIn("checkInLibelle",c);
        int nbDemiJournee=ConstanteAsync.calculerNombreDemiJournee(checkIn.getDaty(),checkIn.getHeure(),this.getDaty(),this.getHeure());
        double qte=Utilitaire.arrondiSupEntier((double)nbDemiJournee/(double)checkIn.equivalence);
        return qte;
    }
}
