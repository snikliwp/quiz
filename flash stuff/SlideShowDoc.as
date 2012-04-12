package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;	//in order to check the ClassName of the DisplayObjects
	
	public class SlideShowDoc extends MovieClip {
		
		public var names:Array = ["Berker", "Ron", "Josh", "Jess", "Scott"];
		public var numSlides:Number = names.length;
		
		public function SlideShowDoc() {
			// constructor code
			//we would get the XML data here and call addSlides once
			//the XML was loaded (Event.COMPLETE)
			addSlides();
		}
		
		public function addSlides():void{
			var s:Slide;
			var xPos:Number = 150;
			var yPos:Number = 100;
			for(var i:Number = 0; i<numSlides; i++){
				//i will be 0, 1, 2, 3, 4
				s = new Slide();	//replace the contents of the variable s with a new Slide
				addChild(s);
				s.myNumber = i;
				s.favouriteTeacher = "Steve";
				s.x = xPos;// * i;
				s.y = yPos;// * i;
				//xPos += 10;		//add 10 to the value of xPos
				//yPos += 10;
				s.info_txt.text = names[i];	
				if( i > 0){
					s.visible = false;
				}
				s.addEventListener(MouseEvent.CLICK, nextSlide);
			}
		}
		
		public function nextSlide(ev:MouseEvent):void{
			//when the user clicks on the slide show the next one
			var bashir:Slide = Slide(ev.currentTarget);
			bashir.visible = false;
			trace( bashir.myNumber );
			//figure out the number of the next slide
			var nextNum:Number = bashir.myNumber + 1;
			if( nextNum >= numSlides){
				nextNum = 0;	//handle reaching the end of the list
			}
			//find the next slide on the stage/timeline... 
			//What is it about the next slide that is different from everything else on the stage/timeline?
			var numItems:Number = this.numChildren;
			for( var i:Number=0; i<numItems; i++){
				//loop through everything (every DisplayObject) that is sitting on the stage/timeline
				//we could filter by property, className, or eventListeners
				var obj:DisplayObject = this.getChildAt(i);
				//trace( obj );
				//Filter by Property
				/*if( obj.hasOwnProperty("myNumber") ){
					//the object on the stage/Timeline has a property called "myNumber"
					if( Slide(obj).myNumber == nextNum ){
						obj.visible = true;		//show the object if it's myNumber property matches nextNum variable
					}
				}*/
				//By ClassName
				/*if( getQualifiedClassName(obj) == "Slide"){
					if( Slide(obj).myNumber == nextNum ){
						obj.visible = true;		//show the object if it's myNumber property matches nextNum variable
					}
				}*/
				//By EventListener
				if( obj.hasEventListener( MouseEvent.CLICK ) ){
					if( Slide(obj).myNumber == nextNum ){
						obj.visible = true;		//show the object if it's myNumber property matches nextNum variable
					}
				}
			}
			
		}
		
	}
	
}














