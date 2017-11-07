package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.SimpleButton;
	import caurina.transitions.Tweener;
	import flash.net.FileFilter;
	import flash.utils.setTimeout;
	
	public class Sequence_3 extends Sprite
	{
		public var columns:uint;
		public var rows:uint;
		private var board:Array = new Array();
		
		private var columnWidth:uint;
		private var rowHeight:uint;
		private var currentPlayer:uint = 1;
		private var currentNumber:uint;
		private var currentChip;
		public var boardDrawn:Boolean = false;
		public var ROWS:uint;
		public var COLS:uint;
		public var buttonBoard:Array = new Array(); 
		public var r1:uint;
		public var r2:uint;
		public var c:uint;
		public var rangeFlag:Boolean = false;
		public var prevNumber:uint = 10;
		public var flag:Boolean = false;
		public var newButton:Array = new Array();
		public var score:int = 0;
		
		
		public function Sequence_3(columns:uint,rows:uint):void
		{	
			
			this.columns = columns
			this.rows = rows
			
			columnWidth = new BoardPiece().width
			rowHeight = new BoardPiece().height
						
			if(boardDrawn == false)
			{
				drawBackground();			
				drawboard();
				//drawGrayBar();
				//drawSubmit();
				
				boardDrawn = true;
			}
			putChipReady();
			
			createboardArray();
			
			this.addEventListener(MouseEvent.CLICK, boardClick)
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function drawBackground():void
		{
			
			
			for(var i:uint = 0; i<rows; i++)
			{
				for(var j:uint = 0; j<columns; j++)
				{
					var backpiece:Background = new Background();
					backpiece.x = j * backpiece.width;
					backpiece.y = i * backpiece.height;
					this.addChildAt(backpiece,0);
				}
			}
		}
		
		private function drawboard():void
		{
			
			
			for(var i:uint = 0; i<rows; i++)
			{
				for(var j:uint = 0; j<columns; j++)
				{
					var boardpiece:BoardPiece = new BoardPiece();
					boardpiece.x = j * boardpiece.width;
					boardpiece.y = i * boardpiece.height;
					this.addChildAt(boardpiece,42);
					
				}
			}
		}
		private function drawGrayBar():void
		{
			var yPos:int = this.height + 50;
			
			for(var i:uint = 1; i < columns+1; i++)
			{
				var grayPiece:GrayBar = new GrayBar()
				grayPiece.x = (i * grayPiece.width)- 54;
				grayPiece.y = yPos;
				this.addChild(grayPiece);
			}
			
			
		}
		
		private function drawSubmit():void
		{
			var submitPiece:SubmitWord = new SubmitWord();
			submitPiece.x = this.width - 70;
			submitPiece.y = this.height - 50;
			this.addChild(submitPiece);
		}
		
		private function createboardArray():void
		{
			for(var i:uint = 0; i<rows; i++)
			{
				board[i] = [];
				buttonBoard[i] = [];
				for(var j:uint=0; j<columns; j++)
				{
					board[i][j] = 10;
					buttonBoard[i][j] = new SimpleButton();
				}
			}
		}
		
		private function putChipReady():void
		{
			//currentChip = RandomLetterChip();
			currentChip = RandomNumberChip();
			currentChip.y = -50;
			this.addChildAt(currentChip,42);
			
		}
		
		private function addToStage(index:uint):void
		{
			//currentChip = RandomLetterChip();
			currentChip = getButton(index);
			this.addChildAt(currentChip,42);
			
		}
		
		private function boardClick(e:MouseEvent):void
		{
			var columnclicked:uint = calculateColumn(e.currentTarget.mouseX);
			var rowclicked:uint = calculateRow(e.currentTarget.mouseY);
			
			//trace("Row:" + rowclicked);
			//trace("Column:" + columnclicked);
			
			for(var row:int=rows-1; row>=0; row--)
			{
				
				if(board[row][columnclicked]==10)
				{
					board[row][columnclicked] = currentNumber;
					
					buttonBoard[row][columnclicked] = currentChip;
					
					placeChip(new Point(row,columnclicked));
					
					checkForSequence(new Point(row,columnclicked));
					
					if(fullBoard())
					{
						showLoserDialog();
					}
					else
					{
						putChipReady();
					}
					
					return
				}
			}
			
		}
		
		private function placeChip(position:Point):void
		{
			var distanceY:int = position.x * rowHeight + rowHeight/2;
			var distanceX:int = position.y * columnWidth + columnWidth/2;
			Tweener.addTween(currentChip, {x: distanceX, y:distanceY, time:0.7, transition:"easeOutBounce"});
		}
		
		private function replaceChip(position:Point):void
		{
			var distanceY:int = position.x * rowHeight + rowHeight/2;
			var distanceX:int = position.y * columnWidth + columnWidth/2;
			Tweener.addTween(currentChip, {x: distanceX, y:distanceY, time:.6, transition:"linear"});
		}
		
		private function enterFrameHandler(e:Event):void
		{
			var currentcolumn:uint = calculateColumn(this.mouseX);
			var xPosChip:uint = currentcolumn * columnWidth + columnWidth/2
			Tweener.addTween(currentChip, {x:xPosChip, time:0.5, transition:"lineair"});
		}
		
		private function checkForWinner(position:Point):Boolean
		{
			if(verticalCheck(position))return true;
    		if(horizontalCheck(position))return true;
    		if(leftUpDiagonalCheck(position))return true;
    		if(rightUpDiagonalCheck(position))return true;
    		return false;
		}
		
		private function checkForSequence(position:Point):void
		{
			verticalCheck(position);
			horizontalCheck(position);
			leftUpDiagonalCheck(position);
			rightUpDiagonalCheck(position);
		}
		
		public function rightUpDiagonalCheck(position:Point):void
		{
			var row:uint = position.x;
			var column:uint = position.y;
			var number:uint = board[row][column];
			var lc:uint = 1;
			var loop:uint = 2;
			var i:int = 2;
			var j:int = 0;
			var temp1:int;
			var temp2:int;
			
			
			//up right 1st half
			for(i; i < 6;i++)
			{
				lc = 1;
				
				temp1 = i;
				temp2 = j;
				
				while(lc < loop)
				{
					i = temp1 + 1 - lc;
					j = temp2 - 1 + lc;
					
					number = board[i][j];
					if(board[i][j] != 10)
					{
						
						if(board[i-1][j+1] == number - 1)
						{
							if(board[i-2][j+2] == number - 2)
							{
								score++;
								deleteDiagButton(i,i-1,i-2,j,j+1,j+2);
							}
						}
						
						if(board[i-1][j+1] == number + 1)
						{
							if(board[i-2][j+2] == number + 2)
							{
								score++;
								deleteDiagButton(i,i-1,i-2,j,j+1,j+2);
							}
						}						
					}					
					
					lc++;
				}
				
				i = temp1;
				j = temp2;
				
				loop++;
			}
			
			i = 5;
			j = 1;
			
			loop = 6;
			
			//up right 2nd half
			for(j; j < 5;j++)
			{				
				
				lc = 1;
				
				temp1 = i;
				temp2 = j;
				
				while(lc < loop)
				{
					i = temp1 + 1 - lc;
					j = temp2 - 1 + lc;
					
					number = board[i][j];
					if(board[i][j] != 10)
					{
						
						if(board[i-1][j+1] == number - 1)
						{
							if(board[i-2][j+2] == number - 2)
							{
								score++;
								deleteDiagButton(i,i-1,i-2,j,j+1,j+2);
							}
						}
						
						if(board[i-1][j+1] == number + 1)
						{
							if(board[i-2][j+2] == number + 2)
							{
								score++;
								deleteDiagButton(i,i-1,i-2,j,j+1,j+2);
							}
						}						
					}					
					
					lc++;
				}
				
				i = temp1;
				j = temp2;
				
				loop--;
			}
		}
		
		public function leftUpDiagonalCheck(position:Point):void
		{
			var row:uint = position.x;
			var column:uint = position.y;
			var number:uint = board[row][column];
			var lc:uint = 1;
			var loop:uint = 2;
			var i:int = 2;
			var j:int = 6;
			var temp1:int;
			var temp2:int;
			
			
			//up left 1st half
			for(i; i < 6;i++)
			{
				lc = 1;
				
				temp1 = i;
				temp2 = j;
				
				while(lc < loop)
				{
					i = temp1 + 1 - lc;
					j = temp2 + 1 - lc;
					
					number = board[i][j];
					if(board[i][j] != 10)
					{
						
						if(board[i-1][j-1] == number - 1)
						{
							if(board[i-2][j-2] == number - 2)
							{
								score++;
								deleteDiagButton(i,i-1,i-2,j,j-1,j-2);
							}
						}
						
						if(board[i-1][j-1] == number + 1)
						{
							if(board[i-2][j-2] == number + 2)
							{
								score++;
								deleteDiagButton(i,i-1,i-2,j,j-1,j-2);
							}
						}						
					}					
					
					lc++;
				}
				
				i = temp1;
				j = temp2;
				
				loop++;
			}
			
			i = 5;
			j = 5;
			
			loop = 6;
			
			//up left 2nd half
			for(j; j > 1;j--)
			{				
				
				lc = 1;
				
				temp1 = i;
				temp2 = j;
				
				while(lc < loop)
				{
					i = temp1 + 1 - lc;
					j = temp2 + 1 - lc;
					
					number = board[i][j];
					if(board[i][j] != 10)
					{
						
						if(board[i-1][j-1] == number - 1)
						{
							if(board[i-2][j-2] == number - 2)
							{
								score++;
								deleteDiagButton(i,i-1,i-2,j,j-1,j-2);
							}
						}
						
						if(board[i-1][j-1] == number + 1)
						{
							if(board[i-2][j-2] == number + 2)
							{
								score++;
								deleteDiagButton(i,i-1,i-2,j,j-1,j-2);
							}
						}						
					}					
					
					lc++;
				}
				
				i = temp1;
				j = temp2;
				
				loop--;
			}
		}
		
		private function verticalCheck(position:Point):void
		{
			var row:uint = position.x;
			var column:uint = position.y;
			var number:uint = board[row][column];
			var i:int = row+1;
			
			if(row < 4)
			{				
				if(board[i][column] == number-1)
				{
					if(board[i+1][column] == number-2)
					{
						score++;
						deleteRowButton(row,row+1,row+2,column)
					}
				}
				else if(board[i][column] == number+1)
				{
					if(board[i+1][column] == number+2)
					{
						score++;
						deleteRowButton(row,row+1,row+2,column)
					}
				}
			}
			
			return
		}
		
		private function horizontalCheck(position:Point):void
		{
			var row:uint = position.x;
			var column:uint = position.y;
			var number:uint;
			var i:uint = 6;
			
			while(i > 1)
			{
				if(board[row][i] != 10)
				{
					number = board[row][i];
					
					if((board[row][i-1] != 10) && (board[row][i-2] != 10))
					{
						if(board[row][i-1] == number - 1)
						{
							if((board[row][i-2] == number - 2))
							{
								score++;
								deleteColButton(i,i-1,i-2,row)
							}
						}
						
						else if(board[row][i-1] == number + 1)
						{
							if(board[row][i-2] == number + 2)
							{
								score++;
								deleteColButton(i,i-1,i-2,row)
							}
						}
						
					}
				}	
				i--;
			}
			
			return
		}
		
		
		public function deleteRowButton(r1:uint,r2:uint,r3:uint,c:uint)
		{
			buttonBoard[r1][c].visible = false;
			buttonBoard[r2][c].visible = false;
			buttonBoard[r3][c].visible = false;
			
			this.removeChild(buttonBoard[r1][c]);
			this.removeChild(buttonBoard[r2][c]);
			this.removeChild(buttonBoard[r3][c]);
			
			board[r1][c] = 10;
			board[r2][c] = 10;
			board[r3][c] = 10;
		}
		
		public function deleteColButton(c1:uint,c2:uint,c3:uint,r:uint)
		{
			
			
			//trace("MADE -1");
			
			
			
			var newBoard:Array = initNewBoard(board);
			var position:Point;
			var i:int = r-1;
			
			//trace("MADE 0");
			
			
			buttonBoard[r][c1].visible = false;
			buttonBoard[r][c2].visible = false;
			buttonBoard[r][c3].visible = false;
			
			this.removeChild(buttonBoard[r][c1]);
			this.removeChild(buttonBoard[r][c2]);
			this.removeChild(buttonBoard[r][c3]);
			
			board[r][c1] = 10;
			board[r][c2] = 10;
			board[r][c3] = 10;
			
			//trace("MADE 1");
			
			while(i >= 0)
			{
				if(board[i][c1] != 10)
				{
					buttonBoard[i][c1].visible = false;
					this.removeChild(buttonBoard[i][c1]);
					board[i][c1] = 10;
					trace("R"+ i + "-C1 :" + newBoard[i][c1]);
				}
				else
				{
					trace("R"+ i + "-C1 :" + newBoard[i][c1]);
				}
				i--;
			}
			
			//trace("MADE 2");
			
			i = r-1;
			
			while(i >= 0)
			{
				if(newBoard[i][c1] != 10)
				{
					position = new Point(i+1,c1);
					
					addToStage(newBoard[i][c1]);
					
					currentChip.x = position.x;
					currentChip.y = position.y;
					
					replaceChip(position);
					board[i+1][c1] = newBoard[i][c1];
					buttonBoard[i+1][c1] = currentChip;
				}
				else
				{
					break;
				}
				i--;
			}
			
			i = r-1;
			
			while(i >= 0)
			{
				
				if(board[i][c2] != 10)
				{
					buttonBoard[i][c2].visible = false;
					this.removeChild(buttonBoard[i][c2]);
					board[i][c2] = 10;
					trace("R"+ i + "-C2 :" + newBoard[i][c2]);
				}
				else
				{
					trace("R"+ i + "-C2 :" + newBoard[i][c2]);
				}
				i--;
			}
			
			//trace("MADE 3");
			
			i = r-1;
			
			while(i >= 0)
			{
				if(newBoard[i][c2] != 10)
				{
					position = new Point(i+1,c2);
					
					addToStage(newBoard[i][c2]);
					
					currentChip.x = position.x;
					currentChip.y = position.y;
					
					replaceChip(new Point(i+1,c2));
					board[i+1][c2] = newBoard[i][c2];
					buttonBoard[i+1][c2] = currentChip;
				}
				else
				{
					break;
				}
				i--;
			}
			
			i = r-1;
			
			while(i >= 0)
			{
				if(board[i][c3] != 10)
				{
					buttonBoard[i][c3].visible = false;
					this.removeChild(buttonBoard[i][c3]);
					board[i][c3] = 10;
					trace("R"+ i + "-C3 :" + newBoard[i][c3]);
				}
				else
				{
					trace("R"+ i + "-C3 :" + newBoard[i][c3]);
				}
				i--;
			}
			
			//trace("MADE 4");
			
			i = r-1;
			
			while(i >= 0)
			{
				if(newBoard[i][c3] != 10)
				{
					position = new Point(i+1,c3);
					
					addToStage(newBoard[i][c3]);
					
					currentChip.x = position.x;
					currentChip.y = position.y;
					
					replaceChip(new Point(i+1,c3));
					board[i+1][c3] = newBoard[i][c3];
					buttonBoard[i+1][c3] = currentChip;
				}
				else
				{
					break;
				}
				i--;
			}
			
		}
		
		
		public function deleteDiagButton(r1,r2,r3,c1,c2,c3)
		{
			var newBoard:Array = initNewBoard(board);
			var position:Point;
			var i:int;
			
			buttonBoard[r1][c1].visible = false;
			buttonBoard[r2][c2].visible = false;
			buttonBoard[r3][c3].visible = false;
			
			this.removeChild(buttonBoard[r1][c1]);
			this.removeChild(buttonBoard[r2][c2]);
			this.removeChild(buttonBoard[r3][c3]);
			
			board[r1][c1] = 10;
			board[r2][c2] = 10;
			board[r3][c3] = 10;
			
			//trace("MADE 1.0");
			
			i = r1 - 1;
			
			while(i >= 0)
			{
				if(board[i][c1] != 10)
				{
					buttonBoard[i][c1].visible = false;
					this.removeChild(buttonBoard[i][c1]);
					board[i][c1] = 10;
					//trace("R"+ i + "-C1 :" + newBoard[i][c1]);
				}
				else
				{
					//trace("R"+ i + "-C1 :" + newBoard[i][c1]);
				}
				i--;
			}
			
			//trace("MADE 1.1");
			
			i = r1 - 1;
			
			while(i >= 0)
			{
				if(newBoard[i][c1] != 10)
				{
					position = new Point(i+1,c1);
					
					addToStage(newBoard[i][c1]);
					
					currentChip.x = position.x;
					currentChip.y = position.y;
					
					replaceChip(position);
					board[i+1][c1] = newBoard[i][c1];
					buttonBoard[i+1][c1] = currentChip;
				}
				else
				{
					break;
				}
				i--;
			}
			
			//trace("MADE 2.0");
			
			i = r2 - 1;
			
			while(i >= 0)
			{
				
				if(board[i][c2] != 10)
				{
					buttonBoard[i][c2].visible = false;
					this.removeChild(buttonBoard[i][c2]);
					board[i][c2] = 10;
					//trace("R"+ i + "-C2 :" + newBoard[i][c2]);
				}
				else
				{
					//trace("R"+ i + "-C2 :" + newBoard[i][c2]);
				}
				i--;
			}
			
			//trace("MADE 2.1");
			
			i = r2 - 1;
			
			while(i >= 0)
			{
				if(newBoard[i][c2] != 10)
				{
					position = new Point(i+1,c2);
					
					addToStage(newBoard[i][c2]);
					
					currentChip.x = position.x;
					currentChip.y = position.y;
					
					replaceChip(new Point(i+1,c2));
					board[i+1][c2] = newBoard[i][c2];
					buttonBoard[i+1][c2] = currentChip;
				}
				else
				{
					break;
				}
				i--;
			}
			
			//trace("MADE 3.0")
			
			i = r3 - 1;
			
			while(i >= 0)
			{
				if(board[i][c3] != 10)
				{
					buttonBoard[i][c3].visible = false;
					this.removeChild(buttonBoard[i][c3]);
					board[i][c3] = 10;
					//trace("R"+ i + "-C3 :" + newBoard[i][c3]);
				}
				else
				{
					//trace("R"+ i + "-C3 :" + newBoard[i][c3]);
				}
				i--;
			}
			
			//trace("MADE 3.1");
			
			i = r3 - 1;
			
			while(i >= 0)
			{
				if(newBoard[i][c3] != 10)
				{
					position = new Point(i+1,c3);
					
					addToStage(newBoard[i][c3]);
					
					currentChip.x = position.x;
					currentChip.y = position.y;
					
					replaceChip(new Point(i+1,c3));
					board[i+1][c3] = newBoard[i][c3];
					buttonBoard[i+1][c3] = currentChip;
				}
				else
				{
					break;
				}
				i--;
			}
			
			
			
		}	
		
		public function initNewBoard(b1:Array):Array
		{
			var newBoard:Array = new Array();			
			
			for(var i:uint = 0; i<rows; i++)
			{
				newBoard[i] = [];
				newButton[i] = [];
				for(var j:uint=0; j<columns; j++)
				{
					newBoard[i][j] = 10;
					newButton[i][j] = new SimpleButton();
				}
			}
			
			for(i = 0; i<rows; i++)
			{
				for(j = 0; j<columns; j++)
				{
					newBoard[i][j] = b1[i][j];
					newButton[i][j] = buttonBoard[i][j];
				}
			}
			
			return (newBoard);
		}
		
		private function fullBoard():Boolean
		{
			for(var i:uint = 0;i < columns;i++)
			{
				if(board[0][i] == 10)
					return false;
			}
			return true;
		}
		
		private function showLoserDialog():void
		{
			var dialog1:WinnerDialog = new WinnerDialog();
			var dialog2:WinnerDialog = new WinnerDialog();
			
			var loser1:String = "Game Over!";
			var loser2:String = "Score:" + score;
			
			dialog1.txtWinner.text = loser1;
			dialog2.txtWinner.text = loser2;
			
			dialog1.x = (this.width - dialog1.width)/2;
			dialog1.y = 100;
			
			dialog2.x = (this.width - dialog2.width)/2;
			dialog2.y = 200;
			
			this.addChild(dialog1);
			this.addChild(dialog2);
		}
		
		private function calculateColumn(mouseXPos):uint
		{
			if(mouseXPos < 0)
			{
				return 0;
			}
			else if(mouseXPos > this.width)
			{
				return columns - 1;
			}
			else
			{
				return mouseXPos/columnWidth;
			}
		}
		
		private function calculateRow(mouseYPos):uint
		{
			if(mouseYPos < 0)
			{
				return 0;
			}
			else if(mouseYPos > this.height)
			{
				return rows - 1;
			}
			else
			{
				return mouseYPos/rowHeight;
			}
		}
		
		/*private function RandomLetterChip():SimpleButton
		{
			var index:int = Math.floor(Math.random()*26);
			trace("index:" + index);
			
			switch(index)
			{
				case 0:
				return(new chipA());
				break;
				
				case 1:
				return(new chipB());
				break;
				
				case 2:
				return(new chipC());
				break;
				
				case 3:
				return(new chipD());
				break;
				
				case 4:
				return(new chipE());				
				break;
				
				case 5:
				return(new chipF());
				break;
				
				case 6:
				return(new chipG());
				break;
				
				case 7:
				return(new chipH());
				break;
				
				case 8:
				return(new chipI());
				break;
				
				case 9:
				return(new chipJ());
				break;
				
				case 10:
				return(new chipK());
				break;
				
				case 11:
				return(new chipL());
				break;
				
				case 12:
				return(new chipM());
				break;
				
				case 13:
				return(new chipN());
				break;
				
				case 14:
				return(new chipO());
				break;
				
				case 15:
				return(new chipP());
				break;
				
				case 16:
				return(new chipQ());
				break;
				
				case 17:
				return(new chipR());
				break;
				
				case 18:
				return(new chipS());
				break;
				
				case 19:
				return(new chipT());
				break;
				
				case 20:
				return(new chipU());
				break;
				
				case 21:
				return(new chipV());
				break;
				
				case 22:
				return(new chipW());
				break;
				
				case 23:
				return(new chipX());
				break;
				
				case 24:
				return(new chipY());
				break;
				
				case 25:
				return(new chipZ());
				break;
				
				
			}
			return(new chipA());
		}
		*/
		
		private function RandomNumberChip():SimpleButton
		{
			var index:int = Math.floor(Math.random()*10);
			
			if(prevNumber != index)
			{
				prevNumber = index;
				return (getButton(index));
			}
			else
			{
				while(prevNumber == index)
				{
					index = Math.floor(Math.random()*10);
					
				}
				prevNumber = index;
				return(getButton(index));
				
			}
		}		
	
		private function getButton(index:uint):SimpleButton
		{			
			switch(index)
				{
					case 0:
					currentNumber = 0;
					return(new number0());
					break;
					
					case 1:
					currentNumber = 1;
					return(new number1());
					break;
					
					case 2:
					currentNumber = 2;
					return(new number2());
					break;
					
					case 3:
					currentNumber = 3;
					return(new number3());
					break;
					
					case 4:
					currentNumber = 4;
					return(new number4());				
					break;
					
					case 5:
					currentNumber = 5;
					return(new number5());
					break;
					
					case 6:
					currentNumber = 6;
					return(new number6());
					break;
					
					case 7:
					currentNumber = 7;
					return(new number7());
					break;
					
					case 8:
					currentNumber = 8;
					return(new number8());
					break;
					
					case 9:
					currentNumber = 9;
					return(new number9());
					break;
									
				}
				currentNumber = 0;
				return(new number0());
		}
	
	}
}