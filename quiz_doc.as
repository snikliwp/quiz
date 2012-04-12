package  {
	
	import flash.display.MovieClip;
	import flash.net.URLRequest;		// Go get the xml file
	import flash.net.URLLoader;			// Load the xml file
	import flash.events.Event;			// when files finish loading
	import flash.events.MouseEvent;		// user mouse movement
	import flash.events.IOErrorEvent;	// local filesystem errors and corrupted file handling
	import flash.events.HTTPStatusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

// Status back from the server
	
	
	public class quiz_doc extends MovieClip {

		private var quizFileXML:String = "quiz.xml";					// name of the xml file
		private var quizXML:XML;									// array to store the xml data
		private	var req:URLRequest = new URLRequest();					// Set up to get the xml data 
		private	var xmlLoader:URLLoader = new URLLoader();				// Set up to get the images
		private	var numTitle:Number;	// number of title tags in the XML file
		private	var numQuestion:Number;	// number of question tags in the XML file
		private var titleText:TextField = new TextField();
		private var questionText:TextField = new TextField();
		private var titleFormat:TextFormat = new TextFormat();
		private var answerText:TextField;
		private var s:MovieClip = new MovieClip();
		private var answer_mc:MovieClip;
		
		
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
var quizAttributes:XMLList = quizXML.question.body.attributes();
trace('quizAttributes: ', quizAttributes);
trace('quizXML.body.attributes.correct: ', quizXML..body[0].@correct);


			trace('Title : ',  quizXML.quiztitle.text());

			// add the title to the stage
			titleText.width = 500;
			titleText.height = 50;
			titleText.x = 15;
			titleText.y = 15;
			titleText.text = quizXML.quiztitle.text();
			var ttf:TextFormat = new TextFormat();
			var qtf:TextFormat = new TextFormat();
			var atf:TextFormat = new TextFormat();
			ttf.size = 25;
			ttf.color = 0x000000;
			titleText.setTextFormat(ttf);
			addChild(titleText);
			
			/// set up a new slide for each of the questions
				var s:slide;
			for (var i:Number = 0; i <= numQuestion - 1; i++) {
				s = new slide;
				s.myNumber = i + 1;
				s.correct = quizXML.question[i].body.@correct;
				trace('s.correct: ', s.correct);
				s.x = 15;
				s.y = 50;
				s.visible = true;
				// s.addEventListener(MouseEvent.CLICK, nextSlide);
				addChild(s);
				
				// Now fill up the slide with the data from the xml file
				var questTxt:TextField = new TextField();
				questTxt.text = 'Question Number ' + String(i + 1);
				questTxt.wordWrap = true;
				questTxt.width = 500;
				questTxt.height = 100;
				questTxt.x = 0;
				questTxt.y = 0;
				questTxt.setTextFormat(ttf);
				ttf.size = 20;
				s.addChild(questTxt);
				
				
				trace('Question ' + (i+1) +': ',  quizXML.question[i].body.text());
				questionText.text = quizXML.question[i].body.text();
				
				questionText.wordWrap = true;
				questionText.width = 500;
				questionText.height = 100;
				questionText.x = 15;
				questionText.y = 25;
				
				qtf.size = 20;
				qtf.color = 0xff0000;
				questionText.setTextFormat(qtf);
				
				s.addChild(questionText);
				
				
				var numresponse:Number = quizXML.question[i].response.answer.length();
				trace('numresponse: ', numresponse);
				
				var ansTxt:Number = questionText.y;
				for (var t:Number = 0; t <= numresponse - 1; t++) {
					a_mc = new answer_mc;
					answerText = new TextField();
					trace('Response ' + (t+1) +': ',  quizXML.question[i].response.answer[t].text());
					var ansLetter:String = quizXML.question[i].response.answer[t].@letter;
					
					answerText.text = ansLetter + '. ' + quizXML.question[i].response.answer[t].text();
					answerText.wordWrap = true;
					answerText.width = 500;
					answerText.height = 100;
					answerText.x = 15;
					answerText.y = ansTxt + 25;
					ansTxt = answerText.y
					answerText.setTextFormat(ttf);
					ttf.size = 20;
					answerText.name = "answer_" + ansLetter;
//					answerText.buttonMode = true;
					answerText.addEventListener(MouseEvent.CLICK, checkAnswer);

					s.addChild(answerText);

				} // endfor
				
			} // endfor


//			numTourist = menuXML.tourist.length();	// number of level1 tags in the XML file

		} // end function getData
		
		
		public function xmlError(ev) {
trace('in function xmlError: ');
			
		} // end function xmlError
		
		
		public function error404(ev) {
trace('in function error404: ');
			
		} // end function error404
		
		public function checkAnswer(ev) {
trace('in function checkAnswer: ');
			
		} // end function error404
		
		
		
	} // end class quiz_doc
	
} // end package