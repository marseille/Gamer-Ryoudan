$(function() { 

  //delete a game, clicking on the (x)
  $(".delete_game").live("click", function(event) {
    event.preventDefault();    
    if(event.button == "0") {                  
      var params = {"game_id" : $(event.target).attr("name")}
      Rails.call(Rails.methods["remove_game_from_list"], "html", "POST", params, function(html) {                                        
        $(event.target).parent().parent().fadeOut(1000);
      });
    }
  });
    
  //clicking on the "Edit" link
  $(".edit_tag").live("click", function(event) {
    event.preventDefault();
    var name = $(event.target).attr("name");
    var selector_id = $(event.target).attr("selector_id");
    if(event.button == "0") {
      var html = ['<h2>Edit '+name+'</h2><br />',
                         '<label> Status:</label>',
                         '<select id='+selector_id+'_status_select>',
                            '<option>Campaigns</option>',
                            '<option>Conquests</option>',
                            '<option>Centrum Contentus</option>',
                            '<option>Contrived Crusades</option>',   
                         '</select><br /><br />',
                         '<input class=update_status type=submit value=update selector_id='+selector_id+'></input>']
      $.facebox(html.join(""));
    }
  });  
  
  $(".update_status").live("click", function(event) {
    event.preventDefault();
    if(event.button == "0"){
      var selector_id = $(event.target).attr("selector_id")
      var new_status = $("#"+selector_id+"_status_select").val()           
      var game = $("."+selector_id+"_row").attr("name")      
      Rails.call(Rails.methods["save_attribute"], "json", "POST", {"game" : game, "new_value" : new_status, "field" : "status"}, function(json){
        $(document).trigger('close.facebox')
        location.href = "/game_list/"
      });
    }
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
  if(event.button == "0"){
    var selector_id = $(event.target).attr("selector_id")
    var div_id = selector_id + "_div"  
    var previous = $(event.target).text()  
    $("#"+div_id).data("previous", previous)      
    $("#"+div_id).data("name", $("#"+div_id+" label")[0].textContent)
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
}

function save_attribute(event, field) {
  event.preventDefault()
  var div_id = $(event.target).attr("selector_id")  
  var game = $("#"+div_id+"_div").data("name")  
  if($("#"+div_id+"_input").val() == ""){    
    var previous = $("#"+div_id+"_div").data("previous")    
    $("#"+div_id + "_div").empty()    
    $("#"+div_id + "_div").append("<a href='#' selector_id='"+ div_id +"' class='set_"+field+" red_text'>" + previous + " </a>")      
    $("#"+div_id + "_div").append("<label class='hide'>"+game+"</label>");
  } else {
    var new_value = $("#"+div_id+"_input").val()                
    Rails.call(Rails.methods["save_attribute"], "json", "POST", {"game":game, "new_value" : new_value, "field" : field}, function(json){
      $("#"+div_id + "_div").empty()      
      var new_value_html = get_new_value_html(field,div_id, json)      
      $("#"+div_id + "_div").append(new_value_html)
    });
  }
  
  function get_new_value_html(field,div_id,json) {  
    return "<a href='#' selector_id="+ div_id +" class=set_"+field+" left_align>"+json+"</a>"
  }
}