$(function() { 
  $("#add_to_list").attr("checked", false)  

  $(".change").live("change", function(event) {
    event.preventDefault()
    event.preventDefault()
    event.preventDefault()
    event.preventDefault()
    console.log("whoa!")
  })
  
  
  $(".add_to_list_submit").live("click", function(event) {    
    var div_id = "add_" + $(event.target).attr("div_prefix") + "_div"
    var form = {}    
    var game = ""
    $.each($("#"+div_id).children(), function(idx,key) {
      var form_element = (key.localName == "input" || key.localName == "select") && key.className != "add_to_list_submit"
      if(form_element){                
        if($(key).attr("name") != "game"){
          form[$(key).attr("name")] = $(key).val()
        } else {
          game = $(key).attr("value")
        }
      }      
    });        
    Rails.call(Rails.methods["add_to_list"], "json", "POST", {"game_information" : form, "game" : game}, function(json) {
      $("#"+div_id+" label.red_text").text(json)
    });
  });
  
  $("#add_game_db_submit").live("click", function(event) {
    var game = Gamer_Ryoudan.form_collect($(event.target).attr("div_id"))
    var add_to_list = $("#add_to_list").attr("checked")
    delete game["add_to_list"]    
    var params = {"game" : game, "add_to_list" : add_to_list}    
    if(add_to_list){
      var game_information = Gamer_Ryoudan.form_collect($(event.target).attr("add_list_div"))
      params["game_information"] = game_information
    }    
    params["load_page"] = true
    Rails.call(Rails.methods["add_to_db"], "json", "POST", params, function(json) {
      $(".saved_db label.red_text").text(json)
    });
  });
  
  $(".show_hide_add").live("click", function(event) {
    event.preventDefault();    
    var name = $(event.target).attr("name")
    show_hide(name)
  });
    
  $(".set_difficulty").live("click", function(event) {    
    set_attribute(event, "difficulty")
  });
  
  $(".set_hours_played").live("click", function(event) {
    set_attribute(event, "hours_played")
  });
  
  $(".set_notes").live("click", function(event) {
    set_attribute(event, "notes")
  });
  
  $(".save_difficulty").live("click", function(event) {    
    check_save_attribute(event, "difficulty")
  });
  
  $(".save_hours_played").live("click", function(event) {
    check_save_attribute(event, "hours_played")
  });
  
  $(".save_notes").live("click", function(event) {
    check_save_attribute(event, "notes")
  });
  
  $(".save_difficulty_shortcut").live("keyup", function(event) {
    check_save_attribute(event, "difficulty")
  });
  
  $(".save_hours_played_shortcut").live("keyup", function(event) {
    check_save_attribute(event, "hours_played")
  });
  
  $(".save_notes_shortcut").live("keyup", function(event) {
    check_save_attribute(event, "notes")
  });
  $("input#search_tag").quickselect({ajax:"/games/search_game/", minChars: 3, width:300})
  $("input#search_field").quickselect({ajax:"/games/search_game/", minChars: 3, width:300})
})


function check_save_attribute(event, field) {
  if(event.type == "keyup" && event.keyCode == 13) {
    save_attribute(event, field)      
  } else if(event.type == "click") {
    save_attribute(event, field)
  }  
}

function set_attribute(event, field) {
  event.preventDefault()  
  var selector_id = $(event.target).attr("selector_id")
  var div_id = selector_id + "_div"  
  var previous = $(event.target).text()  
  $("#"+div_id).data("previous", previous)
  $("#"+div_id).empty()
  if(field != "notes") {
    $("#"+div_id).append("<input class=save_"+field + "_shortcut selector_id ="+selector_id+" id="+selector_id+"_input size=3></input>")
    $("#"+div_id).append("<a href='#' class=save_"+field+"> <img selector_id="+selector_id+" border=0 src=/images/save_icon.png class=image_icon></a>")    
    $("#"+div_id).append("<label > (previously: " + previous + ") </label>")        
  } else {    
    $("#"+div_id).append("<textarea class=save_"+field + "_shortcut selector_id ="+selector_id+" id="+selector_id+"_input></textarea>")          
    $("#"+div_id).append("<a href='#' class=save_"+field+"> <img selector_id="+selector_id+" border=0 src=/images/save_icon.png class=notes_save_icon></a>")    
  }
}

function save_attribute(event, field) {
  event.preventDefault()
  var div_id = $(event.target).attr("selector_id")
  if($("#"+div_id+"_input").val() == ""){    
    var previous = $("#"+div_id+"_div").data("previous")
    $("#"+div_id + "_div").empty()    
    $("#"+div_id + "_div").append("<a href='#' selector_id='"+ div_id +"' class='set_"+field+" red_text'>" + previous + " </a>")      
  } else {
    var new_value = $("#"+div_id+"_input").val()        
    var game = $("#"+div_id+"_div").attr("name")
    Rails.call(Rails.methods["save_attribute"], "json", "POST", {"game":game, "new_value" : new_value, "field" : field}, function(json){
      $("#"+div_id + "_div").empty()      
      var new_value_html = get_new_value_html(field,div_id, json)      
      $("#"+div_id + "_div").append(new_value_html)
    });
  }
}

function get_new_value_html(field,div_id,json) {  
  return "<a href='#' selector_id="+ div_id +" class=set_"+field+" left_align>"+json+"</a>"
}

function show_hide(div_to_show) {    
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

//change this to a jquery bind event
function find_game(field_id) {
  var game = $("#"+field_id).val()
  Rails.call(Rails.methods["find_game"], "html", "GET", {search_tag : game, home_search : "true"}, function(json) {
    $("#search-results").empty()
    $("#search-results").hide()        
    $("#search-results").append(json)    
    $("#search-results").animate({width: 'show', duration : '3000' });
  });  
}