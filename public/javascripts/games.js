$(function() { 
  $("#add_to_list").attr("checked", false)  

  $(".set_difficulty").live("click", function(event) {
    set_attribute(event, "difficulty")
  });

  $(".set_current_level").live("click", function(event) {
    set_attribute(event, "current_level")
  });
  
  $(".set_hours_played").live("click", function(event) {
    set_attribute(event, "hours_played")
  });
  
  $(".save_difficulty").live("click", function(event) {    
      check_save_attribute(event, "difficulty")
  });
  
  $(".save_current_level").live("click", function(event) {    
    var a = $(event.target).attr("selector_id")
    var max_level = $("#"+a+"_max_level").val()
    $("#"+a+"_div").attr("max_level", max_level)
    check_save_attribute(event, "current_level")
  });
  
  $(".save_hours_played").live("click", function(event) {
    check_save_attribute(event, "hours_played")
  });
  
  $(".save_difficulty_shortcut").live("keyup", function(event) {
    check_save_attribute(event, "difficulty")
  });
  
  $(".save_current_level_shortcut").live("keyup", function(event) {
    if(event.type == "keyup" && event.keyCode == 13) {        
      check_save_attribute(event, "current_level")
    }
  });
  
  $(".save_hours_played_shortcut").live("keyup", function(event) {
    check_save_attribute(event, "hours_played")
  });
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
  if(field == "current_level") $("#"+div_id).data("previous_level", $("#"+div_id).children())    
  $("#"+div_id).empty()
  $("#"+div_id).data("previous", previous)        
  $("#"+div_id).append("<input class=save_"+field + "_shortcut selector_id ="+selector_id+" id="+selector_id+"_input size=3></input>")
  $("#"+selector_id+"_input").focus()
  $("#"+div_id).append("<a href='#' class=save_"+field+"> <img selector_id="+selector_id+" border=0 src=/images/save_icon.png class=image_icon></a>")
  $("#"+div_id).append("<label  class=left_align> (previously: " + previous + ") </label>")  
}

function save_attribute(event, field) {
  event.preventDefault()
  var div_id = $(event.target).attr("selector_id")
  if($("#"+div_id+"_input").val() == ""){    
    var previous = $("#"+div_id+"_div").data("previous")
    $("#"+div_id + "_div").empty()
    var reset_level = $("#"+div_id + "_div").data("previous_level")    
    if(reset_level){
      $.each(reset_level, function(idx,key){$("#"+div_id+"_div").append(key)})      
    } else {
      $("#"+div_id + "_div").append("<a href='#' selector_id="+ div_id +" class=set_"+field+" left_align>" + previous + " </a>")  
    }
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
  if(field == "current_level") {        
    var link = "<a href='#' selector_id="+div_id+" class='set_current_level level_align'>" + json[0] + "</a>"        
    link += "<label class=level_align> / </label>"
    link += "<label id="+div_id+"_max_level class=left_align>"+json[1]+"</label>"    
    return link
  } else {    
    return "<a href='#' selector_id="+ div_id +" class=set_"+field+" left_align>"+json+"</a>"
  }
}

function show_hide() {  
  if($("#add_this_game_to_list").is(":visible")){    
    if($("#add_game_button")) {
      $("#add_game_button").text("add!")
    }
    $("#add_this_game_to_list").fadeOut("slow")
  } else {    
    if($("#add_game_button")){
      $("#add_game_button").text("cancel!")
    }
    $("#add_this_game_to_list").fadeIn("slow")
  }
}

function find_game() {
  var game = $("#search_tag").val()
  Rails.call(Rails.methods["find_game"], "html", "GET", {'search_tag' : game}, function(json) {
    $("#search-results").empty()
    $("#search-results").hide()
    $("#search-results").append("<h3> Search results: </h3>")
    $("#search-results").append(json)    
    $("#search-results").animate({width: 'show', duration : '3000' });
  });  
}