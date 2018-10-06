package components
{
	import mx.controls.dataGridClasses.DataGridColumn;
	
	public class NestedDataGridColumn extends DataGridColumn
	{
		[Bindable]
		public var nestedDataField:String;
		
		public function NestedDataGridColumn(columnName:String=null)
		{
			// the cuetom sort function being assigned to the pre-defined variable
			sortCompareFunction = mySortCompareFunction;
			super(columnName);
		}
		
		private function mySortCompareFunction(obj1:Object, obj2:Object):int
		{
			var fields:Array;
			var dataFieldSplit:String = nestedDataField;
			var currentData1:Object = obj1;
			var currentData2:Object = obj2;
			
			if (nestedDataField.indexOf(".") != -1)
			{
				fields = dataFieldSplit.split(".");
				
				for each (var f:String in fields)
				{
					currentData1 = currentData1[f];
					currentData2 = currentData2[f];
				}
			}
			else
			{
				if (dataFieldSplit != "")
				{
					currentData1 = currentData1[dataFieldSplit];
					currentData2 = currentData2[dataFieldSplit];
				}
			}
			
			if (currentData1 is int && currentData2 is int)
			{
				var int1:int = int(currentData1);
				var int2:int = int(currentData2);
				var result:int = (int1 > int2) ? -1 : 1;
				return result;
			}
			if (currentData1 is String && currentData2 is String)
			{
				currentData1 = String(currentData1);
				currentData2 = String(currentData2);
				return (currentData1 > currentData2) ? -1 : 1;
			}
			if (currentData1 is Date && currentData2 is Date)
			{
				var date1:Date = currentData1 as Date;
				var date2:Date = currentData2 as Date;
				var date1Timestamp:Number = currentData1.getTime();
				var date2Timestamp:Number = currentData2.getTime();
				return (date1Timestamp > date2Timestamp) ? -1 : 1;
			}
			
			return 0;
		}
		
		override public function itemToLabel(data:Object):String
		{
			if (!data)
			{
				return "";
			}
			
			var fields:Array;
			var label:String;
			
			var dataFieldSplit:String = nestedDataField;
			var currentData:Object = data;
			
			// check if the nestedDataField value contains a '.'
			if (nestedDataField.indexOf(".") != -1)
			{
				// get all the fields that need to be accesed
				fields = dataFieldSplit.split(".");
				
				for each (var f:String in fields)
				{
					// loop through the fields one by one and get the final value, going one field deep every iteration
					currentData = currentData[f];
				}
				
				if (currentData is String)
				{
					// return the final value
					return String(currentData);
				}
			}
			
			// if there is no nesting involved
			else
			{
				if (dataFieldSplit != "")
				{
					currentData = currentData[dataFieldSplit];
				}
			}
			
			// if our method hasn't worked as expected, resort to caling the default function
			try
			{
				label = currentData.toString();
			}
			catch (e:Error)
			{
				label = super.itemToLabel(data);
			}
			
			// return the result
			return label;
		}
	}
}