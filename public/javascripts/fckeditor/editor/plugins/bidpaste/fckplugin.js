/*
 * FCKeditor - The text editor for Internet - http://www.fckeditor.net
 * Copyright (C) 2003-2009 Frederico Caldeira Knabben
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 * Plugin to insert "Bidparams" in the editor.
 */

// Register the related command.
FCKCommands.RegisterCommand( 'BidPaste', new FCKDialogCommand( 'BidPaste',
FCKLang.BidPasteTitle, '/biddoc/custom_paste', 540, 260 ) ) ;

// Create the "Plaholder" toolbar button.
//var oBidparams2Item = new FCKToolbarButton( 'CustomPaste', FCKLang.DlgBidDocParams2 , null, null, null, null, 156) ;
//oBidparams2Item.IconPath = FCKPlugins.Items['custompaste'].Path + 'bidparams2.gif' ;

//FCKToolbarItems.RegisterItem( '', oBidparams2Item ) ;

/*
// The object used for all Bidparams operations.
var FCKBidparams = new Object() ;

// Add a new bidparams at the actual selection.
FCKBidparams.Add = function( name )
{
	alert(1938457);
	var oSpan = FCK.InsertElement( 'span' ) ;
	this.SetupSpan( oSpan, name ) ;
}

FCKBidparams.SetupSpan = function( span, name )
{
	alert(1345);
	span.innerHTML = '[[ ' + name + ' ]]' ;

	span.style.backgroundColor = '#ffff00' ;
	span.style.color = '#000000' ;

	if ( FCKBrowserInfo.IsGecko )
		span.style.cursor = 'default' ;

	span._fckbidparams = name ;
	span.contentEditable = false ;

	// To avoid it to be resized.
	span.onresizestart = function()
	{
		FCK.EditorWindow.event.returnValue = false ;
		return false ;
	}
}

// On Gecko we must do this trick so the user select all the SPAN when clicking on it.
FCKBidparams._SetupClickListener = function()
{
	alert(1456);
	FCKBidparams._ClickListener = function( e )
	{
	alert(155555);
		if ( e.target.tagName == 'SPAN' && e.target._fckbidparams )
			FCKSelection.SelectNode( e.target ) ;
	}

	FCK.EditorDocument.addEventListener( 'click', FCKBidparams._ClickListener, true ) ;
}

// Open the Bidparams dialog on double click.
FCKBidparams.OnDoubleClick = function( span )
{
	alert(1765);
	if ( span.tagName == 'SPAN' && span._fckbidparams )
		FCKCommands.GetCommand( 'Bidparams' ).Execute() ;
}

FCK.RegisterDoubleClickHandler( FCKBidparams.OnDoubleClick, 'SPAN' ) ;

// Check if a Placholder name is already in use.
FCKBidparams.Exist = function( name )
{
	alert(1098);
	var aSpans = FCK.EditorDocument.getElementsByTagName( 'SPAN' ) ;

	for ( var i = 0 ; i < aSpans.length ; i++ )
	{
		if ( aSpans[i]._fckbidparams == name )
			return true ;
	}

	return false ;
}

if ( FCKBrowserInfo.IsIE )
{
	FCKBidparams.Redraw = function()
	{
		if ( FCK.EditMode != FCK_EDITMODE_WYSIWYG )
			return ;

		var aPlaholders = FCK.EditorDocument.body.innerText.match( /\[\[[^\[\]]+\]\]/g ) ;
		if ( !aPlaholders )
			return ;

		var oRange = FCK.EditorDocument.body.createTextRange() ;

		for ( var i = 0 ; i < aPlaholders.length ; i++ )
		{
			if ( oRange.findText( aPlaholders[i] ) )
			{
				var sName = aPlaholders[i].match( /\[\[\s*([^\]]*?)\s*\]\]/ )[1] ;
				oRange.pasteHTML( '<span style="color: #000000; background-color: #ffff00" contenteditable="false" _fckbidparams="' + sName + '">' + aPlaholders[i] + '</span>' ) ;
			}
		}
	}
}
else
{
	FCKBidparams.Redraw = function()
	{
		if ( FCK.EditMode != FCK_EDITMODE_WYSIWYG )
			return ;

		var oInteractor = FCK.EditorDocument.createTreeWalker( FCK.EditorDocument.body, NodeFilter.SHOW_TEXT, FCKBidparams._AcceptNode, true ) ;

		var	aNodes = new Array() ;

		while ( ( oNode = oInteractor.nextNode() ) )
		{
			aNodes[ aNodes.length ] = oNode ;
		}

		for ( var n = 0 ; n < aNodes.length ; n++ )
		{
			var aPieces = aNodes[n].nodeValue.split( /(\[\[[^\[\]]+\]\])/g ) ;

			for ( var i = 0 ; i < aPieces.length ; i++ )
			{
				if ( aPieces[i].length > 0 )
				{
					if ( aPieces[i].indexOf( '[[' ) == 0 )
					{
						var sName = aPieces[i].match( /\[\[\s*([^\]]*?)\s*\]\]/ )[1] ;

						var oSpan = FCK.EditorDocument.createElement( 'span' ) ;
						FCKBidparams.SetupSpan( oSpan, sName ) ;

						aNodes[n].parentNode.insertBefore( oSpan, aNodes[n] ) ;
					}
					else
						aNodes[n].parentNode.insertBefore( FCK.EditorDocument.createTextNode( aPieces[i] ) , aNodes[n] ) ;
				}
			}

			aNodes[n].parentNode.removeChild( aNodes[n] ) ;
		}

		FCKBidparams._SetupClickListener() ;
	}

	FCKBidparams._AcceptNode = function( node )
	{
		if ( /\[\[[^\[\]]+\]\]/.test( node.nodeValue ) )
			return NodeFilter.FILTER_ACCEPT ;
		else
			return NodeFilter.FILTER_SKIP ;
	}
}

FCK.Events.AttachEvent( 'OnAfterSetHTML', FCKBidparams.Redraw ) ;

// We must process the SPAN tags to replace then with the real resulting value of the bidparams.
FCKXHtml.TagProcessors['span'] = function( node, htmlNode )
{
	alert(123456);
	if ( htmlNode._fckbidparams )
		node = FCKXHtml.XML.createTextNode( '[[' + htmlNode._fckbidparams + ']]' ) ;
	else
		FCKXHtml._AppendChildNodes( node, htmlNode, false ) ;

	return node ;
}
*/
