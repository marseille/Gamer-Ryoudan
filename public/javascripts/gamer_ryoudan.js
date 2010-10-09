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
  }
}