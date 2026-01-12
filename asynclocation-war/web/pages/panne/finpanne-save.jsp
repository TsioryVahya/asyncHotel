<%@ page import="java.sql.*" %>
<%@ page import="utilitaire.UtilDB" %>
<%
    Connection c = null;
    try {
        request.setCharacterEncoding("UTF-8");

        String idVoiture = request.getParameter("idVoiture");
        String idPanne   = request.getParameter("idpanne");
        if (idPanne == null || idPanne.trim().length() == 0) {
            // Certains formulaires peuvent poster sous le nom idmere
            String tmp = request.getParameter("idmere");
            if (tmp != null && tmp.trim().length() > 0) {
                idPanne = tmp;
            }
        }
        String dateFin   = request.getParameter("datefin");
        String montantStr = request.getParameter("montant");

        if (montantStr == null || montantStr.trim().length() == 0) {
            montantStr = "0";
        }

        c = new UtilDB().GetConn();

        // Utiliser le trigger TRG_FINPANNE_BI pour générer l'ID
        String sql = "INSERT INTO FINPANNE (IDPANNE, DATEFIN, MONTANT) " +
                     "VALUES (?, TO_DATE(?, 'DD/MM/YYYY'), ? )";
        PreparedStatement ps = c.prepareStatement(sql);
        ps.setString(1, idPanne);
        ps.setString(2, dateFin);
        ps.setDouble(3, Double.parseDouble(montantStr.replace(' ', '\u0000').replace(" ", "").replace(",", ".")));

        ps.executeUpdate();
        ps.close();
        c.commit();

        // Retour à la fiche voiture via le module central
        String baseUrl = request.getContextPath() + "/pages/module.jsp";
        response.sendRedirect(baseUrl + "?but=produits/voiture-fiche.jsp" + (idVoiture != null ? ("&id=" + idVoiture) : ""));
    } catch (Exception e) {
        if (c != null) try { c.rollback(); } catch (Exception ignore) {}
        e.printStackTrace();
        out.println("Erreur lors de l'enregistrement de la fin de panne : " + e.getMessage());
    } finally {
        if (c != null) try { c.close(); } catch (Exception ignore) {}
    }
%>
