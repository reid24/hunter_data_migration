Schema.SObjectType sobjType = Schema.Lead.SObjectType;
Schema.DescribeSObjectResult dr = sobjType.getDescribe();
Map<String, Schema.SObjectField> fieldsMap = dr.fields.getMap();

String csv = 'SObject Type,Label,Field Name,Is Editable,Is Formula,Formula,Type,Reference/Picklist Values\n';
for(String fieldName : fieldsMap.keySet()) {
    //csv += fieldName.toUpperCase();
    //csv += fieldName;
    Schema.SObjectField f = fieldsMap.get(fieldName);
    Schema.DescribeFieldResult dfr = f.getDescribe();
    csv += sobjType.getDescribe().getName() + ',';
    csv += dfr.getLabel();
	csv += ',' + dfr.getName();
    csv += ',' + ((dfr.isUpdateable() || dfr.isCreateable()) ? 'No' : 'Yes');
    csv += ',' + (dfr.isCalculated() ? 'Yes' : 'No');
    String formulaString = (dfr.getCalculatedFormula() == null ? '' : dfr.getCalculatedFormula());
    formulaString = formulaString.replaceAll('"', '""');
    //formulaString = formulaString.replaceAll('\n', '');
    //formulaString = formulaString.replaceAll('\n', '');
    csv += ',"' + formulaString + '"';
    csv += ',' + dfr.getType();
    csv += ',';
    if(dfr.getType() == Schema.DisplayType.REFERENCE) {
        csv += dfr.getReferenceTo().get(0).getDescribe().getName();
    }else if(dfr.getType() == Schema.DisplayType.PICKLIST) {
        List<String> ples = new List<String>();
        for(Schema.PicklistEntry ple : dfr.getPicklistValues()){
            ples.add(ple.getLabel());
        }
        csv += '"' + String.join(ples, ',') + '"';
    }
    csv += '\n';
}
system.debug(csv);
