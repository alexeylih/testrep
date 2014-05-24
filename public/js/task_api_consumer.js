function TaskCtrl($scope, $http) {

	// map init 
	var map = L.map('map').setView([51.505, -0.09], 13);

		L.tileLayer('https://{s}.tiles.mapbox.com/v3/{id}/{z}/{x}/{y}.png', {
			maxZoom: 18,
			attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, ' +
				'<a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
				'Imagery © <a href="http://mapbox.com">Mapbox</a>',
			id: 'examples.map-i86knfo3'
		}).addTo(map);

    $http.get('api/tasks/').
        success(function(data) {
            $scope.tasks = data;
        });


    $scope.retrieveTask = function(taskId) {
    	    $http.get('api/tasks/' + taskId).
        	success(function(data) {

        		$scope.current_task = data;
            	var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
				var ws = new Socket("ws://localhost:8080/" + taskId, "ws_reciever");	

        		ws.onmessage = function(evt) { 
	            	if (data.current_location != null){
	            		position = data.current_location.split(',')
	            		console.log(position);
	            		// if ((position[0] === 'number' )
	            		// 	&& (position[1] === 'number')
	            		// 	 && (position.length == 2)){
	            			map.setView(position, 13);		
	            		//}
	            	}
            	}

        		$('#get_task_modal').bind("close", function() { 
        			console.log(ws);
        			ws.close();
        			console.log("close"); })


        		$('#get_task_modal').foundation('reveal', 'open');

            	$scope.current_task = data;
        });
     }

    $scope.updateTask = function(taskId) {
        	$('#post_task_modal').foundation('reveal', 'open');
    }



    // $scope.submit = function() {
    //     $http({
    //     method: 'POST',
    //     url: "feeds/",
    //     data: $.param({title: "jecky", url: this.urlToAdd}),
    //     headers: {'Content-Type': 'application/x-www-form-urlencoded'}})
    //     .then(function(){}, function(){
    //         alert("fail");
    //     })
    // };
}