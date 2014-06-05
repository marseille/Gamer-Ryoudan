var Rails = {
  
  call : function(url, data_type, method_type, params, success_callback) {
    if(method_type == "POST"){
      params = JSON.stringify(params)
    }
    
    $.ajax({
      "url": url,
      "dataType": data_type,
      "type": method_type,
      "data": params,
      "beforeSend": function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      "success": function(data) { success_callback(data) },
      "error": function (event, XMLHttpRequest, ajaxOptions, thrownError)  {
        
      },
      "processData":"false",
      "contentType":"application/json"
    });    
  },
  
  methods : {"find_game" :                     "/games/find_game",                    
                    "add_game":                       "/games/add_game",
                    "add_game_to_list" :            "/users/add_game_to_list",                
                    "remove_game_from_list":   "/users/remove_game_from_list",
                    "save_attribute" :                "/users/save_attribute"}                    
}