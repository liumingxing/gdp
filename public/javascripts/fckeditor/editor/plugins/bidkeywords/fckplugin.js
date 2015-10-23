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
//FCKCommands.RegisterCommand( 'Bidparams', new FCKDialogCommand( 'Bidparams', FCKLang.DlgBidDocParamsTitle, FCKPlugins.Items['bidparams'].Path + 'fck_bidparams.html', 340, 160 ) ) ;
FCKCommands.RegisterCommand( 'Bidkeywords', new FCKDialogCommand( 'Bidkeywords', FCKLang.DlgBidDockeywordsTitle, '/bid_project/bid_keywords_for_editor', 340, 160 ) ) ;

// Create the "Plaholder" toolbar button.
var oBidkeywordsItem = new FCKToolbarButton( 'Bidkeywords', FCKLang.DlgBidDockeywords ) ;
oBidkeywordsItem.IconPath = FCKPlugins.Items['bidkeywords'].Path + 'bidkeywords.gif' ;

FCKToolbarItems.RegisterItem( 'Bidkeywords', oBidkeywordsItem ) ;

/*
// The object used for all Bidkeywords operations.
var FCKBidkeywords = new Object() ;

// Add a new bidkeywords at the actual selection.
FCKBidkeywords.Add = function( name )
{
	alert(1938457);
	var oSpan = FCK.InsertElement( 'span' ) ;
	this.SetupSpan( oSpan, name ) ;
}

FCKBidkeywords.SetupSpan = function( span, name )
{
	alert(1345);
	span.innerHTML = '[[ ' + name + ' ]]' ;

	span.style.backgroundColor = '#ffff00' ;
	span.style.color = '#000000' ;

	if ( FCKBrowserInfo.IsGecko )
		span.style.cursor = 'default' ;

	span._fckbidkeywords = name ;
	span.contentEditable = false ;

	// To avoid it to be resized.
	span.onresizestart = function()
	{
		FCK.EditorWindow.event.returnValue = false ;
		return false ;
	}
}

// On Gecko we must do this trick so the user select all the SPAN when clicking on it.
FCKBidkeywords._SetupClickListener = function()
{
	alert(1456);
	FCKBidkeywords._ClickListener = function( e )
	{
	alert(155555);
		if ( e.target.tagName == 'SPAN' && e.target._fckbidkeywords )
			FCKSelection.SelectNode( e.target ) ;
	}

	FCK.EditorDocument.addEventListener( 'click', FCKBidkeywords._ClickListener, true ) ;
}

// Open the Bidkeywords dialog on double click.
FCKBidkeywords.OnDoubleClick = function( span )
{
	alert(1765);
	if ( span.tagName == 'SPAN' && span._fckbidkeywords )
		FCKCommands.GetCommand( 'Bidkeywords' ).Execute() ;
}

FCK.RegisterDoubleClickHandler( FCKBidkeywords.OnDoubleClick, 'SPAN' ) ;

// Check if a Placholder name is already in use.
FCKBidkeywords.Exist = function( name )
{
	alert(1098);
	var aSpans = FCK.EditorDocument.getElementsByTagName( 'SPAN' ) ;

	for ( var i = 0 ; i < aSpans.length ; i++ )
	{
		if ( aSpans[i]._fckbidkeywords == name )
			return true ;
	}

	return false ;
}

if ( FCKBrowserInfo.IsIE )
{
	FCKBidkeywords.Redraw = function()
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
				oRange.pasteHTML( '<span style="color: #000000; background-color: #ffff00" contenteditable="false" _fckbidkeywords="' + sName + '">' + aPlaholders[i] + '</span>' ) ;
			}
		}
	}
}
else
{
	FCKBidkeywords.Redraw = function()
	{
		if ( FCK.EditMode != FCK_EDITMODE_WYSIWYG )
			return ;

		var oInteractor = FCK.EditorDocument.createTreeWalker( FCK.EditorDocument.body, NodeFilter.SHOW_TEXT, FCKBidkeywords._AcceptNode, true ) ;

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
						FCKBidkeywords.SetupSpan( oSpan, sName ) ;

						aNodes[n].parentNode.insertBefore( oSpan, aNodes[n] ) ;
					}
					else
						aNodes[n].parentNode.insertBefore( FCK.EditorDocument.createTextNode( aPieces[i] ) , aNodes[n] ) ;
				}
			}

			aNodes[n].parentNode.removeChild( aNodes[n] ) ;
		}

		FCKBidkeywords._SetupClickListener() ;
	}

	FCKBidkeywords._AcceptNode = function( node )
	{
		if ( /\[\[[^\[\]]+\]\]/.test( node.nodeValue ) )
			return NodeFilter.FILTER_ACCEPT ;
		else
			return NodeFilter.FILTER_SKIP ;
	}
}

FCK.Events.AttachEvent( 'OnAfterSetHTML', FCKBidkeywords.Redraw ) ;

// We must process the SPAN tags to replace then with the real resulting value of the bidkeywords.
FCKXHtml.TagProcessors['span'] = function( node, htmlNode )
{
	alert(123456);
	if ( htmlNode._fckbidkeywords )
		node = FCKXHtml.XML.createTextNode( '[[' + htmlNode._fckbidkeywords + ']]' ) ;
	else
		FCKXHtml._AppendChildNodes( node, htmlNode, false ) ;

	return node ;
}
*/
