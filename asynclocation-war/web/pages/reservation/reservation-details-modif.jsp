<%@ page import="reservation.ReservationDetails" %>
    <%@ page import="affichage.PageUpdate" %>
        <%@ page import="user.UserEJB" %>
            <% try { ReservationDetails t=new ReservationDetails(); UserEJB u=(UserEJB) session.getValue("u"); String
                lien=(String) session.getValue("lien"); PageUpdate pu=new PageUpdate(t, request, u); pu.setLien(lien);
                pu.setTitre("Modifier le d&eacute;tail de la r&eacute;servation");
                pu.getFormu().getChamp("id").setAutre("readonly");
                pu.getFormu().getChamp("idVoiture").setLibelle("Voiture");
                pu.getFormu().getChamp("idVoiture").setPageAppelComplete("produits.Voiture","id","VOITURE","nom","");
                pu.getFormu().getChamp("idproduit").setLibelle("Produit");
pu.getFormu().getChamp("idproduit").setPageAppelComplete("produits.Ingredients","id","AS_INGREDIENTS_LIB","libelle","");
                pu.preparerDataFormu(); String idReservation=request.getParameter("idMere"); String
                apres="reservation/reservation-fiche.jsp&id=" + idReservation; %>
                <div class="content-wrapper">
                    <h1 class="box-title"><a href="<%= lien + "?but=" + apres %>"><i class="fa fa-angle-left"></i></a>
                        <%=pu.getTitre()%>
                    </h1>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="box-fiche">
                                <div class="box">
                                    <form action="<%= lien %>?but=apresTarif.jsp&id=<%=request.getParameter("id")%>" method="post">
                                        <input name="idmere" type="hidden" value="<%=request.getParameter("idMere")%>">
                                        <% out.println(pu.getFormu().getHtmlInsert()); %>
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <button class="btn btn-primary pull-right" name="Submit2"
                                                        type="submit">Valider</button>
                                                </div>
                                            </div>
                                            <input name="acte" type="hidden" id="acte" value="update">
                                            <input name="bute" type="hidden" id="bute" value="<%=apres%>">
                                            <input name="classe" type="hidden" id="classe"
                                                value="reservation.ReservationDetails">
                                            <input name="nomtable" type="hidden" id="nomtable"
                                                value="RESERVATIONDETAILS">
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } catch (Exception e) { e.printStackTrace(); } %>