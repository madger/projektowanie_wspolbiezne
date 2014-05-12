<?php

	if(isset($_POST['request']) && !empty($_POST['request'])){
		$con = mysqli_connect("localhost","root","","projektowanie_wspolbiezne");
		mysqli_query($con, 'SET NAMES utf8');
		switch($_POST['request']){
			case 'login' :
				login();
				break;
			case 'getDepartaments' :
				getDepartaments();
				break;
			case 'getUsers' :
				getUsers();
				break;	
			case 'getTasks' :
				getTasks();
				break;
			case 'addTask' :
				addTask($_POST['name'], $_POST['user_id'], $_POST['departament_id'], $_POST['description']);
				break;
			case 'updateTaskStatus' :
				if(isset($_POST['id']) && !empty($_POST['id']) && isset($_POST['status']) && !empty($_POST['status'])){
					updateTaskStatus($_POST['id'], $_POST['status']);
				}
				break;
		}
		mysqli_close($con);
	}

	function login(){
		global $con;
		if(isset($_POST['username']) && !empty($_POST['username']) && isset($_POST['password']) && !empty($_POST['password'])){
			$result = mysqli_query($con, "SELECT * FROM Users WHERE username='".$_POST['username']."' AND password='".$_POST['password']."'");
			$user = new stdClass();
			while($row = mysqli_fetch_array($result)) {
				$user->id = $row['id'];
				$user->username = $row['username'];
				$user->first_name = $row['first_name'];
				$user->last_name = $row['last_name'];
				$user->email = $row['email'];
				$user->created = $row['created'];
			}
			echo json_encode($user);
		}
	}

	function getDepartaments(){
		global $con;
		$result = mysqli_query($con, "SELECT * FROM departaments");
		$departaments = array();
		while($row = mysqli_fetch_array($result)) {
			$departament = new stdClass();
			$departament->id = $row['id'];
			$departament->name = $row['name'];
			$departament->created = $row['created'];
			array_push($departaments, $departament);
		}
		echo json_encode($departaments);
	}

	function getUsers(){
		global $con;
		$result = mysqli_query($con, "SELECT * FROM users");
		$users = array();
		while($row = mysqli_fetch_array($result)) {
			$user = new stdClass();
			$user->id = $row['id'];
			$user->username = $row['username'];
			$user->first_name = $row['first_name'];
			$user->last_name = $row['last_name'];
			$user->email = $row['email'];
			$user->created = $row['created'];
			array_push($users, $user);
		}
		echo json_encode($users);
	}

	function getTasks(){
		global $con;
		$result = mysqli_query($con, "SELECT * FROM tasks");
		$tasks = array();
		while($row = mysqli_fetch_array($result)) {
			$task = new stdClass();
			$task->id = $row['id'];
			$task->user_id = $row['user_id'];
			$task->departament_id = $row['departament_id'];
			$task->name = $row['name'];
			$task->description = $row['description'];
			$task->status = $row['status'];
			$task->created = $row['created'];
			$task->subtasks = getSubtasks($row['id']);
			$task->main = getMain($row['id']);
			$task->dependents = getDependent($row['id']);
			array_push($tasks, $task);
		}
		echo json_encode($tasks);
	}

	function getSubtasks($id){
		global $con;
		$result = mysqli_query($con, "SELECT * FROM tasks, tasks_subtasks WHERE task_id=".$id." AND id=subtask_id");
		$tasks = array();
		while($row = mysqli_fetch_array($result)) {
			$task = new stdClass();
			$task->id = $row['id'];
			$task->user_id = $row['user_id'];
			$task->departament_id = $row['departament_id'];
			$task->name = $row['name'];
			$task->description = $row['description'];
			$task->status = $row['status'];
			$task->created = $row['created'];
			array_push($tasks, $task);
		}
		return $tasks;
	}

	function getMain($id){
		global $con;
		$result = mysqli_query($con, "SELECT * FROM tasks, tasks_subtasks WHERE subtask_id=".$id." AND id=task_id");
		$tasks = array();
		while($row = mysqli_fetch_array($result)) {
			$task = new stdClass();
			$task->id = $row['id'];
			$task->user_id = $row['user_id'];
			$task->departament_id = $row['departament_id'];
			$task->name = $row['name'];
			$task->description = $row['description'];
			$task->status = $row['status'];
			$task->created = $row['created'];
			array_push($tasks, $task);
		}
		return $tasks;
	}

	function getDependent($id){
		global $con;
		$result = mysqli_query($con, "SELECT * FROM tasks, tasks_dependent_tasks WHERE dependent_task_id=".$id." AND id=task_id");
		$tasks = array();
		while($row = mysqli_fetch_array($result)) {
			$task = new stdClass();
			$task->id = $row['id'];
			$task->user_id = $row['user_id'];
			$task->departament_id = $row['departament_id'];
			$task->name = $row['name'];
			$task->description = $row['description'];
			$task->status = $row['status'];
			$task->created = $row['created'];
			array_push($tasks, $task);
		}
		return $tasks;
	}

	function getDependentTasks($id){
		global $con;
		$result = mysqli_query($con, "SELECT * FROM tasks, tasks_dependent_tasks WHERE task_id=".$id." AND id=dependent_task_id");
		$tasks = array();
		while($row = mysqli_fetch_array($result)) {
			$task = new stdClass();
			$task->id = $row['id'];
			$task->user_id = $row['user_id'];
			$task->departament_id = $row['departament_id'];
			$task->name = $row['name'];
			$task->description = $row['description'];
			$task->status = $row['status'];
			$task->created = $row['created'];
			array_push($tasks, $task);
		}
		return $tasks;
	}

	function updateSubtasks($id, $status){
		$subtasks = getSubtasks($id);
		if(sizeof($subtasks)){
			reset($subtasks);
			while (list($key, $val) = each($subtasks)) {
				$new_subtasks = getSubtasks($val->id);
				if(sizeof($new_subtasks)){
					updateSubtasks($new_subtasks, $val->status);
				} else {
					if($val->status == 1){
						updateTaskStatus($val->id, 2);
					}
				}
			}
		} else {
			if($status == 1){
				updateTaskStatus($id, 2);
			}
		}
	}

	function updateTaskStatus($id, $status){
		global $con;
		mysqli_query($con, "UPDATE tasks SET status=".$status." WHERE id=".$id."");
		$main = getMain($id);
		if(isset($main[0])){
			$main = $main[0];
			$subtasks = getSubtasks($main->id);
			$min_status = $subtasks[0]->status;
			reset($subtasks);
			while (list($key, $val) = each($subtasks)) {
			    if($val->status < $min_status) {
			    	$min_status = $val->status;
			    }
			}
			if($min_status != $main->status){
				updateTaskStatus($main->id, $min_status);
			}
		}
		if($status == 5){
			$dependents = getDependentTasks($id);
			reset($dependents);
			while (list($key, $val) = each($dependents)) {
				updateSubtasks($val->id, $val->status);
			}
		}
	}

	function addTask($name, $user_id, $departament_id, $description){
		global $con;
		mysqli_query($con, "INSERT INTO tasks (name, user_id, departament_id, description) VALUES ('".$name."', '".$user_id."', '".$departament_id."', '".$description."')");
	}

?>