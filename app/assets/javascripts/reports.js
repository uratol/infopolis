var ready;
ready = function() {

	$('form').submit(function(event) {
	});

};

$(document).ready(ready);
$(document).on('page:load', ready);

function createXmlDocument() {
	var ret;
	if (document.implementation && document.implementation.createDocument) {
		ret = document.implementation.createDocument('', '', null);
	} else {
		ret = new ActiveXObject('MSXML2.DomDocument');
	};
	return ret;
};

function getXmlDocumentString(xmlDoc) {
	if (document.implementation && document.implementation.createDocument) {
		return (new XMLSerializer().serializeToString(xmlDoc));
	} else {
		return xmlDoc.xml;
	}
}

function SetNodeText(node, value) {

	node.appendChild(node.ownerDocument.createTextNode(value));
}

function pricesSubmit(form) {

	var xmlDoc = createXmlDocument();

	rootNode = xmlDoc.createElement('root');
	xmlDoc.appendChild(rootNode);

	//xmlDoc = xmlDoc.createElement ("root");
	// document.createElement('root');

	radios = $(form).find(':radio:checked');
	for (var i = 0; i < radios.length; i++) {
		if (radios[i].checked != radios[i].defaultChecked) {
			var AzsNode = xmlDoc.createElement('azs');

			AzsNode.setAttribute('id', radios[i].name);

			AzsProperties = '';
			if (radios[i].value == 'from_pfs')
				AzsProperties = 'OIL_PRICES_EXPORT_DISABLE';

			if (AzsProperties != '')
				AzsNode.setAttribute('properties', AzsProperties);

			rootNode.appendChild(AzsNode);

		}
	}

	var prices = $(form).find('.number-grid-input');
	for (var i = 0; i < prices.length; i++) {
		if (prices[i].value != prices[i].defaultValue) {
			var PriceNode = xmlDoc.createElement('price');
			PriceNode.setAttribute('azs_id', prices[i].parentNode.parentNode.id);
			PriceNode.setAttribute('tov_id', prices[i].id);

			SetNodeText(PriceNode, prices[i].value);
			rootNode.appendChild(PriceNode);
		}
	}

	$(form).find('#submitData')[0].value = getXmlDocumentString(xmlDoc);

	$(form).find(':radio').prop('disabled', true);
}

function pricesControlChange() {
	$('input[type=submit]').add('input[type=reset]').prop('disabled', false);
};

function pricesReset(form) {
	form.reset();

	$('input[type=submit]').add('input[type=reset]').prop('disabled', true);
}

function numberValidate(evt) {
	var theEvent = evt || window.event;
	var key = theEvent.keyCode || theEvent.which;
	key = String.fromCharCode(key);
	var regex = /[0-9]|[\.,]/;
	if (!regex.test(key)) {
		theEvent.returnValue = false;
		if (theEvent.preventDefault)
			theEvent.preventDefault();
	} else
		pricesControlChange();
}

