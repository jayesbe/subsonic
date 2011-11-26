<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%@ include file="include.jsp" %>

<div id="uploadFile" class="bgcolor1 mainmenudropdown vcenterouter fillwidth" style="display:none">
    <span class="aligncenter vcenterinner">
        <div>
        <form id="uploadFileForm" name="uploadFileForm" method="post" enctype="multipart/form-data" action="upload.view" class="vcenter">
            <table class="center">
                <tr>
                    <td>
                        <input type="file" id="uploadsource" name="file" size="40" onChange="validateSource()" class="inputWithIcon" validation="required" />
                        <span class="ui-icon ui-icon-folder-open right" onClick="uploadsource.click()"></span>
                        <span id="uploaddirectory" class="ui-helper-hidden">
                            <fmt:message key="more.upload.target"/> <input type="text" id="dir" name="dir" size="50" value="${model.uploadDirectory}/${model.user.username}" onChange="validateTarget('${model.hostOS}');" validation="required path" />
                        </span>
                        <span id="uploadunzip" class="ui-helper-hidden">
                            <label for="unzip"><fmt:message key="more.upload.unzip"/></label>
                            <input type="checkbox" id="unzip" name="unzip"/>
                        </span>
                    </td>
                    <td>
                        <span id="uploadconfirm" class="ui-helper-hidden"></span>
                        <button id="uploadback" onClick="switchUploadStep('prev')" class="ui-icon-triangle-1-w ui-icon-primary ui-helper-hidden"><fmt:message key="common.back"/></button>
                        <button id="uploadnext" onClick="switchUploadStep('next')" class="ui-icon-triangle-1-e ui-icon-secondary ui-helper-hidden"><fmt:message key="common.next"/></button>
                        <button id="uploadsubmit" onClick="verifyUploadFile()" class="ui-icon-arrowthickstop-1-n ui-icon-primary ui-helper-hidden"><fmt:message key='more.upload.ok'/></button>
                        <button type="reset" id="uploadcancel" onClick="cancelFileUpload()" class="ui-icon-cancel ui-icon-primary"><fmt:message key='common.cancel'/></button>
                    </td>
                </tr>
            </table>
        </form>
        </div>
    </span>
</div>