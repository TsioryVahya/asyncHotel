

<%@page import="caisse.MvtCaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<% try{
    MvtCaisseCpl t = new MvtCaisseCpl();
    t.setNomTable("MOUVEMENTCAISSECPL");
    //String etat = request.getParameter("etat");
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;e(s)", "Vis&eacute;e(s)", "Annul&eacute;e(s)"};
    //if(etat == null) etat = "";
    String aWhere = "";
    String etat = request.getParameter("etat");
    String listeCrt[] = {"id", "designation", "daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "daty","designation","idCaisseLib","idVenteDetail" , "idVirement","credit","debit", "etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if((etat!=null && etat.compareToIgnoreCase("")!=0)){
        aWhere = " and etat=" + etat;
        pr.setAWhere(aWhere);
    }
    pr.setTitre("Liste mouvement caisse");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/mvt/mvtCaisse-liste.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");

    String[] colSomme = { "credit", "debit" };
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=caisse/mvt/mvtCaisse-modif.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=caisse/mvt/mvtCaisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"id","date", "d&eacute;signation","Caisse","Vente d&eacute;tail" , "Virement","Cr&eacute;dit","D&eacute;dit", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatAffiche = {"Tous","Annul&eacute;","Cr&eacute;e","Valid&eacute;e"};
    String[] etatPasse = {"","_annule","_cree","_valider"};
%>
<script>
    function changerDesignation() {
        document.caisse.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">


        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post"  name="caisse" id="caisse">
            <div class="col-md-12">
                <div class="row">
                    <div class="col-md-4 col-md-offset-4 mb-5">
                        Etat :
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                            <%
                                for( int i = 0; i < etatAff.length; i++ ){ %>
                            <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                            <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                            <% } else { %>
                            <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                            <% } %>
                            <%    }
                            %>
                        </select>
                    </div>
                </div>
                </br>
            </div>
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <div class="row">
            <div class="col-md-12">
                <form action="<%= pr.getLien() %>?but=<%= pr.getApres() %>" method="post">
                    <div class="row">
                        <div class="col-md-7 col-md-offset-4 d-flex mb-5 gap-2">
                            <div class="form-input">
                                <label for="etat"  class="input-label">
                                    Voir l'etat
                                </label>
                                <div class="d-flex gap-2">
                                    <select name="etat" class="form-control">
                                    <%
                                        for( int i = 0; i < etatAffiche.length; i++ ){ %>
                                            <option value="<%= etatPasse[i] %>"> <%= etatAffiche[i] %> </option>
                                    <%    }
                                    %>
                                    </select>
                                </div>
                            </div>
                            <input type="submit" value="Consultez" class="btn btn-primary my-2" />
                        </div>

                    </div>
                </form>
            </div>
            <div class="col-md-12">

                <%
                    out.println(pr.getTableauRecap().getHtml());%>
            </div>
        </div>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



