<%--
  Saisie de fin de panne pour une voiture
--%>

<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="panne.FinPanne" %>
<%@ page import="java.sql.*" %>
<%@ page import="utilitaire.UtilDB" %>
<%
    try {
        String idVoiture = request.getParameter("idVoiture");
        String idPanne = null;

        // Recherche de la panne ouverte pour cette voiture (même logique que ReservationDetails.assertNoOpenPanne)
        if (idVoiture != null && idVoiture.trim().length() > 0) {
            Connection c = null;
            boolean openedHere = false;
            try {
                c = new UtilDB().GetConn();
                openedHere = true;
                String sql =
                    "SELECT p.ID " +
                    "FROM PANNE p " +
                    "WHERE p.IDVOITURE = ? " +
                    "  AND NOT EXISTS (SELECT 1 FROM FINPANNE f WHERE f.IDPANNE = p.ID) " +
                    "ORDER BY p.DATEPANNE DESC " +
                    "FETCH FIRST 1 ROW ONLY";
                PreparedStatement ps = c.prepareStatement(sql);
                ps.setString(1, idVoiture);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    idPanne = rs.getString(1);
                }
                rs.close();
                ps.close();
            } finally {
                if (openedHere && c != null) try { c.close(); } catch (Exception ignore) {}
            }
        }

        FinPanne fp = new FinPanne();
        PageInsert pi = new PageInsert(fp, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));

        String classe = "panne.FinPanne";
        String butApresPost = "produits/voiture-fiche.jsp";
        String nomTable = "FINPANNE";

        if (pi.getFormu().getChamp("idmere") != null) {
            pi.getFormu().getChamp("idmere").setLibelle("Panne");
            if (idPanne != null && idPanne.trim().length() > 0) {
                pi.getFormu().getChamp("idmere").setDefaut(idPanne);
            }
        }
        if (pi.getFormu().getChamp("datefin") != null) {
            pi.getFormu().getChamp("datefin").setLibelle("Date fin panne");
        }
        if (pi.getFormu().getChamp("montant") != null) {
            pi.getFormu().getChamp("montant").setLibelle("Montant entretien");
        }

        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Fin de panne voiture</h1>
    <% if (idPanne == null) { %>
        <div class="alert alert-info" role="alert" style="margin: 15px;">
            Aucune panne ouverte trouv&eacute;e pour cette voiture.
        </div>
    <% } else { %>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" value="insert">
        <input name="bute" type="hidden" value="<%= butApresPost + (idVoiture != null ? ("&id=" + idVoiture) : "") %>">
        <input name="classe" type="hidden" value="<%= classe %>">
        <input name="nomtable" type="hidden" value="<%= nomTable %>">
    </form>
    <% } %>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
