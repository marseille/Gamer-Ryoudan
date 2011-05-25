$(function(){
  $('#avatar_input').fileUploader({            
    buttonUpload: '#pxUpload',      
    buttonClear: '#pxClear',
    successOutput: 'File Uploaded',      
    inputName: 'avatar_input',
    inputSize: 20,
    allowedExtension: 'jpg|jpeg|png|gif'
  });
});