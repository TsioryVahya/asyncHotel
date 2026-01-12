<%--
  Saisie d'une panne de voiture
--%>

<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="panne.Panne" %>
<%
    try {
        // Objet métier
        Panne p = new Panne();
        PageInsert pi = new PageInsert(p, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));

        // Paramètre venant de la fiche voiture
        String idVoiture = request.getParameter("idVoiture");

        // Variables de navigation / post-traitement
        String classe = "panne.Panne";
        String butApresPost = "produits/voiture-fiche.jsp";
        String nomTable = "PANNE";

        // Libellés des champs
        if (pi.getFormu().getChamp("idVoiture") != null) {
            pi.getFormu().getChamp("idVoiture").setLibelle("Voiture");
            if (idVoiture != null && idVoiture.trim().length() > 0) {
                pi.getFormu().getChamp("idVoiture").setDefaut(idVoiture);
            }
        }
        if (pi.getFormu().getChamp("datepanne") != null) {
            pi.getFormu().getChamp("datepanne").setLibelle("Date de panne");
        }
        if (pi.getFormu().getChamp("motif") != null) {
            pi.getFormu().getChamp("motif").setLibelle("Motif");
        }

        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Saisie panne voiture</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" value="insert">
        <input name="bute" type="hidden" value="<%= butApresPost + (idVoiture != null ? ("&id=" + idVoiture) : "") %>">
        <input name="classe" type="hidden" value="<%= classe %>">
        <input name="nomtable" type="hidden" value="<%= nomTable %>">
    </form>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
