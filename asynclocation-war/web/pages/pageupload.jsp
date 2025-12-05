<%@page import="bean.CGenUtil"%>
<%@page import="uploadbean.UploadPj"%>
<%
    try{
    String id = request.getParameter("id");
    if(request.getParameter("idDir")!=null && request.getParameter("idDir").compareTo("")!=0){
        id=request.getParameter("idDir");
    }
    String nomtable = request.getParameter("nomtable");
    UploadPj criteria = new UploadPj(nomtable);
    UploadPj[] listeUploaded = (UploadPj[]) CGenUtil.rechercher(criteria, null, null, " AND MERE = '" + id + "'");
    configuration.CynthiaConf.load();
    String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
    String dossierTemp = request.getParameter("dossier");
    String dossier = dossierTemp 
        .replace("'","_")                
        .replace("-","_")
        .replace(":", "_")
        .replace("*", "_")
        .replace(" ", "_");
    int taille = 1;
%>
<div class="content-wrapper">
    <h1 class="box-title">Les fichiers d&eacute;j&agrave; attach&eacute;s</h1>

    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box" style="margin-bottom: 2rem">
                    <div class="box-body">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th class="contenuetable">Libell&eacute;</th>
                                    <th class="contenuetable">Fichier</th>
                                    <th class="contenuetable">#</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%if (listeUploaded != null && listeUploaded.length > 0) {
                                        for (UploadPj element : listeUploaded) {%>
                                <tr>
                                    <td><%=utilitaire.Utilitaire.champNull(element.getLibelle())%></td>
                                    <td><%=element.getChemin()%></td>
                                    <td><a class="btn btn-danger" href="../DeletePj?but=<%=request.getParameter("but")%>&idpj=<%=element.getId()%>&id=<%=id%>&idDir=<%=id%>&nomtable=<%=request.getParameter("nomtable")%>&bute=<%=request.getParameter("bute")+"&idCommande="+request.getParameter("idCommande")+"&idDemandeCotation="+request.getParameter("idDemandeCotation")+"&idGroupeCommande="+request.getParameter("idGroupeCommande")%>&procedure=<%=request.getParameter("procedure")%>&enfant=<%=request.getParameter("enfant")%>&dossier=<%=request.getParameter("dossier")%>">supprimer</a></td>
                                </tr>
                                <%}
                                } else {%>
                                <tr><td colspan="3" style="text-align: center;"><strong>Aucun fichier</strong></td></tr>
                                <%}%>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="box">
                        <h4 class="h424pxBold" style="margin-left: 10px">Uploader des fichiers pour l'identifiant : <%=id%></h4>
                        <h5 class="h520pxSemibold
                        " style="margin-left: 10px">Formats acc&eacute;pt&eacute;es : pdf, excel, jpg</h5>
                    <div class="box-body">                        
                        <form action="${pageContext.request.contextPath}/UploadDownloadFileServlet?dossier=<%=dossier%>" method="POST" enctype="multipart/form-data">
                            <div id="uploadapj">
                                <div class="form-group">
                                    <div class="col-xs-7" style="margin-right: -15px; margin-bottom: 10px">
                                        <input type="text" name="libelle<%=taille%>" placeholder="Titre" class="form-control" style="height: 30px;" multiple="true">
                                    </div>
                                    <div class="col-xs-5" style="margin-left: -15px;">
                                        <div class="input-group">
                                            <input type="file" name="fichiers<%=taille%>" class="form-control" style="height: 30px; padding: 4px;" multiple="true">
                                            <div class="input-group-addon" onclick="removeLine(this)"><i class="fa fa-remove"></i></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <input type="hidden" name="nomtable" value="<%=request.getParameter("nomtable")%>">
                            <input type="hidden" name="procedure" value="<%=request.getParameter("procedure")%>">
                            <input type="hidden" name="bute" value="<%=request.getParameter("bute")%>">
                            <input type="hidden" name="id" value="<%=request.getParameter("id")%>">
                            <input type="hidden" name="idDir" value="<%=id%>">
                               <button type="submit" class="btn btn-primary pull-right" style="margin: 15px 5px 5px 5px">Enregistrer</button>
                                 <button type="button" class="btn btn-secondary pull-right" style="margin: 15px 5px 5px 5px" onclick="addLine()">Ajouter ligne(s)</button>
                        </form>
                    </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<script>
    function addLine() {
        <% taille++; %>
        var content = '<div class="form-group">'
                + '<div class="col-xs-7" style="margin-right: -15px; margin-bottom: 10px">'
                + '<input type="text" name="libelle<%=taille%>" class="form-control" multiple="true">'
                + '</div>'
                + '<div class="col-xs-5" style="margin-left: -15px;">'
                + '<div class="input-group">'
                + '<input type="file" name="fichiers<%=taille%>" class="form-control" style="padding: 4px;" multiple="true">'
                + '<div class="input-group-addon" onclick="removeLine(this)"><i class="fa fa-remove"></i></div>'
                + '</div>'
                + '</div>'
                + '</div>';
        $('#uploadapj').append(content);

    }
    function removeLine(obj) {
        $(obj).parent().parent().parent().remove();
    <% taille--;%>
    }
</script>
<%}catch(Exception ex){
        ex.printStackTrace();
        }%>