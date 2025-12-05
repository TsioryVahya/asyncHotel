<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 03/04/2025
  Time: 15:01
  To change this template use File | Settings | File Templates.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="produits.CategorieIngredient" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    CategorieIngredient client = new CategorieIngredient();

    PageConsulte pc = new PageConsulte(client, request, u);
    pc.setTitre("Fiche Categorie d'ingredient");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("D&eacute;signation");
    pc.getChampByName("desce").setLibelle("Description");
    String lien = (String) session.getValue("lien");
    String pageModif = "categorieingredient/categorie-ingredient-modif.jsp";
    String classe = "produits.CategorieIngredient";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=categorieingredient/categorie-ingredient-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=categorieingredient/categorie-ingredient-liste.jsp&classe="+classe+"&nomtable=CATEGORIEINGREDIENT" %>" style="margin-right: 10px">Supprimer</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

