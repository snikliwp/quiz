package  {
	
	import flash.display.MovieClip;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;		// Go get the xml file
	import flash.net.URLLoader;			// Load the xml file
	import flash.events.Event;			// when files finish loading
	import flash.events.MouseEvent;		// user mouse movement
	import flash.events.IOErrorEvent;	// local filesystem errors and corrupted file handling
	import flash.events.HTTPStatusEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.media.Sound;

	
	public class quiz_doc extends MovieClip {

		private var quizFileXML:String = "quiz.xml";					// name of the xml file
		private var quizXML:XML;									// array to store the xml data
		private	var req:URLRequest = new URLRequest();					// Set up to get the xml data 
		private	var xmlLoader:URLLoader = new URLLoader();				// Set up to get the images
		private	var numTitle:Number;	// number of title tags in the XML file
		private	var numQuestion:Number;	// number of question tags in the XML file
		private var titleText:TextField = new TextField();
		private var titleFormat:TextFormat = new TextFormat();
		private var correct:String = 'a';
		private var pages:Array = new Array();
		private var yPos:Number = 0;
		private var ahh:Sound = new Ahh();
		private var hooray:Sound = new Hooray();
		private var applause:Sound = new Applause();

		
		
		public function quiz_doc() {
			// constructor code
			sorry_mc.visible = false;
			gameOver_mc.visible = false;
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters.xmlfile;
			
			req = new URLRequest(paramObj.toString());									// Set up to get the xml data 
			xmlLoader = new URLLoader();										// Set up to get the images
			xmlLoader.addEventListener(Event.COMPLETE, getData);				// Event Listener for successful Completion
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlError);		// Event Listener for some Sort of IO Error
			xmlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, error404);	// Event Listener for a specific IO error - file not found
			xmlLoader.load(req);												// go get the XML file
			
		} // end function quiz_doc
		
		
		
		public function getData(ev) {
			quizXML = XML(ev.target.data);			// load the array with the data from the XML file
			numTitle = quizXML.quiztitle.length();	// number of level1 tags in the XML file
			numQuestion = quizXML.question.length();	// number of level1 tags in the XML file

			// add the title to the stage
			titleText.width = 500;
			titleText.height = 50;
			titleText.x = 15;
			titleText.y = 15;
			titleText.text = quizXML.quiztitle.text();
			var ttf:TextFormat = new TextFormat(); // format for the title
			var qtf:TextFormat = new TextFormat(); // format for the question
			var atf:TextFormat = new TextFormat(); // format for the responses
			ttf.size = 25;
			ttf.color = 0x000000;
			titleText.setTextFormat(ttf);
			addChild(titleText);
			
			// load the erratta into the gameover page
			gameOver_mc.gameOverText.text = quizXML.errata.text();
			
			/// set up a new slide for each of the questions
			var s:slide;
			for (var i:Number = 0; i <= numQuestion - 1; i++) {
				s = new slide;
				s.myNumber = i + 1;
				correct = quizXML.question[i].body.@correct; // put the correct response in a variable for later use
				s.x = 15;
				s.y = 50;
				addChild(s);
				pages[i] = s.name; // put the name in the arrray
			
				// Now fill up the slide with the data from the xml file
				// first add the question 
				
				var at:answer_mc = new answer_mc(); // create a new question movie clip
				at.answerText.text = (i+1) + '. ' + quizXML.question[i].body.text(); // put the text in it
				// format the text
				at.answerText.wordWrap = true;
				at.answerText.width = 480;
				at.answerText.height = 90;
				at.answerText.x = 5;
				at.answerText.y = 5;
				qtf.size = 20;
				qtf.color = 0xff0000;
				at.answerText.setTextFormat(qtf);
				// stick the question clip into the slide
				s.addChild(at);
				
				// how may responses are we dealing with
				var numresponse:Number = quizXML.question[i].response.answer.length();
				// set up the y position for the first response
				yPos = at.answerText.y + at.answerText.height - 45;
				var ab:answer_mc;
				for (var t:Number = 0; t <= numresponse - 1; t++) {
					ab = new answer_mc(); // create a new response clip
					// put the response letter and number into it
					var ansLetter:String = quizXML.question[i].response.answer[t].@letter;
					ab.answerText.text = ansLetter + '. ' + quizXML.question[i].response.answer[t].text();
					// format it
					ab.answerText.wordWrap = true;
					ab.answerText.width = 470;
					ab.answerText.height = 30;
					ab.x = 15;
					ab.y = yPos + 15; // move the y position down a bit 
					yPos = ab.y; // update the y position
					ttf.size = 20;
					ab.answerText.setTextFormat(ttf);
					// add the response into the slide
					s.addChild(ab);
					// if this is the correct response store that so we can use it later
					if (ansLetter == correct) {
						ab.correct = correct;
						} // end if
					// give it a name
					ab.name = "answer_" + ansLetter;
					ab.buttonMode = true;
					ab.mouseChildren = false;
					ab.addEventListener(MouseEvent.CLICK, checkAnswer);
				} // endfor
				// if this is the first page make it visible, otherwise turn off the visibility
				if(i == 0){
				s.visible = true;
				} else {
				s.visible = false;
				} // end else
				
			} // endfor

		} // end function getData
		
		
		public function xmlError(ev) {
		} // end function xmlError
		
		
		public function nextSlide(ev:MouseEvent) {
			// turn off the sorry clip
			sorry_mc.visible = false;
			// set up the parent of the target which should be the slide
			var test:slide = slide(ev.currentTarget.parent);
			// how many slides are there?
			var pagesLength = pages.length;
			// what number is the current slide
			var curPage = test.myNumber;
			
			var tmp:String;
			var tmpNum:String;
			var tmpClip:MovieClip;
			if(curPage < pagesLength) { // if we haven't exceeded the total number of pages
				for(var i:int = 0; i < this.numChildren; i++) { // loop through all the objects on the stage
					if(this.getChildAt(i) is MovieClip) { // if the object is a movie clip it could be a slide
						tmp = this.getChildAt(i).name; // get the objects name
						tmpClip = this.getChildAt(i) as MovieClip; // make it into a movieclip so we can get at its poperties
						tmpNum = tmpClip.myNumber; // get the clips number
						if(tmp == 'congrats_mc' || tmp == 'sorry_mc' || tmp == 'gameOver_mc') { // so if the name is one of these
							// don't do anything these aren't pages
						} else { // instead 
							if(tmpNum == curPage + 1){ // turn the next page on
								this.getChildAt(i).visible = true;
							} else {  // and the others off
								this.getChildAt(i).visible = false;
							} // end else
						}  // end else
					} // end if
				} // end for
			} else { // if we are at the end of the questions
				for(var t:int = 0; t < this.numChildren; t++) { // loop through all the objects on the stage
					if(this.getChildAt(t) is MovieClip) { // if the object is a movie clip it could be a slide
						tmpClip = this.getChildAt(t) as MovieClip; // make it into a movieclip so we can get at its poperties
						tmpClip.visible = false; // turn it off I don't care
					} // end if
				} // end for
				// turn on the end game page, it's all over now
				applause.play();

				gameOver_mc.visible = true;
			} // end else
} // end function xmlError
		
		
		public function error404(ev) {
		} // end function error404
		
		public function checkAnswer(ev) {
			var test:answer_mc = answer_mc(ev.currentTarget); // turn the yarget into a movie clip
			sorry_mc.visible = false; // turn off the sorry screen in case it is on
			if (test.correct) { // if this is the correct answer
				// go to next slide
				hooray.play();
				nextSlide(ev);
				} else {  // endif otherwise
					// turn on the error screen
					sorry_mc.visible = true;
					ahh.play();
					} // end else
				} // end function checkAnswer
		
	} // end class quiz_doc
	
} // end package