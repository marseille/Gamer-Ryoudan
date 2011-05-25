var Gamer_Ryoudan = {
  form_collect : function(div_id) {
    var form = {}    
    var game = ""
    $.each($("#"+div_id).children(), function(idx,key) {
      var form_element = (key.localName == "input" || key.localName == "select")
      form_element = form_element && key.type != "checkbox"
      if(form_element){                
        form[$(key).attr("name")] = $(key).val()        
      }      
    });      
    delete form["commit"]
    return form
  },
  
  show_loader : function(id) {
    $(id).empty()
    $(id).append("<img src=/images/ajax-loader.gif></img>")
  },
  
  hide_loader : function(id) {
    $(id).empty()
  },  
  
  show_hide : function(div_to_show) {      
    if($("#"+div_to_show+"_div").is(":visible")){    
      if($("#"+div_to_show+"_button")) {
        var text =  $("#"+div_to_show+"_button").data("link_text")
        $("#"+div_to_show+"_button").text(text)
      }
      $("#"+div_to_show+"_div").fadeOut("slow")
    } else {    
      if($("#"+div_to_show+"_button")){
        $("#"+div_to_show+"_button").data("link_text", $("#"+div_to_show+"_button").text())
        $("#"+div_to_show+"_button").text("cancel!")
      }
      $("#"+div_to_show+"_div").fadeIn("slow")
    }
  }
}