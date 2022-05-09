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

	Framework.inventoryNotification = function (add, label, count) {
		let notif = '';

		if (add) {
			notif += '+';
		} else {
			notif += '-';
		}

		if (count) {
			notif += count + ' ' + label;
		} else {
			notif += ' ' + label;
		}

		let elem = $('<div>' + notif + '</div>');
		$('#inventory_notifications').append(elem);

		$(elem).delay(3000).fadeOut(1000, function () {
			elem.remove();
		});
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

			case 'inventoryNotification': {
				Framework.inventoryNotification(data.add, data.item, data.count);
			}
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();