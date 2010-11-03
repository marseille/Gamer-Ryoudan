/*
*	Class: fileUploader
*	Use: Upload multiple files the jQuery way
*	Author: Michael Laniba (http://pixelcone.com)
*	Version: 1.0
*/

(function($) {
	$.fileUploader = {version: '1.0'};
	$.fn.fileUploader = function(config){
		
		config = $.extend({}, {
			imageLoader: '',
			buttonUpload: '#pxUpload',
			buttonClear: '#pxClear',
			successOutput: 'File Uploaded',
			errorOutput: 'Failed',
			inputName: 'userfile',
			inputSize: 30,
			allowedExtension: 'jpg|jpeg|gif|png'
		}, config);
		
		var itr = 0; //number of files to uploaded
		
    function upload_image() {      
      $('#px_button input').attr("disabled","disabled");
      $("#pxupload_form form").each(function(){
        e = $(this);
        var id = "#" + $(e).attr("id");
        var input_id = id + "_input";
        var input_val = $(input_id).val();
        if (input_val != ""){
          $(id + "_text .status").text("Uploading...");
          $(id + "_text").css("background-color", "#FFF0E1");
          $(id + "_text .loader").show();
          $(id + "_text .close").hide();
          $(id).submit();            
          $(id +"_frame").load(function(){
            $(id + "_text .loader").hide();
            up_output = $(this).contents().find("#output").text();              
            if (up_output == "success"){
              $(id + "_text").css("background-color", "#F0F8FF");
              up_output = config.successOutput;
            }else{                
              //$(id + "_text").css("background-color", "#FF0000");
              //up_output = config.errorOutput;                
            }
            up_output += '<br />' + $(this).contents().find("#message").text();
            $(id + "_text .status").html(up_output);              
            $("#px_display").empty()
            $("#px_display").append("<label class=success_label>uploaded!</label><br /><br />")
            //$(e).remove(); <-- removes browse field? why would you do this..?							
            //$(config.buttonUpload).removeAttr("disabled");
          });
        }
      });			
    }
    $(".upload_image").click(function(){
			
		});
    
		//public function
		$.fileUploader.change = function(e){
			var fname = px.validateFile( $(e).val() );
			if (fname == -1){
				alert ("Invalid file!");
				$(e).val("");
				return false;
			}
			$('#px_button input').removeAttr("disabled");
			var imageLoader = '';
			if ($.trim(config.imageLoader) != ''){
				imageLoader = '<img src="'+ config.imageLoader +'" alt="uploader" />';
			}
			var display = '<div class="uploadData" id="pxupload'+ itr +'_text" title="pxupload'+ itr +'">' + 
				'<div class="close">&nbsp;</div>' +
				'<span class="fname">'+ fname +'</span>' +
				'<span class="loader" style="display:none">'+ imageLoader +'</span>' +
				'<div class="status">Pending...</div></div>';
        
        $("#px_display").empty()
        $("#px_display").append(display);
        px.appendForm();
        $(e).hide();        
        upload_image()
		}				
		
		$(".close").live("click", function(){
			var id = "#" + $(this).parent().attr("title");
			$(id+"_frame").remove();
			$(id).remove();
			$(id+"_text").fadeOut("slow",function(){
				$(this).remove();
			});
			return false;
		});
		
		$(config.buttonClear).click(function(){
			$("#px_display").fadeOut("slow",function(){
				$("#px_display").html("");
				$("#pxupload_form").html("");
				itr = 0;
				px.appendForm();
				$('#px_button input').attr("disabled","disabled");
				$(this).show();
			});
		});
		
		//private function
		var px = {
			init: function(e){
				var form = $(e).parents('form');
				px.formAction = $(form).attr('action');
				$(form).before(' \
					<div id="pxupload_form"></div> \
					<div id="px_display"></div> \
					<div id="px_button"></div> \
				');
				$(config.buttonUpload+','+config.buttonClear).appendTo('#px_button');
				if ( $(e).attr('name') != '' ){
					config.inputName = $(e).attr('name');
				}
				if ( $(e).attr('size') != '' ){
					config.inputSize = $(e).attr('size');
				}
				$(form).hide();
				this.appendForm();
			},
			appendForm: function(){
				itr++;
				var formId = "pxupload" + itr;
				var iframeId = "pxupload" + itr + "_frame";
				var inputId = "pxupload" + itr + "_input";
				var contents = '<form method="post" id="'+ formId +'" action="'+ px.formAction +'" enctype="multipart/form-data" target="'+ iframeId +'">' +
				'<input type="file" name="'+ config.inputName +'" id="'+ inputId +'" class="pxupload" size="'+ config.inputSize +'" onchange="$.fileUploader.change(this);" />' +
				'</form>' + 
				'<iframe id="'+ iframeId +'" name="'+ iframeId +'" src="about:blank" style="display:none"></iframe>';
				
				$("#pxupload_form").append( contents );
			},
			validateFile: function(file) {
				if (file.indexOf('/') > -1){
					file = file.substring(file.lastIndexOf('/') + 1);
				}else if (file.indexOf('\\') > -1){
					file = file.substring(file.lastIndexOf('\\') + 1);
				}
				//var extensions = /(.jpg|.jpeg|.gif|.png)$/i;
				var extensions = new RegExp(config.allowedExtension + '$', 'i');
				if (extensions.test(file)){
					return file;
				} else {
					return -1;
				}
			}
		}
		
		px.init(this);
		
		return this;
	}
})(jQuery);