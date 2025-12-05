

<%@page import="faturefournisseur.Fournisseur"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>
<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Fournisseur t = new Fournisseur();
    
    String  mapping = "faturefournisseur.Fournisseur",
          nomtable = "fournisseur",
          apres = "fournisseur/fournisseur-fiche.jsp",
          titre = "Modification fournisseur";
 
  
    PageUpdate pu = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
    pu.setLien((String) session.getValue("lien"));
    pu.setTitre("Modification fournisseur");
    pu.getFormu().getChamp("codePostal").setLibelle("code postal");
    String lien = (String) session.getValue("lien");
    String id=pu.getBase().getTuppleID();
    pu.preparerDataFormu();
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
    <h1 class="box-title"><a href=<%= lien + "?but=fournisseur/fournisseur-fiche.jsp&id="+id%>> <i class="fa fa-angle-left"></i></a><%=pu.getTitre()%></h1>

    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="">
                    <div class="box-title with-border">
                    </div>
                    <form action="<%= lien %>?but=apresTarif.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
                        <div class="box-fiche">
                            <div class="box">
                                <div class="box-body">
                                    <%
                                        out.println(pu.getFormu().getHtmlInsert());
                                    %>
                                    <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>

                                </div>
                            </div>
                        </div>
                        <input name="acte" type="hidden" id="acte" value="update">
                        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
                        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
                        <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%out.print(request.getParameter("id"));%>" >
                        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>