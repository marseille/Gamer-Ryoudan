$(function() { 
  
  //I need to put some sort of notification on the site when an error occurs with the 
  //ajax, otherwise you just see the spinner and think its taking a real long time.
  if($(".search_page_spinner").length == 0) {        
    $("input#search_tag").quickselect({ajax:"/games/search_game/", minChars: 3, width:300, spinner_class:".spinner", named_route: true})  
  } else {    
    $("input#search_tag").quickselect({ajax:"/games/search_game/", minChars: 3, width:300, spinner_class:".search_page_spinner", named_route: true})  
  }
  $("input#search_field").quickselect({ajax:"/games/search_game/", minChars: 3, width:300, spinner_class:"blank", named_route: true})
  
  //Activates the search once a quickselect result has been chosen
//$("input#search_field").live("change", function(event) {
//    $("input.search_button").trigger("click")    
//  });  
  
  $("input#search_tag").keyup(function(event){
    if(event.keyCode == 13){
      $("input.search_tag_button").click();
    }
  });
})


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

//Used an ajax search when you are logged in, the landing page to be exact.
//change this to a jquery bind event
function find_game(field_id) {
  Gamer_Ryoudan.show_loader(".spinner")
  var game = $("#"+field_id).val()
  var url = Rails.methods["find_game"] + "/" + game  + "/" + "home_search" + "/1"
  Rails.call(url, "html", "GET",{}, function(json) {
    $("#search-results").empty()
    $("#search-results").hide()        
    $("#search-results").append(json)    
    $("#search-results").animate({width: 'show', duration : '3000' });
    Gamer_Ryoudan.hide_loader(".spinner")
  });  
}