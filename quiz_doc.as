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
		private var correct:String = 'a';
		private var pages:Array = new Array();
//		private var s:MovieClip = new MovieClip();
//		private var s:Slide;
//		private var ans_mc:answer_mc;
		
		
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
				correct = quizXML.question[i].body.@correct;
//				trace('correct: ', correct);
				s.x = 15;
				s.y = 50;
				addChild(s);
				trace('s.name: ', s.name);
				trace('s.myNumber: ', s.myNumber);
				pages[i+1] = s.name;
			
				// Now fill up the slide with the data from the xml file
				// first add the question title
				
				trace('Question ' + (i+1) +': ',  quizXML.question[i].body.text());
				var at:answer_mc = new answer_mc();
				at.answerText.text = (i+1) + '. ' + quizXML.question[i].body.text();
trace('at.questionText: ', at.answerText);
				
				at.answerText.wordWrap = true;
				at.answerText.width = 480;
				at.answerText.height = 90;
				at.answerText.x = 5;
				at.answerText.y = 5;
		trace('1: ');		
				qtf.size = 20;
				qtf.color = 0xff0000;
				at.answerText.setTextFormat(qtf);
				
				s.addChild(at);
				
				var numresponse:Number = quizXML.question[i].response.answer.length();
//				trace('numresponse: ', numresponse);
				
				var ansTxt:Number = at.answerText.y + at.answerText.height - 45;
				trace('y: ', at.answerText.y,  at.answerText.height);
				var ab:answer_mc;
				for (var t:Number = 0; t <= numresponse - 1; t++) {
//					trace('t: , numresponse - 1: ', t,  numresponse - 1);
					ab = new answer_mc();
//					answerText = new TextField();
//					trace('Response ' + (t+1) +': ',  quizXML.question[i].response.answer[t].text());
					var ansLetter:String = quizXML.question[i].response.answer[t].@letter;
					ab.answerText.text = ansLetter + '. ' + quizXML.question[i].response.answer[t].text();
//					ab.answerText.text = 'this is test text one two three four five six seven eight nine.';
					ab.answerText.wordWrap = true;
					ab.answerText.width = 470;
					ab.answerText.height = 30;
					ab.x = 15;
					ab.y = ansTxt + 45;
					ansTxt = ab.y;
//					a.answerText = answerText.y
					ttf.size = 20;
					ab.answerText.setTextFormat(ttf);
					s.addChild(ab);
//					trace('s: ', s);
//					trace('s.ab: ', s.ab);
					if (ansLetter == correct) {
						ab.correct = correct;
					}
//trace('ab.correct: ', ab.correct);					
					ab.name = "answer_" + ansLetter;
					ab.buttonMode = true;
					ab.mouseChildren = false;
					ab.addEventListener(MouseEvent.CLICK, checkAnswer);

				} // endfor
				
				if(i == 0){
				s.visible = true;
				trace('i: ', i);
				trace('s.visible: ', s.visible);
				} else {
				s.visible = false;
				trace('i: ', i);
				trace('s.visible: ', s.visible);
				}
				
			} // endfor


//			numTourist = menuXML.tourist.length();	// number of level1 tags in the XML file

		} // end function getData
		
		
		public function xmlError(ev) {
trace('in function xmlError: ');
			
		} // end function xmlError
		
		
		public function nextSlide(ev:MouseEvent) {
trace('in function nextSlide: ');
			var test:slide = slide(ev.currentTarget.parent);
			test.visible = false;
			var pagesLength = pages.length;
			trace('test.myNumber: ', test.myNumber);
			var curPage = test.myNumber;
			trace('pagesLength', pagesLength);
var tmp:String;
for(var i:int = 0; i < this.numChildren; i++) {
    if(this.getChildAt(i) is MovieClip) {
        trace('(this.getChildAt(i): ', this.getChildAt(i));
		tmp = this.getChildAt(i).name;
		trace('tmp: ', tmp);// do something
		if (i !=curPage + 1) {
		this.getChildAt(i).visible = false;
		} else {
		this.getChildAt(i).visible = true;
	
		}
    }
}




//for (var i:Number = 1; i <= pagesLength - 1; i++) {
//				trace('pages['+i+']: ', pages[i]);
//			} // endfor
//			trace('pages[1]: ', pages[1]);
//			
//			trace('ev.myNumber: ', test.myNumber);
//			trace('ev.name: ', test.name);
			test.visible = false;
} // end function xmlError
		
		
		public function error404(ev) {
trace('in function error404: ');
			
		} // end function error404
		
		public function checkAnswer(ev) {
trace('in function checkAnswer: ');
			var test:answer_mc = answer_mc(ev.currentTarget);
//			trace('test: ', test);
//			trace('test.correct: ', test.correct);
			if (test.correct) {
		trace('the correct selection was made');
		// remove event listener
		
		// go to next slide
			nextSlide(ev);
		
			} // endif
		trace('the incorrect selection was made');
			
			
			//after checking answer and deciding to move on
		} // end function checkAnswer
		
		
		
	} // end class quiz_doc
	
} // end package