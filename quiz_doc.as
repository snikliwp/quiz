package  {
	
	import flash.display.MovieClip;
	import flash.net.URLRequest;		// Go get the xml file
	import flash.net.URLLoader;			// Load the xml file
	import flash.events.Event;			// when files finish loading
	import flash.events.MouseEvent;		// user mouse movement
	import flash.events.IOErrorEvent;	// local filesystem errors and corrupted file handling
	import flash.events.HTTPStatusEvent;// Status back from the server
	
	
	public class quiz_doc extends MovieClip {

		private var quizFileXML:String = "quiz.xml";					// name of the xml file
		private var quizXML:XML;									// array to store the xml data
		private	var req:URLRequest = new URLRequest();					// Set up to get the xml data 
		private	var xmlLoader:URLLoader = new URLLoader();				// Set up to get the images
		private	var numTitle:Number;	// number of title tags in the XML file
		private	var numQuestion:Number;	// number of question tags in the XML file

		
		public function quiz_doc() {
trace('in function quiz_doc: ');
			// constructor code
			req = new URLRequest(quizFileXML);									// Set up to get the xml data 
			xmlLoader = new URLLoader();										// Set up to get the images
			xmlLoader.addEventListener(Event.COMPLETE, getData);				// Event Listener for successful Completion
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlError);		// Event Listener for some Sort of IO Error
			xmlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, error404);	// Event Listener for a specific IO error - file not found
			xmlLoader.load(req);												// go get the XML file
			
		} // end function quiz_doc
		
		
		
		public function getData(ev) {
trace('in function getData: ');
			quizXML = XML(ev.target.data);			// load the array with the data from the XML file
			numTitle = quizXML.quiztitle.length();	// number of level1 tags in the XML file
			numQuestion = quizXML.question.length();	// number of level1 tags in the XML file
trace('numTitle: ', numTitle);
trace('numQuestion: ', numQuestion);
			for (var i:Number = 0; i <= numQuestion - 1; i++) {
				trace('question ' + i +': ',  quizXML.question[i].response.answer);
			} // endfor


//			numTourist = menuXML.tourist.length();	// number of level1 tags in the XML file

		} // end function getData
		
		
		public function xmlError(ev) {
trace('in function xmlError: ');
			
		} // end function xmlError
		
		
		public function error404(ev) {
trace('in function error404: ');
			
		} // end function error404
		
		
		
	} // end class quiz_doc
	
} // end package