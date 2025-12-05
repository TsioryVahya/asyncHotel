<%@page import="produits.Acte"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>

<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Acte t =new Acte();
    PageUpdate pi = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("idproduit").setPageAppelComplete("produits.IngredientsLib","id","ST_INGREDIENTSAUTOService","pu;tva;libelle","pu;tva;libelle");
    pi.getFormu().getChamp("idproduit").setLibelle("Services");
    pi.getFormu().getChamp("idclient").setLibelle("Client");
    pi.getFormu().getChamp("idclient").setPageAppelComplete("client.Client","id","Client");
    pi.getFormu().getChamp("idclient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
    pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
    pi.getFormu().getChamp("pu").setAutre("onChange='calculerMontant()'");
    pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("libelle").setDefaut("Location");
    pi.getFormu().getChamp("idreservation").setLibelle("Chambre");
    String apresWh=" and reservation='"+request.getParameter("id")+"'";
    pi.getFormu().getChamp("idreservation").setPageAppelCompleteAWhere("reservation.CheckInSansCheckOutCPL", "idproduit", "CHECKINSANSCHEKOUTCPL", "id", "idreservation",apresWh);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("id").setVisible(false);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().setNbColonne(2);
    pi.preparerDataFormu();
%>
<style>
    .col-md-12.cardradius.input-container {
        border: none;
        border-top: none !important;
        padding: 0;
        margin-bottom: 20px;
    }
    .col-md-12.mb-5.import-input {
        display: none;
    }
</style>
<div class="content-wrapper">
       <div class="row">
              <div class="col-md-12">
                     <div class="box-fiche">
                            <div class="">
                                   <div class="box-title with-border">
                                        <h1>Modification acte</h1>
                                   </div>
                                   <div class="box-body">
                                        <form action="<%=(String) session.getValue("lien")%>?but=apresTarif.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
                                            <div class="box-fiche">
                                                <div class="box">
                                                    <div class="box-body">
                                                        <%
                                                            out.println(pi.getFormu().getHtmlInsert());
                                                        %>
                                                        <div class="col-md-12">
                                                            <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <input name="bute" type="hidden" id="bute" value="acte/acte-fiche.jsp"/>
                                            <input name="acte" type="hidden" id="acte" value="update">
                                            <input name="classe" type="hidden" id="classe" value="produits.Acte">
                                            <input name="nomtable" type="hidden" id="nomtable" value="ACTE">
                                        </form>
                                   </div>
                            </div>
                     </div>
              </div>
       </div>
</div>