        <div class="bgcolor1" id="uploadFile" style="display:none">
            <div style="width:80%;margin:0px auto">
                <form name="uploadFileForm" method="post" enctype="multipart/form-data" action="upload.view"><!-- onSubmit="displayUploadResults()">-->
                    <input id="uploadsource" type="file" id="file" name="file" size="40" onChange="validateSource()"/>
                    <span id="uploaddirectory" style="display:none;">
                        <fmt:message key="more.upload.target"/> <input type="text" id="dir" name="dir" size="50" value="${model.uploadDirectory}/${model.user.username}" onChange="validateTarget();"/>
                    </span>
                    <span id="uploadunzip" style="display:none;">
                        <input id="unzip" name="unzip" type="checkbox" class="checkbox"/>
                        <label for="unzip"><fmt:message key="more.upload.unzip"/></label>
                    </span>
                    <span id="uploadconfirm" style="display:none;"></span>
                    <input id="uploadback" type="button" value="Back" onClick="switchUploadStep('prev')" style="display:none;"/>
                    <input id="uploadnext" type="button" value="Next" onClick="switchUploadStep('next')" style="display:none;"/>
                    <input id="uploadsubmit" type="button" value="<fmt:message key='more.upload.ok'/>" onClick="verifyUploadFile()" style="display:none;"/>
                    <input id="uploadcancel" type="reset" value="Cancel" onClick="cancelUploadFile()"/>
                </form>

                <p class="detail" id="progressText"/>

                <div id="progressBar">
                    <div id="progressBarContent"/></div>
                </div>
            </div>
        </div>