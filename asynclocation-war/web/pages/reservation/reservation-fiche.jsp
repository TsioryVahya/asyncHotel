<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="reservation.ReservationLib" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="reservation.Check" %>

<%
    try{
        String ismodal = request.getParameter("ismodal");
        String lien = (String) session.getValue("lien");
        ReservationLib t = new ReservationLib();
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (ReservationLib) pc.getBase();
        String id=pc.getBase().getTuppleID( );
        pc.getChampByName("id").setLibelle("ID");
        //pc.getChampByName("idclient").setVisible(false);
        pc.getChampByName("idclientlib").setLibelle("Nom du client");
        pc.getChampByName("idclient").setLibelle("ID client");
        pc.getChampByName("idclient").setLien(lien+"?but=client/client-fiche.jsp", "id=");
        pc.getChampByName("daty").setLibelle("Date de R&eacute;servation");
        pc.getChampByName("remarque").setLibelle("D&eacute;signation");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("montant").setLibelle("Montant HT");
        pc.getChampByName("montantTva").setLibelle("Montant TVA");
        pc.getChampByName("montantTTC").setLibelle("Montant TTC");
        pc.getChampByName("revient").setLibelle("Prix de revient");
        pc.getChampByName("marge").setLibelle("Marge brute");
        pc.getChampByName("paye").setLibelle("Montant pay&eacute;");
        pc.getChampByName("resteAPayer").setLibelle("Reste &agrave; payer");
        pc.setTitre("Fiche de la r&eacute;servation");
        String pageModif = "reservation/reservation-saisie.jsp";
        String pageActuel = "reservation/reservation-fiche.jsp";
        String classe = "reservation.ReservationLib";
        String classeAnnuler = "reservation.Reservation";
        String nomTable = "RESERVATION_LIB";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/reservation-details", "");
        map.put("inc/liste-checkin", "");
        map.put("inc/liste-checkout", "");      
        map.put("inc/reservation-paiement", "");
        map.put("inc/reservation-facture", "");
        map.put("inc/liste-acte-service", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/reservation-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        ReservationLib dp=(ReservationLib)pc.getBase();
        pc.setModalOnClick(true);

        Check check = new Check();
        check.setNomTable("checkinlibelle");
        check.setIdReservationMere(id);
        Check[] checkins = (Check[]) CGenUtil.rechercher(check, null, null, null, "");
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="#"><i class="fa fa-angle-left"></i></a><% out.println(pc.getTitre()); %></h1>

    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                           out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <% if(t.getEtat()==1){ %>
                                <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>&acte=update" style="margin-right: 10px">Modifier</a>
                                <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=reservation/reservation-fiche.jsp&classe="+classeAnnuler %>" style="margin-right: 10px">Annuler</a>
                                <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=reservation/reservation-fiche.jsp&classe=reservation.Reservation&nomtable=RESERVATION"%> " style="margin-right: 10px">Valider</a>
                            <%}%>
                            <%
                                if(t.getEtat()==11){
                            %>
<%--                                <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=reservation/reservation-fiche.jsp&classe="+classeAnnuler %>" style="margin-right: 10px">Annuler</a>--%>
                                <%

                                    if(checkins != null && checkins.length==0){%>
                                        <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annulerVisa&bute=reservation/reservation-fiche.jsp&classe="+classeAnnuler %>" style="margin-left: 10px">Annuler Visa</a>
                            <%}
                            %>
                            <%}%>
                                <a class="btn btn-primary pull-right" href="<%= lien + "?but=vente/vente-saisie.jsp&id=" + id %> " >Facturer</a>
                                <a class="btn btn-secondary pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-entree-fc.jsp&idOp=" + request.getParameter("id") + "&montant="+dp.getResteAPayer()+"&devise=AR&&tiers="+dp.getIdclient() %> " style="margin-right: 10px">Acompte</a>
                                <a class="btn btn-tertiary pull-right" href="<%= lien + "?but=acte/acte-saisie.jsp&idresa=" + id + "&idclient=" + pc.getChampByName("idclient").getValeur() %> " style="margin-right: 10px">Ajouter Service</a>
                                <a class="btn btn-tertiary pull-right" href="<%= lien + "?but=check/checkin-saisie.jsp&idresa=" + id%>" style="margin-right: 10px">Check-in</a>
                                <a class="btn btn-tertiary pull-right" href="<%= lien + "?but=check/checkout-saisie.jsp&idresa=" + id%>" style="margin-right: 10px">Check-out</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs" style="margin-top: 20px;">
                    <!-- a modifier -->
                    <%
                        if (ismodal != null && ismodal.equalsIgnoreCase("true"))
                        {
                    %>
                        <li class="<%=map.get("inc/reservation-details")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/reservation-details&ismodal=true','modalContent')">D&eacute;tails</a></li>
                        <li class="<%=map.get("inc/liste-checkin")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/liste-checkin&ismodal=true','modalContent')">Check-In Effectu&eacute;</a></li>
                        <li class="<%=map.get("inc/liste-checkout")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/liste-checkout&ismodal=true','modalContent')">Check-Out Effectu&eacute;</a></li>
                        <li class="<%=map.get("inc/reservation-paiement")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/reservation-paiement&ismodal=true','modalContent')">Liste Des Paiements Effectu&eacute;s </a></li>
                        <li class="<%=map.get("inc/liste-acte")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/liste-acte-service&ismodal=true','modalContent')">Liste Des Services Rattach&eacute;s</a></li>
                        <li class="<%=map.get("inc/reservation-facture")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/reservation-facture&ismodal=true','modalContent')">Liste Des Factures</a></li>
                    <%}else {%>
                        <li class="<%=map.get("inc/reservation-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/reservation-details">D&eacute;tails</a></li>
                        <li class="<%=map.get("inc/liste-checkin")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-checkin">Check-In Effectu&eacute;</a></li>
                        <li class="<%=map.get("inc/liste-checkout")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-checkout">Check-Out Effectu&eacute;</a></li>
                        <li class="<%=map.get("inc/reservation-paiement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/reservation-paiement">Liste Des Paiements Effectu&eacute;s </a></li>
                        <li class="<%=map.get("inc/liste-acte")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-acte-service">Liste Des Services Rattach&eacute;s</a></li>
                        <li class="<%=map.get("inc/reservation-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%=id %>&tab=inc/reservation-facture">Liste Des Factures</a></li>
                    <%}%>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>


</div>

<%=pc.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>

