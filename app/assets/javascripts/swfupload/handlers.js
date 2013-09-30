function fileQueued(file) {
  try {
    this.customSettings.tdFilesQueued.innerHTML = this.getStats().files_queued;
  } catch (ex) {
    this.debug(ex);
  }
}

function fileDialogComplete(numFilesSelected, numFilesQueued) {
  try {
    if (numFilesSelected > 0) {
      document.getElementById(this.customSettings.cancelButtonId).disabled = false;
    }
    this.startUpload();
  } catch (ex) {
    this.debug(ex);
  }
}

function uploadStart(file) {
  try {
    this.customSettings.progressCount = 0;
    updateDisplay.call(this, file);
  }
  catch (ex) {
    this.debug(ex);
  }
}

function cancelUpload(file_id, trigger_error_event) {
  if (this.getStats().files_queued === 0) {
    document.getElementById(this.customSettings.cancelButtonId).disabled = true;
    document.getElementById(this.customSettings.progressBarId).setAttribute('style', "width: 0%;");
  }
}

function uploadProgress(file, bytesLoaded, bytesTotal) {
  try {
    this.customSettings.progressCount++;
    updateDisplay.call(this, file);
  } catch (ex) {
    this.debug(ex);
  }
}

function uploadSuccess(file, serverData) {
  try {
    var data = {
      name: file.name,
      size: file.size,
      type: file.type,
      response: serverData
    }
    $.ajax({
        type: "POST",
        url: '/contents.json',
        data: data,
        async: false,
    });
    updateDisplay.call(this, file);
  } catch (ex) {
    alert(ex.message);
    this.debug(ex);
  }
}

function uploadComplete(file) {
  if (this.getStats().files_queued === 0) {
    document.getElementById(this.customSettings.cancelButtonId).disabled = true;
  }
  this.customSettings.tdFilesQueued.innerHTML = this.getStats().files_queued;
  this.customSettings.tdFilesUploaded.innerHTML = this.getStats().successful_uploads;
  this.customSettings.tdErrors.innerHTML = this.getStats().upload_errors;
}

function updateDisplay(file) {
  this.customSettings.tdCurrentSpeed.innerHTML = SWFUpload.speed.formatBPS(file.currentSpeed);
  this.customSettings.tdAverageSpeed.innerHTML = SWFUpload.speed.formatBPS(file.averageSpeed);
  this.customSettings.tdMovingAverageSpeed.innerHTML = SWFUpload.speed.formatBPS(file.movingAverageSpeed);
  this.customSettings.tdTimeRemaining.innerHTML = SWFUpload.speed.formatTime(file.timeRemaining);
  this.customSettings.tdTimeElapsed.innerHTML = SWFUpload.speed.formatTime(file.timeElapsed);
  this.customSettings.tdPercentUploaded.innerHTML = SWFUpload.speed.formatPercent(file.percentUploaded);
  this.customSettings.tdSizeUploaded.innerHTML = SWFUpload.speed.formatBytes(file.sizeUploaded);
  this.customSettings.tdProgressEventCount.innerHTML = this.customSettings.progressCount;

  var percent = parseInt(SWFUpload.speed.formatPercent(file.percentUploaded), 10);
  document.getElementById(this.customSettings.progressBarId).setAttribute('style', "width: " + percent + "%;");
}
