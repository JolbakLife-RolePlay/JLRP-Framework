(() => {

	let FrameworkWrapper = {};
	FrameworkWrapper.MessageSize = 1024;
	FrameworkWrapper.messageId = 0;

	window.SendMessage = function (namespace, type, msg) {

		FrameworkWrapper.messageId = (FrameworkWrapper.messageId < 65535) ? FrameworkWrapper.messageId + 1 : 0;
		const str = JSON.stringify(msg);

		for (let i = 0; i < str.length; i++) {

			let count = 0;
			let chunk = '';

			while (count < FrameworkWrapper.MessageSize && i < str.length) {

				chunk += str[i];

				count++;
				i++;
			}

			i--;

			const data = {
				__type: type,
				id: FrameworkWrapper.messageId,
				chunk: chunk
			}

			if (i == str.length - 1)
				data.end = true;

			$.post('https://' + namespace + '/__chunk', JSON.stringify(data));

		}

	}

})()