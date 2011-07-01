package sg.denisvolokh
{
    import flash.events.TextEvent;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    
    import mx.controls.Text;
    import mx.core.mx_internal;
    import mx.utils.StringUtil;

    public class HyperLinkText extends Text
    {
        private var initialText:String;

        private var _linksText:*;

        private var linksTextChanged:Boolean = false;

        public var linkTextColor:String = '#0b333c';

        private var _underlineLink:Boolean = false;

        private var underlineLinkChanged:Boolean = false;
        
        private var _linksTextFunction : Function;
        
        private var linksTextFunctionChanged : Boolean = false;

        private var fontTemplate:String = "<font color='{0}'>{1}</font>";

        private var hrefTemplateUnderlined:String = "<a href='event:{0}'><u>{1}</u></a>"

        private var hrefTemplate:String = "<a href='event:{0}'>{1}</a>"

        public function HyperLinkText()
        {
            super();
            addEventListener(TextEvent.LINK, onLinkClickHandler);
        }
		
		public function set linksTextFunction(value : Function):void
		{
			if (_linksTextFunction == value) return;
			
			_linksTextFunction = value;
			linksTextFunctionChanged = true;
			
			invalidateProperties();
		}
		
		public function get linksTextFunction():Function
		{
			return _linksTextFunction;
		}
		
        public function set underlineLink(value:Boolean):void
        {
            if (_underlineLink == value)
                return;

            _underlineLink = value;
            underlineLinkChanged = true;

            invalidateProperties();
        }

        public function get underlineLink():Boolean
        {
            return _underlineLink;
        }

        public function set linksText(value:*):void
        {
            if (_linksText == value)
                return;
			
			if (value is Number)
			{
				value = Number(value).toString();
			}	
			
            _linksText = value;
            linksTextChanged = true;

            invalidateProperties();
        }

        public function get linksText():*
        {
            return _linksText;
        }

        override protected function commitProperties():void
        {	
        	if (mx_internal::htmlTextChanged && linksTextFunctionChanged)
            {
            	htmlText = convertUrlsToLinks(initialText);
                linksTextFunctionChanged = false;
            }
        	
        	if (mx_internal::htmlTextChanged)
        	{
				htmlText = convertUrlsToLinks(initialText);        		
        	}
        	
            if (mx_internal::htmlTextChanged && linksTextChanged)
            {
            	htmlText = convertUrlsToLinks(initialText);
                linksTextChanged = false;
            }

            if (mx_internal::htmlTextChanged && underlineLinkChanged)
            {
                htmlText = convertUrlsToLinks(initialText);
                underlineLinkChanged = false;
            }

            super.commitProperties();
        }

        private function convertUrlsToLinks(htmlTextValue:String):String
        {
            var exp:RegExp = /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:\/~\+#]*[\w\-\@?^=%&amp;\/~\+#])?/g;
            var links:Array = htmlTextValue.match(exp);

            var href:String;
            for (var i:int = 0; i < links.length; i++)
            {
                if (linksText)
                {
                    if (linksText is Array)
                    {
                    	if (i > linksText.length - 1)
                    	{
							href = StringUtil.substitute(fontTemplate, [ linkTextColor, links[i]]);                    		
                    	}
                    	else
                    	{
                    		if (linksText[i] == "")
                    		{
                    			if (linksTextFunction != null)
                    			{
                    				href = StringUtil.substitute(fontTemplate, [ linkTextColor, linksTextFunction(links[i])]);	
                    			}
                    			else
                    			{
                    				href = StringUtil.substitute(fontTemplate, [ linkTextColor, links[i]]);
                    			}
                    		}
                    		else
                    		{
                    			href = StringUtil.substitute(fontTemplate, [ linkTextColor, linksText[i]]);	
                    		}
                    			
                    	}
                    }

                    if (linksText is String)
                    {
                        href = StringUtil.substitute(fontTemplate, [ linkTextColor, linksText ]);
                    }
                }
                else
                {
                	if (linksTextFunction != null)
                	{
						href = StringUtil.substitute(fontTemplate, [ linkTextColor, linksTextFunction(links[i])]);                		
                	}
                	else
                	{
                		href = StringUtil.substitute(fontTemplate, [ linkTextColor, links[i]]);	
                	}
                }

                if (underlineLink)
                {
                    href = StringUtil.substitute(hrefTemplateUnderlined, [ links[i], href ]);
                }
                else
                {
                    href = StringUtil.substitute(hrefTemplate, [ links[i], href ]);
                }

                htmlTextValue = htmlTextValue.replace(links[i], href);
            }

            return htmlTextValue
        }

        override public function set htmlText(value:String):void
        {
            if (!initialText)
            {
                initialText = value;
            }

            super.htmlText = value;
        }

        private function onLinkClickHandler(event:TextEvent):void
        {
            navigateToURL(new URLRequest(event.text), "_blank")
        }
    }
}