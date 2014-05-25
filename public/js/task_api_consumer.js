function TaskCtrl($scope, $http) {

	// map init 

    $http.get('api/tasks/').
        success(function(data) {
            $scope.tasks = data;
        });


    $scope.retrieveTask = function(taskId) {

	    $http.get('api/tasks/' + taskId).
		success(function(data) {
			$scope.current_task = data;

			$('#get_task_modal').bind("close", function() { 
			})

			$('#get_task_modal').foundation('reveal', 'open');
	    	$scope.current_task = data;
	});
     }

    $scope.updateTask = function(taskId) {
        		$scope.current_task_id = taskId;
        		$('#putpost_task_modal').foundation('reveal', 'open');
				clearTaskToSend();	        	
				$('#putpost_task_modal').bind("close", function() { 
        				$scope.current_task_id = -1;
        			});
    }

    $scope.newTask = function() {
        		$('#put_task_modal').foundation('reveal', 'open');
				clearTaskToSend();	        	
    }

    $scope.submitTask = function() {
         $http({
         method: 'POST',
         url: "api/tasks/" + $scope.current_task_id,
         data: $.param({ data: { "description": $scope.task_desc,
         	"current_location": $scope.task_current,
         	"destination_location": $scope.task_target
         }}),

         headers: {'Content-Type': 'application/x-www-form-urlencoded'}})
         .then(function(){}, function(){
         })
     }

     $scope.submitNewTask = function() {
         $http({
         method: 'PUT',
         url: "api/tasks/",
         data: $.param({ data: { "description": $scope.task_desc,
         	"current_location": $scope.task_current,
         	"destination_location": $scope.task_target
         }}),

         headers: {'Content-Type': 'application/x-www-form-urlencoded'}})
         .then(function(){}, function(){
         });
         $('#put_task_modal').foundation('reveal', 'close');
     }

    function clearTaskToSend(){
		$scope.task_desc = "";
    	$scope.task_target = "";
    	$scope.task_current = ""; 
    }
}