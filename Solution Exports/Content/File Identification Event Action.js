importPackage(java.io);
importClass(java.lang.System);
importClass(java.lang.Integer);
importClass(Packages.com.filenet.api.engine.EventActionHandler);
importClass(Packages.com.filenet.api.util.Id);
importPackage(Packages.com.filenet.api.events);
importPackage(Packages.com.filenet.api.property);
importPackage(Packages.com.filenet.api.exception);
importPackage(Packages.com.filenet.api.core);
importPackage(Packages.com.filenet.api.constants);
importClass(Packages.com.filenet.api.query.SearchSQL);
importClass(Packages.com.filenet.api.query.SearchScope);
importClass(Packages.com.filenet.api.collection.IndependentObjectSet);


function onEvent(event, subscription) {
	// customize to some other string property symbolic name as needed
	var methodname = "[DynamicFileIdentification] ";
	
	var keyIdentifierName = "CO_ReferenceID";
	//var incomeIdentifierName = "MA_NetIncome";
	var os = event.getObjectStore();
	var id = event.get_SourceObjectId();

	// get document's key identifier value and net income which will be transfered into a case property
	var fe1 = new FilterElement(null, null, null, "Name " + keyIdentifierName, null);
	//var fe2 = new FilterElement(null, null, null, "Name " + incomeIdentifierName, null);
	var pf = new PropertyFilter();
	pf.addIncludeProperty(fe1);
	//pf.addIncludeProperty(fe2);
	var doc = Factory.Document.fetchInstance(os, id, pf);
	var identifier = doc.getProperties().get(keyIdentifierName).getStringValue();
	//var income = doc.getProperties().get(incomeIdentifierName).getFloat64Value();

	// find case folder of same key identifier value
	var sqlStr = "SELECT [" + keyIdentifierName + "], [FolderName], [PathName], [CO_ClientName], [Id] FROM [CO_ClientOnboardingRequest] WHERE ([" +
		keyIdentifierName + "] = '" + identifier + "') AND ([CmAcmCaseState] < 3)";
	var sql = new SearchSQL(sqlStr);
	var ss = new SearchScope(os);
	var objectSet = ss.fetchObjects(sql, new Integer(1), null, null);
	var iter = objectSet.iterator();
	var count = 0;
	if (iter.hasNext())
	{
		var folder = iter.next();
		// set net income from filed document as value for the case property of same name
		//folder.getProperties().putValue(incomeIdentifierName, income);
		//folder.save(RefreshMode.REFRESH);
		
		// file the doc and save
		var drcr = folder.file(doc, AutoUniqueName.AUTO_UNIQUE,
			doc.getProperties().getStringValue("Name"),
			DefineSecurityParentage.DO_NOT_DEFINE_SECURITY_PARENTAGE);
			
		drcr.save(RefreshMode.NO_REFRESH);
		
		var clientName = folder.getProperties().get("CO_ClientName").getStringValue();
  	    var fe3 = new FilterElement(null, null, null, "Name CO_ClientName", null);
		var pf3 = new PropertyFilter();
	    pf3.addIncludeProperty(fe3);
	    var doc2 = Factory.Document.fetchInstance(os, id, pf3);
		doc2.getProperties().putValue("CO_ClientName", clientName);
		doc2.save(RefreshMode.NO_REFRESH);
	}	
}
