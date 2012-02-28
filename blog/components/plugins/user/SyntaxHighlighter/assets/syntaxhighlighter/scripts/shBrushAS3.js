/*
 * AS3 Syntax
 * @author Joony
 * http://forea.ch
*/

dp.sh.Brushes.AS3 = function()
{
	var statements = 			'break case continue default do while else for each in if return super switch throw try catch finally ' +
								'while with';
						
	var attributes = 			'dynamic final internal native override protected public static';
	var attributePrivate = 		'private';
	
	var definitions = 			'class const extends function get set implements interface namespace package';
	
	var directives = 			'import include use';
	
	var primaryExpressions = 	'false null true';
	var primaryExpressionThis = 'this';
	
	var operators =				'as delete instanceof is new typeof';
	
	var types = 				'Array Boolean Date int Number Object XML XMLList String uint';
	var typeVoid =				'void';
	
	var globalConstants = 		'Infinity -Infinity NaN undefined'
	
	var globalFunctions = 		'decodeURI decodeURIComponent encodeURI encodeURIComponent escape isFinite isNaN isXMLName ' +
								'parseFloat parseInt trace unescape';					
	
	
	this.regexList = [
		{ regex: dp.sh.RegexLib.SingleLineCComments,						css: 'comment' },				// one line comments
		{ regex: dp.sh.RegexLib.MultiLineCComments,							css: 'blockcomment' },			// multiline comments
		{ regex: dp.sh.RegexLib.DoubleQuotedString,							css: 'string' },				// double quoted strings
		{ regex: dp.sh.RegexLib.SingleQuotedString,							css: 'string' },				// single quoted strings
		{ regex: new RegExp('^\\s*#.*', 'gm'),								css: 'preprocessor' },			// preprocessor tags like #region and #endregion
		{ regex: new RegExp(this.GetKeywords(statements), 'gm'),			css: 'statements' },			// statements
		{ regex: new RegExp(this.GetKeywords(attributes), 'gm'),			css: 'attributes' },			// attributes
		{ regex: new RegExp(this.GetKeywords(attributePrivate), 'gm'),		css: 'attributePrivate' },		// attributePrivate
		{ regex: new RegExp(this.GetKeywords(definitions), 'gm'),			css: 'definitions' },			// definitions
		{ regex: new RegExp(this.GetKeywords(directives), 'gm'),			css: 'directives' },			// directives
		{ regex: new RegExp(this.GetKeywords(primaryExpressions), 'gm'),	css: 'primaryExpressions' },	// primaryExpressions
		{ regex: new RegExp(this.GetKeywords(primaryExpressionThis), 'gm'),	css: 'primaryExpressionThis' },	// primaryExpressionThis
		{ regex: new RegExp(this.GetKeywords(operators), 'gm'),				css: 'operators' },				// operators
		{ regex: new RegExp(this.GetKeywords(types), 'gm'),					css: 'types' },					// types
		{ regex: new RegExp(this.GetKeywords(typeVoid), 'gm'),				css: 'typeVoid' },				// typeVoid
		{ regex: new RegExp(this.GetKeywords(globalConstants), 'gm'),		css: 'globalConstants' },		// globalConstants
		{ regex: new RegExp(this.GetKeywords(globalFunctions), 'gm'),		css: 'globalFunctions' },		// globalFunctions
		{ regex: new RegExp('var', 'gm'),									css: 'variable' }				// variable
		];

	this.CssClass = 'dp-as';
	this.Style =	'.dp-as { font-family:"Monaco"; }' +
					'.dp-as .comment { color: #6480C8; font-style: italic; }' +
					'.dp-as .blockcomment { color: #143C8C; }' +
					'.dp-as .string { color: #008000; }' +
					'.dp-as .preprocessor { color: #0033ff; }' +
					
					'.dp-as .statements { color: #961E50; font-weight: bold; }' +
					'.dp-as .attributes { color: #961E50; font-weight: bold; }' +
					'.dp-as .attributePrivate { color: #961E50; font-weight: bold; font-style: italic; }' +
					'.dp-as .definitions { color: #961E50; font-weight: bold; }' +
					'.dp-as .directives { color: #961E50; font-weight: bold; }' +
					'.dp-as .primaryExpressions { color: #961E50; font-weight: normal; }' +
					'.dp-as .primaryExpressionThis { color: #961E50; font-weight: bold; }' +
					'.dp-as .operators { color: #961E50; font-weight: bold; }' +
					'.dp-as .types { color: #373737; font-weight: bold; }' +
					'.dp-as .typeVoid { color: #961E50; font-weight: bold; }' +
					'.dp-as .globalConstants { color: #961E50; font-weight: bold; }' +
					'.dp-as .globalFunctions { color: #957D47; font-weight: normal; }' +
					'.dp-as .variable { color: #961E50; font-weight: bold; }';
}

dp.sh.Brushes.AS3.prototype	= new dp.sh.Highlighter();
dp.sh.Brushes.AS3.Aliases	= ['as', 'actionscript', 'ActionScript', 'as3', 'AS3'];
