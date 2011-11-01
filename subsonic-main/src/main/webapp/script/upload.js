var zipfile = false;
var uploadstep = 1;

function toggleUploadFile() {
    jQuery("#uploadFile").toggle("blind");
}

function displayUploadResults() {
// TODO    window.open('upload.view', 'results', 'width=200,height=100,resizable=no,scrollbars=no,toolbar=no,status=no');
}

function checkIfZip(path) {
    zipfile = (path.slice(-3) == "zip")
    $("unzip").checked = zipfile;
}

function validateSource() {
    var filepath = document.uploadFileForm.file.value;
    if (filepath == "") { $("uploadnext").hide(); return; }
    if (!validFilePath(filepath)) { alert("Error: the file path seems invalid."); return; } // Should theoretically never appear...
    checkIfZip(filepath);
    $("uploadnext").show();
}

function validateTarget() {
    var dirpath = document.uploadFileForm.dir.value;
    if (dirpath == "") { $("uploadnext").hide(); return; }
    if (!validFilePath(dirpath, "${model.hostOS}")) { alert("Error: the file path seems invalid."); return; }
    $("uploadnext").show()        
}

function switchUploadStep(step) {
    switch (step) {
        case "next":
            uploadstep++;
            if ((uploadstep == 3) && (!zipfile)) uploadstep++
            break;
        case "prev":
            uploadstep--;
            if ((uploadstep == 3) && (!zipfile)) uploadstep--
            break;
        default:
            uploadstep = 1;
            break;
    }

    switch (uploadstep) {
        case 1: $("uploadsource").show(); $("uploaddirectory").hide(); $("uploadback").hide(); break;
        case 2: $("uploadsource").hide(); $("uploaddirectory").show(); $("uploadback").show(); $("uploadunzip").hide(); $("uploadconfirm").hide(); $("uploadsubmit").hide(); $("uploadnext").show(); break;
        case 3: $("uploadsubmit").hide(); $("uploaddirectory").hide(); $("uploadnext").show(); $("uploadunzip").show(); $("uploadconfirm").hide(); break;
        case 4: $("uploadsubmit").show(); $("uploaddirectory").hide(); $("uploadnext").hide(); $("uploadunzip").hide(); $("uploadconfirm").show();
                $("uploadconfirm").innerHTML = "Upload [" + document.uploadFileForm.file.value.replace(/^.*\\/, '') + "] to directory [" + document.uploadFileForm.dir.value + "] ?<br>";
                break;
    }
    if (uploadstep > 4) uploadstep = 1;
}

function validFilePath(path, type) {
    // Basic validation to make sure "/" are in the right places
    if (!type) type = navigator.platform.toLowerCase();
    if (path == "") return false;
    if (type.slice(0, 3) == "win") {
        if((path.charAt(0) != "\\" && path.charAt(1) != "\\") && (path.charAt(0) != "/" && path.charAt(1) != "/")) {
            switch (true) {
                case (!path.charAt(0).match(/^[a-zA-z]/)): return false; break;
                case (path.charAt(1) == "" ||!path.charAt(1).match(/^[:]/) || !path.charAt(2).match(/^[\/\\]/)): return false; break;
                default: return true;
            }
        }
    } else {
        switch (true) {
            case (path.charAt(0) != "/"): return false; break;
            case (path.charAt(0) == "/" && path.charAt(1) == "/"): return false; break;
            default: return true;
        }
    }
}

function cancelUploadFile() {
    zipfile = 0;
    switchUploadStep();
    toggleUploadFile();
    $("uploaddirectory").hide();
    $("uploadunzip").hide();
    $("uploadsubmit").hide();
    $("uploadconfirm").hide();
    $("uploadback").hide();
    $("uploadnext").hide();
}

function verifyUploadFile() {
    var filepath = document.uploadFileForm.file.value;
    var dirpath = document.uploadFileForm.dir.value;

    // Redundancy check

    // Check for null values
    if (filepath == "" || dirpath == "") return false;

    // Check valid file paths
    if (!validFilePath(filepath)) alert("Error: the file path seems invalid.");
    if (!validFilePath(dirpath, "${model.hostOS}")) alert("Error: the file path seems invalid.");

    $("uploadconfirm").hide();
    $("uploadcancel").hide();
    $("uploadback").hide();
    $("uploadsubmit").hide();
    $("uploadsource").style.visibility = "hidden";
    $("uploaddirectory").style.visibility = "hidden";
    $("uploadunzip").style.visibility = "hidden";
    $("uploadsource").show();
    $("uploaddirectory").show();
    $("uploadunzip").show();
    document.uploadFileForm.submit();
}

function refreshProgress() {
    alert("test");
    transferService.getUploadInfo(updateProgress);
}

function updateProgress(uploadInfo) {
    var progressBar = document.getElementById("progressBar");
    var progressBarContent = document.getElementById("progressBarContent");
    var progressText = document.getElementById("progressText");

    if (uploadInfo.bytesTotal > 0) {
        var percent = Math.ceil((uploadInfo.bytesUploaded / uploadInfo.bytesTotal) * 100);
        var width = parseInt(percent * 3.5) + 'px';
        progressBarContent.style.width = width;
        progressText.innerHTML = percent + "<fmt:message key='more.upload.progress'/>";
        progressBar.style.display = "block";
        progressText.style.display = "block";
        window.setTimeout("refreshProgress()", 1000);
    } else {
        progressBar.style.display = "none";
        progressText.style.display = "none";
        window.setTimeout("refreshProgress()", 5000);
    }
}