<%@ page import="java.sql.*" %>
<%@ page import="utilitaire.UtilDB" %>
<%
    Connection c = null;
    try {
        request.setCharacterEncoding("UTF-8");
        String idVoiture = request.getParameter("idVoiture");

        if (idVoiture != null && idVoiture.trim().length() > 0) {
            c = new UtilDB().GetConn();

            // Insérer seulement si non déjà présent
            String sql = "INSERT INTO NONCHARGEAUTOMOBILE (IDVOITURE) " +
                         "SELECT ? FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM NONCHARGEAUTOMOBILE WHERE IDVOITURE = ?)";
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, idVoiture);
            ps.setString(2, idVoiture);
            ps.executeUpdate();
            ps.close();
            c.commit();
        }

        // Retour à la fiche voiture via JavaScript (on ne peut pas faire de sendRedirect dans une page incluse)
        String baseUrl = request.getContextPath() + "/pages/module.jsp";
        String target = baseUrl + "?but=produits/voiture-fiche.jsp" + (idVoiture != null ? ("&id=" + idVoiture) : "");
        out.println("<script type='text/javascript'>window.location='" + target + "';</script>");
    } catch (Exception e) {
        if (c != null) try { c.rollback(); } catch (Exception ignore) {}
        e.printStackTrace();
        out.println("Erreur lors de l'enregistrement en NONCHARGEAUTOMOBILE : " + e.getMessage());
    } finally {
        if (c != null) try { c.close(); } catch (Exception ignore) {}
    }
%>
