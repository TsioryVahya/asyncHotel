package reservation;

import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMAPTable;
import bean.ClassMere;
import produits.Acte;
import produits.Ingredients;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import caisse.MvtCaisse;
import prevision.Prevision;
import utils.ConstanteStation;
import vente.Vente;
import vente.VenteDetails;

import javax.validation.constraints.Null;

public class Reservation extends ClassMere
{
    String id;
    String idclient;
    Date daty;
    String remarque;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdclient() {
        return idclient;
    }

    @Override
    public String getLiaisonFille() {
        return "idmere";
    }
    @Override
    public  String getNomClasseFille() {
        return "reservation.ReservationDetails";
    }

    public void setIdclient(String idclient) throws Exception {
        if(getMode().compareToIgnoreCase("modif") == 0){
            if(idclient == null || idclient.compareToIgnoreCase("") == 0) throw new Exception("Client vide");
        }
        this.idclient = idclient;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) throws Exception {
        if(getMode().compareToIgnoreCase("modif") == 0){
            if(daty == null){
                this.daty = Utilitaire.dateDuJourSql();
                return;
            }
        }
        this.daty = daty;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public Reservation () throws Exception {
        setNomTable("reservation");
        setLiaisonFille("idmere");
        setNomClasseFille("reservation.ReservationDetails");
    }

    @Override
    public boolean getEstIndexable() {
        return true;
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
        this.preparePk("RESA", "GETSEQRESERVATION");
        this.setId(makePK(c));
    }

    @Override
    public void annulerVisa(String u, Connection c) throws Exception {
        // Annuler les ReservationPlanning liés à la réservation
        ReservationDetails reservationDetails = new ReservationDetails();
        reservationDetails.setIdmere(this.getId());
        reservationDetails.setNomTable("reservationplanning");
        ReservationDetails[] planningreservation = (ReservationDetails[]) CGenUtil.rechercher(reservationDetails, null, null, c, "");

        Check check = new Check();
        check.setNomTable("checkinlibelle");
        check.setIdReservationMere(this.getId());
        Check[] checkins = (Check[]) CGenUtil.rechercher(check, null, null, c, "");
        if(checkins != null && checkins.length > 0){
            throw new Exception("Impossible d annuler la reservation car des check-in ont ete effectues.");
        }
        if(planningreservation != null && planningreservation.length > 0){
            for (ReservationDetails planning : planningreservation) {
                planning.setNomTable("reservationplanning");
                planning.deleteToTable(c);
            }
        }
        super.annulerVisa(u, c);
    }

    public void effectif(String u, Connection c) throws Exception
    {
        boolean isOuvert = false;
        try
        {
            if (c == null)
            {
                c = new UtilDB().GetConn();
                isOuvert = true;
            }
            ReservationDetails r = new ReservationDetails();
            r.setIdmere(this.getId());
            ReservationDetails[] res = (ReservationDetails[]) CGenUtil.rechercher(r, null, null, c, " ");
            for (int j = 0; j < res.length; j++)
            {
                Ingredients ing = new Ingredients();
                ing.setId(res[j].getIdproduit());
                Ingredients[] ings = (Ingredients[]) CGenUtil.rechercher(ing, null, null, c, " ");
                for (int i = 0; i < res[i].getQte(); i++)
                {
                    Acte acte = new Acte();
                    acte.setIdclient(this.getIdclient());
                    acte.setIdreservation(this.getId());
                    acte.setIdproduit(res[j].getIdproduit());
                    acte.setQte(res[i].getQte());
                    acte.setLibelle("Location de/du " + this.getId());
                    acte.setPu(ings[0].getPu());
                    LocalDate ld = this.getDaty().toLocalDate().plusDays(i);
                    Date dt = Date.valueOf(ld);
                    acte.setDaty(dt);
                    acte.createObject(u, c);
                }
            }
        }
        catch (Exception e) {
            c.rollback();
            e.printStackTrace();
            throw new Exception("Rendre effectif réservation non abouti");
        }
        finally {
            if (isOuvert) {
                c.close();
            }
        }
    }

    public Acte[] getActes(Connection c) throws Exception
    {
        Acte[] actes;
        boolean isOuvert = false;
        try
        {
            if (c == null)
            {
                c = new UtilDB().GetConn();
                isOuvert = true;
            }
            Acte acte = new Acte();
            acte.setIdreservation(this.getId());
            actes = (Acte[]) CGenUtil.rechercher(acte, null, null, c, " ");
        }
        catch (Exception e)
        {
            c.rollback();
            e.printStackTrace();
            throw new Exception("Erreur lors de la recuperation des actes dans la reservation");
        }
        finally {
            if (isOuvert) {
                c.close();
            }
        }
        return actes;
    }
    public List<reservation.ReservationDetails> decomposer(String nT,Connection c) throws Exception{
        List<reservation.ReservationDetails> res = new ArrayList<reservation.ReservationDetails>();
        reservation.ReservationDetails[] listeFille =(reservation.ReservationDetails[])this.getFille();
        if(listeFille==null)listeFille=(reservation.ReservationDetails[])this.getFille(nT,c,"");
        for(reservation.ReservationDetails fille : listeFille)
        {
            res.addAll(fille.decomposer());
        }
        return res;
    }
    public Acte[] getActeAvecSimulation(String nTActe,Connection c)throws Exception {
        boolean estOuvert = false;
        try {
            if(c==null){
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            List<Acte> retour=new ArrayList<>();
            Check[] listeCheckIn=this.getListeCheckIn(null,c);
            for (int i = 0; i < listeCheckIn.length; i++)
            {
                retour.addAll(Arrays.asList(listeCheckIn[i].getActeAvecSimulation(nTActe,c)));
            }

            return retour.toArray(new Acte[retour.size()]);
        }catch (Exception e) {
            e.printStackTrace();
            throw  e;
        }finally {
            if(estOuvert) c.close();
        }
    }
    public vente.VenteDetails[] genereVenteDetails(String nTableChekIn,Connection c)throws Exception {
        List<vente.VenteDetails> retour=new ArrayList<>();
        Check[] listeCheckIn=this.getListeCheckIn("CHECKINLIBELLE",c);
        for (int i = 0; i < listeCheckIn.length; i++)
        {
            retour.addAll(Arrays.asList(listeCheckIn[i].genereVenteDetails("ACTE_LIB",c)));
        }
        VenteDetails[] venteDetails = retour.toArray(new vente.VenteDetails[retour.size()]);

        if(venteDetails == null || venteDetails.length <= 0){
            venteDetails = genereVente(c);
        }
        return venteDetails;
    }

    public CheckOut[] getListeCheckOut(String nTableChekOut,Connection c)throws Exception {
        CheckOut crt = new CheckOut();
        crt.setNomTable("CHECKOUTAVECRESERVATION");
        if (nTableChekOut != null && nTableChekOut.compareTo("") != 0) crt.setNomTable(nTableChekOut);
        crt.setReservation (this.getId());
        return (CheckOut[]) CGenUtil.rechercher(crt,null,null,c,"");
    }

    public Check[] getListeCheckIn(String nT, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }
            Check crt = new Check();
            crt.setNomTable("CHECKINLIBELLE");
            if (nT != null && nT.compareTo("") != 0) crt.setNomTable(nT);
            crt.setIdReservationMere (this.getId());
            return (Check[]) CGenUtil.rechercher(crt,null,null,c,"");
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }
    }

    public Prevision genererPrevision(String u, Connection c) throws Exception{
        Prevision mere = new Prevision();

        ReservationLibAvecDateMax reservationComplet = this.getReservationWithMontant(c);
        mere.setIdOrigine(this.getId());
        Prevision [] previsions = (Prevision[]) CGenUtil.rechercher(mere,null,null,c,"");

        if(previsions.length > 0){
            previsions[0].setCredit(reservationComplet.getResteAPayer());
            previsions[0].updateToTableWithHisto(u, c);
            return previsions[0];
        }

        Date datyPrevu = reservationComplet.getDatyfinpotentiel();
        mere.setDaty(datyPrevu);
        mere.setCredit(reservationComplet.getResteAPayer());
        mere.setIdCaisse(ConstanteStation.idCaisse);
        mere.setIdDevise("AR");
        mere.setDesignation("Prevision rattach&eacute;e au Reservation N : "+this.getId());
        mere.setIdTiers(this.getIdclient());
        return ( Prevision ) mere.createObject(u, c);
    }

    public ReservationLibAvecDateMax getReservationWithMontant(Connection c) throws Exception{
        return (ReservationLibAvecDateMax)new reservation.ReservationLibAvecDateMax().getById(this.getId(), "reservation_lib_avecmaxdate", c);
    }
    

    public Vente[] getFactureClient(String nT, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }
            Vente crt = new Vente();
            if (nT != null && nT.compareTo("") != 0) crt.setNomTable(nT);
            crt.setIdReservation(this.getId());
            System.out.println("ID RESA "+crt.getIdReservation());
            return (Vente[]) CGenUtil.rechercher(crt,null,null,c,"");
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }
    }
    public reservation.ReservationDetails[] decomposerEnTableau(String nT,Connection c) throws Exception {
        List<reservation.ReservationDetails> res=decomposer(nT,c);
        return res.toArray (new reservation.ReservationDetails[res.size()]);
    }
    public MvtCaisse[] getAcompte(String nT,Connection c) throws Exception {
        MvtCaisse crt=new MvtCaisse();
        if(nT!=null&&nT.compareTo("") != 0) crt.setNomTable(nT);
        crt.setIdOp(this.getId());
        return (MvtCaisse[]) CGenUtil.rechercher(crt,null,null,c,"");
    }
    public ReservationDetailsCheck[] getListeSansCheckIn(String nT, Connection c) throws Exception{
        boolean estOuvert = false;
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }
            ReservationDetailsCheck crt = new ReservationDetailsCheck();
            if (nT != null && nT.compareTo("") != 0) crt.setNomTable(nT);
            crt.setIdmere (this.getId());
            return (ReservationDetailsCheck[]) CGenUtil.rechercher(crt,null,null,c,"");
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }
    }
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        
//        reservation.ReservationDetails[] fille=(reservation.ReservationDetails[])this.getFille();
//        ArrayList<reservation.ReservationDetails> retour=new ArrayList<>();
//        for(int i=0;i<fille.length;i++)
//        {
//            retour.addAll(fille[i].decomposer());
//        }
//        reservation.ReservationDetails[] filleVrai=retour.toArray (new reservation.ReservationDetails[retour.size()]);
//        this.setFille(filleVrai);
        // Valider chaque détail contre les pannes AVANT l'insertion
        // 1) Générer l'ID de la réservation si pas encore fait
        if (this.getId() == null || this.getId().trim().isEmpty()) {
            // Adaptez au pattern utilisé dans votre projet (exemple illustratif)
            this.preparePk("RESERVATION", "GETSEQRESERVATION");
            this.setId(this.makePK(c)); // nécessite une connexion 'c' ouverte ici
        }

        // 2) Valider chaque détail avec idmere et date déjà posés
        Object[] filles = this.getFille();
        if (filles != null) {
            for (Object o : filles) {
                if (o instanceof reservation.ReservationDetails) {
                    reservation.ReservationDetails det = (reservation.ReservationDetails) o;

                    // Poser la liaison mère
                    det.setIdmere(this.getId());

                    // Poser une date de contrôle fiable (fallback) = date entête
                    if (det.getDaty() == null) {
                        det.setDaty(this.getDaty());
                    }

                    // S'assurer du nom de table si nécessaire
                    if (det.getNomTable() == null || det.getNomTable().trim().isEmpty()) {
                        det.setNomTable("RESERVATIONDETAILS");
                    }

                    // Contrôle d'insert (inclut le contrôle 'panne' côté Java)
                    det.controlerInsert(c);
                }
            }
        }

        return super.createObject(u, c);
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
            genererPrevision(u, c);
            traiterReservationDetails(u,c);
            super.validerObject(u, c);
            if(estOuvert) c.commit();
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    /**
     * Traite les détails de réservation et crée les réservations planifiées
     */
    private void traiterReservationDetails(String utilisateur, Connection connexion) throws Exception {
        ReservationDetails[] reservationDetails = (ReservationDetails[]) this.getFille("reservationdetails", connexion, "");

        for (ReservationDetails detail : reservationDetails) {
            ReservationDetails[] planifications = detail.genererAutres();

            for (ReservationDetails planification : planifications) {
                planification.setNomTable("reservationplanning");
                verifierDisponibilite(planification, connexion);
                planification.createObject(utilisateur, connexion);
            }
        }
    }

    /**
     * Vérifie la disponibilité d'une réservation planifiée
     */
    private void verifierDisponibilite(ReservationDetails planification, Connection connexion) throws Exception {
        if (!planification.isDisponible(connexion)) {
            throw new Exception("Voiture non disponible pour " + planification.getDaty() + " " + planification.getTranche());
        }
    }


    public VenteDetails[] genereVente(Connection c)throws  Exception {
        ReservationDetails[] reservationDetails = (ReservationDetails[]) this.getFille(null, c, "");
        VenteDetails[] venteDetails = new VenteDetails[reservationDetails.length];
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            for (int i = 0; i < venteDetails.length; i++) {
                venteDetails[i] = new VenteDetails();
                venteDetails[i].setIdProduit(reservationDetails[i].getIdproduit());
                Ingredients ingredients = (Ingredients) new Ingredients().getById(reservationDetails[i].getIdproduit(), "AS_INGREDIENTS_LIB", c);
                venteDetails[i].setDesignation(ingredients.getLibelle());
                venteDetails[i].setCompte(ingredients.getCompte_vente());
                venteDetails[i].setTva(ingredients.getTva());
                venteDetails[i].setQte(reservationDetails[i].getQte());
                venteDetails[i].setPu(reservationDetails[i].getPu());
                venteDetails[i].setDatereservation(Utilitaire.stringDate(Utilitaire.datetostring(reservationDetails[i].getDaty())));
            }
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        return venteDetails;
    }

}
