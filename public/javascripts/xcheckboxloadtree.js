/*----------------------------------------------------------------------------\
|                               XLoadTree 1.11                                |
|-----------------------------------------------------------------------------|
|                         Created by Erik Arvidsson                           |
|                  (http://webfx.eae.net/contact.html#erik)                   |
|                      For WebFX (http://webfx.eae.net/)                      |
|-----------------------------------------------------------------------------|
| An extension to xTree that allows sub trees to be loaded at runtime by      |
| reading XML files from the server. Works with IE5+ and Mozilla 1.0+         |
|-----------------------------------------------------------------------------|
|                   Copyright (c) 1999 - 2002 Erik Arvidsson                  |
|-----------------------------------------------------------------------------|
| This software is provided "as is", without warranty of any kind, express or |
| implied, including  but not limited  to the warranties of  merchantability, |
| fitness for a particular purpose and noninfringement. In no event shall the |
| authors or  copyright  holders be  liable for any claim,  damages or  other |
| liability, whether  in an  action of  contract, tort  or otherwise, arising |
| from,  out of  or in  connection with  the software or  the  use  or  other |
| dealings in the software.                                                   |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| This  software is  available under the  three different licenses  mentioned |
| below.  To use this software you must chose, and qualify, for one of those. |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| The WebFX Non-Commercial License          http://webfx.eae.net/license.html |
| Permits  anyone the right to use the  software in a  non-commercial context |
| free of charge.                                                             |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| The WebFX Commercial license           http://webfx.eae.net/commercial.html |
| Permits the  license holder the right to use  the software in a  commercial |
| context. Such license must be specifically obtained, however it's valid for |
| any number of  implementations of the licensed software.                    |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| GPL - The GNU General Public License    http://www.gnu.org/licenses/gpl.txt |
| Permits anyone the right to use and modify the software without limitations |
| as long as proper  credits are given  and the original  and modified source |
| code are included. Requires  that the final product, software derivate from |
| the original  source or any  software  utilizing a GPL  component, such  as |
| this, is also licensed under the GPL license.                               |
|-----------------------------------------------------------------------------|
| 2001-09-27 | Original Version Posted.                                       |
| 2002-01-19 | Added some simple error handling and string templates for      |
|            | reporting the errors.                                          |
| 2002-01-28 | Fixed loading issues in IE50 and IE55 that made the tree load  |
|            | twice.                                                         |
| 2002-10-10 | (1.1) Added reload method that reloads the XML file from the   |
|            | server.                                                        |
/ 2003-05-06 | Added support for target attribute                             |
|-----------------------------------------------------------------------------|
| Dependencies: xtree.js - original xtree library                             |
|               xtree.css - simple css styling of xtree                       |
|               xmlextras.js - provides xml http objects and xml document     |
|                              objects                                        |
|-----------------------------------------------------------------------------|
| Created 2001-09-27 | All changes are in the log above. | Updated 2003-05-06 |
\----------------------------------------------------------------------------*/


webFXTreeConfig.loadingText = "请等待...";
webFXTreeConfig.loadErrorTextTemplate = "װ����� \"%1%\"";
webFXTreeConfig.emptyErrorTextTemplate = "���� \"%1%\" �����¼���λ";

/*
 * WebFXCheckBoxLoadTree class
 */

function WebFXCheckBoxLoadTree(sText, bChecked, checkValue, sXmlSrc, sAction, sBehavior, sIcon, sOpenIcon) {
	// call super
	this.WebFXCheckBoxTree = WebFXCheckBoxTree;
	this.WebFXCheckBoxTree(sText, bChecked, checkValue, sAction, sBehavior, sIcon, sOpenIcon);

	// setup default property values
	this.src = sXmlSrc;
	this.loading = false;
	this.loaded = false;
	this.errorText = "";

	// if no src, do nothing
	if(this.src == null || this.src == "")
		return;

	// check start state and load if open
	if (this.open)
		_startLoadXmlTree_Checkbox(this.src, this);
	else {
		// and create loading item if not
		this._loadingItem = new WebFXCheckBoxTreeItem(webFXTreeConfig.loadingText);
		this.add(this._loadingItem);
	}
}

WebFXCheckBoxLoadTree.prototype = new WebFXCheckBoxTree;

// override the expand method to load the xml file
WebFXCheckBoxLoadTree.prototype._webfxtree_expand = WebFXCheckBoxTree.prototype.expand;
WebFXCheckBoxLoadTree.prototype.expand = function() {
	if (!this.loaded && !this.loading) {
		// load
		_startLoadXmlTree_Checkbox(this.src, this);
	}
	this._webfxtree_expand();
};

/*
 * WebFXCheckBoxLoadTreeItem class
 */

function WebFXCheckBoxLoadTreeItem(sText, bChecked, checkValue, sXmlSrc, sAction, eParent, sIcon, sOpenIcon) {
	// call super
	this.WebFXCheckBoxTreeItem = WebFXCheckBoxTreeItem;
	this.WebFXCheckBoxTreeItem(sText, bChecked, checkValue, sAction, eParent, sIcon, sOpenIcon);

	// setup default property values
	this.src = sXmlSrc;
	this.loading = false;
	this.loaded = false;
	this.errorText = "";

	// check start state and load if open
	if (this.open)
		_startLoadXmlTree_Checkbox(this.src, this);
	else {
		// and create loading item if not
		this._loadingItem = new WebFXCheckBoxTreeItem(webFXTreeConfig.loadingText);
		this.add(this._loadingItem);
	}
}

WebFXCheckBoxLoadTreeItem.prototype = new WebFXCheckBoxTreeItem;

// override the expand method to load the xml file
WebFXCheckBoxLoadTreeItem.prototype._webfxtreeitem_expand = WebFXCheckBoxTreeItem.prototype.expand;
WebFXCheckBoxLoadTreeItem.prototype.expand = function() {
	if (!this.loaded && !this.loading) {
		// load
		_startLoadXmlTree_Checkbox(this.src, this);
	}
	this._webfxtreeitem_expand();
};

// reloads the src file if already loaded
WebFXCheckBoxLoadTree.prototype.reload =
WebFXCheckBoxLoadTreeItem.prototype.reload = function () {
	// if loading do nothing
	if (this.loaded) {
		var open = this.open;
		// remove
		while (this.childNodes.length > 0)
			this.childNodes[this.childNodes.length - 1].remove();

		this.loaded = false;

		this._loadingItem = new WebFXCheckBoxTreeItem(webFXTreeConfig.loadingText);
		this.add(this._loadingItem);

		if (open)
			this.expand();
	}
	else if (this.open && !this.loading)
		_startLoadXmlTree_Checkbox(this.src, this);
};

/*
 * Helper functions
 */

// creates the xmlhttp object and starts the load of the xml document
function _startLoadXmlTree_Checkbox(sSrc, jsNode) {
	if(sSrc == null || sSrc == "")
		return;

	if (jsNode.loading || jsNode.loaded)
		return;
	jsNode.loading = true;
	var xmlHttp = XmlHttp.create();
	xmlHttp.open("POST", sSrc, true);	// async
	xmlHttp.onreadystatechange = function () {
		if (xmlHttp.readyState == 4) {
			_xmlFileLoaded_Checkbox(xmlHttp.responseXML, jsNode);
		}
	};

	// call in new thread to allow ui to update
	window.setTimeout(function () {
		xmlHttp.send(null);
	}, 10);
}


// Converts an xml tree to a js tree. See article about xml tree format
function _xmlTreeToJsTree_Checkbox(oNode) {
	// retreive attributes
	var text = oNode.getAttribute("text");
	var action = oNode.getAttribute("action");
	var parent = null;
	var icon = oNode.getAttribute("icon");
	var openIcon = oNode.getAttribute("openIcon");
	var src = oNode.getAttribute("src");
	var target = oNode.getAttribute("target");
	var checkValue = oNode.getAttribute("checkValue");
	var clickFunc = oNode.getAttribute("clickFunc");

	var bChecked = false;
	if(oNode.getAttribute("checked") == "true")
	{
		bChecked = true;
	}

	// create jsNode
	var jsNode;
	if (src != null && src != "")
		jsNode = new WebFXCheckBoxLoadTreeItem(text, bChecked, checkValue, src, action, parent, icon, openIcon);
	else
		jsNode = new WebFXCheckBoxTreeItem(text, bChecked, checkValue, action, parent, icon, openIcon);

	jsNode.clickFunc = clickFunc
	
	if (target != "")
		jsNode.target = target;

	// go through childNOdes
	var cs = oNode.childNodes;
	var l = cs.length;
	for (var i = 0; i < l; i++) {
		if (cs[i].tagName == "tree")
			jsNode.add( _xmlTreeToJsTree_Checkbox(cs[i]), true );
	}

	return jsNode;
}

// Inserts an xml document as a subtree to the provided node
function _xmlFileLoaded_Checkbox(oXmlDoc, jsParentNode) {
	if (jsParentNode.loaded)
		return;

	var bIndent = false;
	var bAnyChildren = false;
	jsParentNode.loaded = true;
	jsParentNode.loading = false;

	// check that the load of the xml file went well
	if( oXmlDoc == null || oXmlDoc.documentElement == null) {
		alert(oXmlDoc.xml);
		jsParentNode.errorText = parseTemplateString_Checkbox(webFXTreeConfig.loadErrorTextTemplate,
							jsParentNode.src);
	}
	else {
		// there is one extra level of tree elements
		var root = oXmlDoc.documentElement;

		// loop through all tree children
		var cs = root.childNodes;
		var l = cs.length;
		for (var i = 0; i < l; i++) {
			if (cs[i].tagName == "tree") {
				bAnyChildren = true;
				bIndent = true;
				jsParentNode.add( _xmlTreeToJsTree_Checkbox(cs[i]), true);
			}
		}

		// if no children we got an error
		if (!bAnyChildren)
			jsParentNode.errorText = parseTemplateString_Checkbox(webFXTreeConfig.emptyErrorTextTemplate,
										jsParentNode.src);
	}

	// remove dummy
	if (jsParentNode._loadingItem != null) {
		jsParentNode._loadingItem.remove();
		bIndent = true;
	}

    //�����Ƿ�ѡ��
    setCheck();

	if (bIndent) {
		// indent now that all items are added
		jsParentNode.indent();
	}

	// show error in status bar
	if (jsParentNode.errorText != "")
		window.status = jsParentNode.errorText;
}

// parses a string and replaces %n% with argument nr n
function parseTemplateString_Checkbox(sTemplate) {
	var args = arguments;
	var s = sTemplate;

	s = s.replace(/\%\%/g, "%");

	for (var i = 1; i < args.length; i++)
		s = s.replace( new RegExp("\%" + i + "\%", "g"), args[i] )

	return s;
}







/*
  ���������̬ѡ��
  checkProperty�����ȶ�����һ�������4����ѡ���״̬��
��setCheckedTreeNode ������4��ʼ�����󣬲��������ӽڵ��Ƿ���Ҫѡ�У������Ҫ�Ļ���չ���ڵ�
  setCheck �ص������������ӽڵ��Ƿ���Ҫѡ�У����ҽ�����checkProperty���ָ���ȱʡ״̬
*/
var checkProperty =
{
  /**
   * ��check�Ľڵ㣬WebFXCheckBoxLoadTree��WebFXCheckBoxLoadTreeItem����
   */
  treeNode : null,

  /**
   * check��״̬��boolean����
   */
  bChecked : null,

  /**
   * check�Ƿ�Ӱ�쵽�¼�ֱ�ӽڵ㣬boolean����
   */
  isContainChildren : null,

  /**
   * ����checkӰ�쵽�����нڵ㣬WebFXCheckBoxLoadTree��WebFXCheckBoxLoadTreeItemΪԪ�ص�����
   */
  nodes : new Array()
};

/*
 * ѡ��㺯��
 * treeNode �����Ҫ���������
 * bChecked boolean ѡ�л��ǲ�ѡ��
 * isContainChildren �Ƿ���¼��ڵ㣬���򽫸ý�㼰���¼����ȫ��ѡ�У�����ֻѡ�иý��
 */
function setCheckedTreeNode(treeNodeID,bChecked,isContainChildren)
{
  checkProperty.treeNode = webFXTreeHandler.all[treeNodeID];
  checkProperty.bChecked = bChecked;
  checkProperty.isContainChildren = isContainChildren;

  //�Ƿ�ѡ���˽ڵ�
  if(checkProperty.treeNode != null)
  {
    //�Ƿ���¼�
    if(checkProperty.isContainChildren)
    {
      //�Ƿ�Ҷ�ӽڵ�
      if(checkProperty.treeNode.src !=null && checkProperty.treeNode.src != "")
      {
        if(checkProperty.bChecked)
        {
          checkProperty.treeNode.expand();
        }

        childrenNode = checkProperty.treeNode.childNodes;
        for(i=0;i<childrenNode.length;i++)
        {
          child = childrenNode[i];
          child.setChecked(checkProperty.bChecked);
          //��¼״̬�����ã�check��ȡ��check���Ľڵ㣨������ڵ㣩
          if(checkProperty.treeNode.loaded)
          {
              checkProperty.nodes[checkProperty.nodes.length] = child;
          }
        }
      }
    }
    checkProperty.treeNode.setChecked(bChecked);
    //��¼״̬�����ã�check��ȡ��check���Ľڵ㣨������ڵ㣩
    checkProperty.nodes[checkProperty.nodes.length] = checkProperty.treeNode;
    //֪ͨcheck�����Ѿ����
    afterCheck();
    if(checkProperty.treeNode.loaded)
    {
        clearCheckProperty();
    }
  }
}

function setCheck()
{
  if(checkProperty.treeNode != null && checkProperty.isContainChildren)
  {
    childrenNode = checkProperty.treeNode.childNodes;
    for(i=0;i<childrenNode.length;i++)
    {
      child = childrenNode[i];
      child.setChecked(checkProperty.bChecked);
      //��¼״̬�����ã�check��ȡ��check���Ľڵ㣨������ڵ㣩
      checkProperty.nodes[checkProperty.nodes.length] = child;
    }
  }
  //֪ͨcheck�����Ѿ����
  afterCheck();
  clearCheckProperty();
}

/**
 * ���checkProperty����
 */
function clearCheckProperty()
{
  checkProperty.isContainChildren = null;
  checkProperty.treeNode = null;
  checkProperty.bChecked = null;
  checkProperty.nodes = new Array()
}

/**
 * check������ɺ�Ļص���ȱʡʲô�������û����Զ����µ�afterCheck()����֮
 */
function afterCheck()
{
}