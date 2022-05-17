(() => {

	Framework = {};
	Framework.HUDElements = [];

	Framework.setHUDDisplay = function (opacity) {
		$('#hud').css('opacity', opacity);
	};

	Framework.insertHUDElement = function (name, index, priority, html, data) {
		Framework.HUDElements.push({
			name: name,
			index: index,
			priority: priority,
			html: html,
			data: data
		});

		Framework.HUDElements.sort((a, b) => {
			return a.index - b.index || b.priority - a.priority;
		});
	};

	Framework.updateHUDElement = function (name, data) {
		for (let i = 0; i < Framework.HUDElements.length; i++) {
			if (Framework.HUDElements[i].name == name) {
				Framework.HUDElements[i].data = data;
			}
		}

		Framework.refreshHUD();
	};

	Framework.deleteHUDElement = function (name) {
		for (let i = 0; i < Framework.HUDElements.length; i++) {
			if (Framework.HUDElements[i].name == name) {
				Framework.HUDElements.splice(i, 1);
			}
		}

		Framework.refreshHUD();
	};

	Framework.resetHUDElements = function () {
		Framework.HUDElements = [];
		Framework.refreshHUD();
	};

	Framework.refreshHUD = function () {
		$('#hud').html('');

		for (let i = 0; i < Framework.HUDElements.length; i++) {
			let html = Mustache.render(Framework.HUDElements[i].html, Framework.HUDElements[i].data);
			$('#hud').append(html);
		}
	};

	Framework.showNotification = function (type, message, length) {
		$(".notificationText").text(message);

		if (type === "info") {
            document.getElementById("notificationInfo").style.display = "block";       
        } else if (type === "error") {
            document.getElementById("notificationError").style.display = "block";
        } else if (type === "success") {
            document.getElementById("notificationSuccess").style.display = "block";
        }
		timeoutNotification();
		
		function timeoutNotification() {
			setTimeout(function () {
				document.getElementById("notificationInfo").style.display = "none";
				document.getElementById("notificationError").style.display = "none";
				document.getElementById("notificationSuccess").style.display = "none";
			}, length)
		}
	};

	Framework.progressBar = function (message, length) {
		$(".progressBarText").text(message);
		document.getElementById("progressBar").style.display = "block";
		const start = new Date();
		const maxTime = length;
		const timeoutValue = Math.floor(maxTime/100);
		updateProgressBarAnimation();

		function updateProgressBarAnimation() {
			const now = new Date();
			const timeoutDiff = now.getTime() - start.getTime();
			const progress = Math.round((timeoutDiff/maxTime)*100);
			if (progress <= 100) {
				updateProgressBar(progress);
				setTimeout(updateProgressBarAnimation, timeoutValue);
			} else {
				document.getElementById('progressBar').style.display = "none";
			}
		}

		function updateProgressBar(progress) {
			$("#progressBarLine").css("width", progress + "%");
		}	
	};

	Framework.textUI = function (action, type, message) {
		$(".textUIText").text(message);
		if (todo === "show") {
            if (type === "info") {
                document.getElementById("textUIInfo").style.display = "block";
            } else if (type === "error") {
                document.getElementById("textUIError").style.display = "block";
            } else if (type === "success") {
                document.getElementById("textUISuccess").style.display = "block";
            }
        } else if (todo === "hide") {
            document.getElementById("textUIInfo").style.display = "none";
            document.getElementById("textUIError").style.display = "none";
            document.getElementById("textUISuccess").style.display = "none";
        }
	};

	window.onData = (data) => {
		switch (data.action) {
			case 'setHUDDisplay': {
				Framework.setHUDDisplay(data.opacity);
				break;
			}

			case 'insertHUDElement': {
				Framework.insertHUDElement(data.name, data.index, data.priority, data.html, data.data);
				break;
			}

			case 'updateHUDElement': {
				Framework.updateHUDElement(data.name, data.data);
				break;
			}

			case 'deleteHUDElement': {
				Framework.deleteHUDElement(data.name);
				break;
			}

			case 'resetHUDElements': {
				Framework.resetHUDElements();
				break;
			}
			
			case 'showNotification': {
				Framework.showNotification(data.type, data.message, data.length);
			}
			
			case 'progressBar': {
				Framework.progressBar(data.message, data.length);
			}

			case 'textUI': {
				Framework.textUI(data.todo, data.type, data.message);
			}
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();