function MapCtrl($scope, $http) {

	$scope.task_id = ""

    function exitOnUndefined(){
        if ($scope.task_id === "")
            return;
    }

    var updateLocation = function(){
            if (navigator.geolocation){

                navigator.geolocation.getCurrentPosition(function(position){
                    var pos = [position.coords.latitude, position.coords.longitude];
                    map.setView(pos, 13);
                    L.marker(pos).addTo(map);
                    $scope.ws.send(position.coords.latitude + ", " + position.coords.longitude);
                });
            }
        }

    $scope.switchToSender = function(){
        exitOnUndefined();

        $scope.timerHndl = window.setInterval(updateLocation, 3000);
        var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
        $scope.ws = new Socket("wss://protected-headland-4566.herokuapp.com:8080/" + $scope.task_id, "ws_sender");  
    }

    $scope.switchToReciever = function(){
        
        exitOnUndefined();

        window.clearInterval($scope.timerHndl);

        var Socket = "MozWebSocket" in window ? MozWebSocket : WebSocket;
        $scope.ws = new Socket("wss://protected-headland-4566.herokuapp.com:8080/" + $scope.task_id, "ws_reciever"); 

        $scope.ws.onmessage = function(evt) { 
            data = evt.data
            if (data != null){
                console.log ("recieved location" + evt.data);
                position = data.split(',')
                map.setView(position, 13);  
                L.marker(position).addTo(map);  
            }
        }    
    }

}


