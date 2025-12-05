
<%@page import="produits.ActeLib"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
    ActeLib objet = new ActeLib();
    objet.setNomTable("ACTE_LIB");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche Acte");
    pc.getChampByName("libelle").setVisible(false);
    pc.getBase();
    String id=pc.getBase().getTuppleID();

    String lien = (String) session.getValue("lien");
    String pageModif = "acte/acte-modif.jsp";
    String classe = "produits.ActeLib";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=acte/acte-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=acte/acte-fiche.jsp&classe=produits.Acte&nomtable=Acte"%> " style="margin-right: 10px">Viser</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=acte/acte-liste.jsp&classe="+classe %>">Supprimer</a>
                            <a class="btn btn-secondary pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


