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

function saveData() {

	var xmlDoc = createXmlDocument();

	rootNode = xmlDoc.createElement('root');
	xmlDoc.appendChild(rootNode);

	//xmlDoc = xmlDoc.createElement ("root");
	// document.createElement('root');

	var combos = document.getElementsByName('PrCombo');

	for (var i = 0; i < combos.length; i++) {
		if (!combos[i].options[combos[i].selectedIndex].defaultSelected) {
			var AzsNode = xmlDoc.createElement('azs');

			AzsNode.setAttribute('id', combos[i].id);

			AzsProperties = '';
			if (combos[i].value == 1)
				AzsProperties = 'OIL_PRICES_EXPORT_DISABLE';

			if (AzsProperties != '')
				AzsNode.setAttribute('properties', AzsProperties);

			rootNode.appendChild(AzsNode);
		}
	}

	var prices = document.getElementsByName('PrPrice');
	for (var i = 0; i < prices.length; i++) {
		if (prices[i].value != prices[i].defaultValue) {
			var PriceNode = xmlDoc.createElement('price');
			PriceNode.setAttribute('azs_id', prices[i].parentNode.parentNode.id);
			PriceNode.setAttribute('tov_id', prices[i].id);

			SetNodeText(PriceNode, prices[i].value);
			rootNode.appendChild(PriceNode);
		}
	}

	document.getElementById('submitData').value = getXmlDocumentString(xmlDoc);
}

function ControlChange() {
	
	$('#btReset').prop('disabled', false);
	$('#btSubmit').prop('disabled', false);
	
};

function formReset(bt) {
	$(bt).parents('form:first')[0].reset();
	
	$('#btReset').prop('disabled', true);
	$('#btSubmit').prop('disabled', true);
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
		ControlChange();
}
