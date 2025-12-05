
<%@page import="faturefournisseur.Fournisseur"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
    
%>
<%
    Fournisseur caisse = new Fournisseur();
    PageConsulte pc = new PageConsulte(caisse, request, u);
    pc.setTitre("Fiche fournisseur");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("codePostal").setLibelle("code postal");
    String lien = (String) session.getValue("lien");
    String pageModif = "fournisseur/fournisseur-modif.jsp";
    String classe = "faturefournisseur.Fournisseur";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=fournisseur/fournisseur-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                                 <a class="btn btn-primary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                                
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

