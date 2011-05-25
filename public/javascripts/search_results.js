$(function() {
  $("#add_to_list").attr("checked", false)    
  
  //Add a game to someone's list
  $(".add_to_list_submit").live("click", function(event) {    
    var div_id = "add_" + $(event.target).attr("div_prefix") + "_div"
    var form = {}    
    var game = {}
    $.each($("#"+div_id).children(), function(idx,key) {
      var form_element = (key.localName == "input" || key.localName == "select") && key.className != "add_to_list_submit"
      if(form_element){                
        if(!$(key).attr("game")){
          form[$(key).attr("name")] = $(key).val()
        } else {
          game[$(key).attr("name")] = $(key).attr("value")
        }
      }      
    });        
    Rails.call(Rails.methods["add_game_to_list"], "json", "POST", {"game_information" : form, "game" : game}, function(json) {
      $("#"+div_id+" label.red_text").text(json)
    });
  });
  
  //Add a game to the database request
  $("#add_game_db_submit").live("click", function(event) {    
    Gamer_Ryoudan.show_loader(".saved_db label.red_text")
    var game = Gamer_Ryoudan.form_collect($(event.target).attr("div_id"))
    var add_to_list = $("#add_to_list").attr("checked")
    delete game["add_to_list"]    
    var params = {"game" : game, "add_to_list" : add_to_list}    
    if(add_to_list){
      var game_information = Gamer_Ryoudan.form_collect($(event.target).attr("add_list_div"))
      params["game_information"] = game_information
    }    
    params["load_page"] = true
    Rails.call(Rails.methods["add_game"], "json", "POST", params, function(json) {
      $(".saved_db label.red_text").empty()
      $(".saved_db label.red_text").text(json)
    });
  });
  
  $(".show_hide_add").live("click", function(event) {
    event.preventDefault();    
    var name = $(event.target).attr("name")
    show_hide(name)
  });  
})