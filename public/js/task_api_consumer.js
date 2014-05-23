function TaskCtrl($scope, $http) {
    $http.get('http://localhost:3000/1').
        success(function(data) {
            $scope.task = data;
        });
}