package utils
{
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 *
	 * @author spirit_2
	 */
	public class TextBox extends TextField
	{
		[Embed(source="../../fonts/ae_Ouhod.ttf",fontName="ae_Ouhod",fontStyle="regular",fontWeight="regular",fontWeight="bold", mimeType="application/x-font-truetype",unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+02C6,U+02DC,U+2013-U+2014,U+2018-U+201A,U+201C-U+201E,U+2020-U+2022,U+2026,U+2030,U+2039-U+203A,U+20AC,U+2122,U+0401,U+0410-U+044F",embedAsCFF="false")]
		private var MyFont:Class;
		
		public function TextBox(w:Number, h:Number, size:int, color:int, font:String = "", text:String = "", align:String = TextFieldAutoSize.LEFT, bold:Boolean = false, italic:Boolean = false, filters:Array = null, type:String = TextFieldType.DYNAMIC, multiline:Boolean = false, selectable:Boolean = false, bg:int = 0, border:int = 0, maxChars:int = 0, leading:int = 0)
		{
			Font.registerFont(MyFont);
			
			if (!font)
			{
				font = "ae_Ouhod";
				this.embedFonts = true;
			}
			
			this.defaultTextFormat = getFormatItem(size, color, font, align, bold, bg, italic, leading);
			this.autoSize = align;
			this.type = type;
			this.multiline = multiline;
			this.wordWrap = true;
			this.selectable = selectable;
			this.width = w;
			this.height = h;
			this.htmlText = text;
			this.filters = filters;
			
			if (bg)
			{
				this.background = true;
				this.backgroundColor = bg;
			}
			
			if (border)
			{
				this.border = true;
				this.borderColor = border;
			}
			
			if (maxChars)
				this.maxChars = maxChars;
		}
		
		private function getFormatItem(size:int, color:int, font:String, align:String, bold:Boolean, bg:int, italic:Boolean, leading:int = 0):TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.size = size;
			format.color = color;
			format.font = font;
			format.bold = bold;
			format.italic = italic;
			format.leading = leading;
			
			if (size > 38)
			{
				format.letterSpacing = -3.5;
				format.rightMargin = 4;
			}
			
			if (align != TextFieldAutoSize.NONE)
				format.align = align;
			else
				format.align = TextFieldAutoSize.LEFT;
			
			if (bg)
				format.blockIndent = 5;
			
			return format;
		}
		
		public function changeTextFormat(underline:Boolean, color:int = 0):void
		{
			var format:TextFormat = this.getTextFormat();
			format.underline = underline;
			
			if (color)
				format.color = color;
			
			this.setTextFormat(format);
		}
		
		public function changeParams(letterSpacing:Number, margin:Number):void
		{
			var format:TextFormat = this.getTextFormat();
			
			format.letterSpacing = letterSpacing;
			format.rightMargin = margin;
			
			this.setTextFormat(format);
		}
		
		public function changeLeading(leading:Number):void
		{
			var format:TextFormat = this.getTextFormat();
			
			format.leading = leading;
			
			this.setTextFormat(format);
		}
		
		public function changeSize(size:uint):void
		{
			var format:TextFormat = this.getTextFormat();
			
			format.size = size;
			
			this.setTextFormat(format);
		}
		
		public function changeKerning(kerning:Number):void
		{
			var format:TextFormat = this.getTextFormat();
			
			format.kerning = true;
			format.letterSpacing = kerning;
			
			this.setTextFormat(format);
		}
	}

}