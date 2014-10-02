/**
 * @author mrdoob / http://mrdoob.com/
 */

THREE.PointerLockControls = function ( camera, selfPlayer ) {

	var scope = this;

	camera.rotation.set( 0, 0, 0 );

	var pitchObject = new THREE.Object3D();
	pitchObject.add( camera );

	var yawObject = new THREE.Object3D();
	yawObject.position.y = 10;
	yawObject.add( pitchObject );

	var moveForward = false;
	var moveBackward = false;
	var moveLeft = false;
	var moveRight = false;

	var isOnObject = false;
	var canJump = false;

	var prevTime = performance.now();

	var velocity = new THREE.Vector3();

	var PI_2 = Math.PI / 2;

	this.forward = true;
	this.back = true;
	this.left = true;
	this.right = true;

	var onMouseMove = function ( event ) {

		if ( scope.enabled === false ) return;

		var movementX = event.movementX || event.mozMovementX || event.webkitMovementX || 0;
		var movementY = event.movementY || event.mozMovementY || event.webkitMovementY || 0;

		yawObject.rotation.y -= movementX * 0.002;
		pitchObject.rotation.x -= movementY * 0.002;

		pitchObject.rotation.x = Math.max( - PI_2, Math.min( PI_2, pitchObject.rotation.x ) );


		var direction = new THREE.Vector3( 0, 0, -1 );
		var rotation = new THREE.Euler( 0, 0, 0, "YXZ" );
		v = new THREE.Vector3();
		rotation.set( pitchObject.rotation.x, yawObject.rotation.y, 0 );
		v.copy( direction ).applyEuler( rotation );

		selfPlayer.updateHands(v, selfPlayer);

	};

	var onKeyDown = function ( event ) {

		switch ( event.keyCode ) {

			case 38: // up
			case 87: // w
				moveForward = true;
				break;

			case 37: // left
			case 65: // a
				moveLeft = true; break;

			case 40: // down
			case 83: // s
				moveBackward = true;
				break;

			case 39: // right
			case 68: // d
				moveRight = true;
				break;

			case 32: // space
				//if ( canJump === true ) velocity.y += 350;
				//canJump = false;
				break;

		}

	};

	var onKeyUp = function ( event ) {

		switch( event.keyCode ) {

			case 38: // up
			case 87: // w
				moveForward = false;
				break;

			case 37: // left
			case 65: // a
				moveLeft = false;
				break;

			case 40: // down
			case 83: // s
				moveBackward = false;
				break;

			case 39: // right
			case 68: // d
				moveRight = false;
				break;

		}

	};

	document.addEventListener( 'mousemove', onMouseMove, false );
	document.addEventListener( 'keydown', onKeyDown, false );
	document.addEventListener( 'keyup', onKeyUp, false );

	this.enabled = false;

	this.getObject = function () {

		return yawObject;

	};

	this.isOnObject = function ( boolean ) {

		isOnObject = boolean;
		canJump = boolean;

	};

	this.getDirection = function() {

		// assumes the camera itself is not rotated

		var direction = new THREE.Vector3( 0, 0, -1 );
		var rotation = new THREE.Euler( 0, 0, 0, "YXZ" );
		v = new THREE.Vector3();

		return function( v ) {

			rotation.set( pitchObject.rotation.x, yawObject.rotation.y, 0 );

			v.copy( direction ).applyEuler( rotation );

			return v;

		}

	}();


	this.getDirectionCart = function() {
		//ignora o y (eixo x)
		// assumes the camera itself is not rotated

		var direction = new THREE.Vector3( 0, 0, -1 );
		var rotation = new THREE.Euler( 0, 0, 0, "YXZ" );
		v = new THREE.Vector3();

		return function( v ) {

			rotation.set( 0, yawObject.rotation.y, 0 );

			v.copy( direction ).applyEuler( rotation );

			return v;

		}

	}();

	this.getDirectionFromCamera = function() {

		// assumes the camera itself is not rotated
		var obj = new THREE.Vector3();
		
		//var direction = new THREE.Vector3( 0, 0, -1 );
		var direction = new THREE.Vector3( 0, 0, 1 );
		var rotation = new THREE.Euler( 0, 0, 0, "YXZ" );
		rotation.set( pitchObject.rotation.x, yawObject.rotation.y, 0 );

		obj.copy( direction ).applyEuler( rotation );
		return obj;
	}
	
	this.update = function () {

		if ( scope.enabled === false ) return;

		var time = performance.now();
		var delta = ( time - prevTime ) / 1000;

		velocity.x -= velocity.x * 10.0 * delta;
		velocity.z -= velocity.z * 10.0 * delta;

		//velocity.y -= 9.8 * 100.0 * delta; // 100.0 = mass

		if ( moveForward && this.forward) velocity.z -= 400.0 * delta;
		if ( moveBackward && this.back) velocity.z += 400.0 * delta;

		if ( moveLeft && this.left) velocity.x -= 400.0 * delta;
		if ( moveRight && this.right) velocity.x += 400.0 * delta;

		if ( isOnObject === true ) {

			velocity.y = Math.max( 0, velocity.y );

		}

		yawObject.translateX( velocity.x * delta );
		yawObject.translateY( velocity.y * delta ); 
		yawObject.translateZ( velocity.z * delta );

		if ( yawObject.position.y < 10 ) {

			velocity.y = 0;
			canJump = true;

		}

		prevTime = time;

	};

};
