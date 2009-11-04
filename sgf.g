parser SGF:
    ignore:	'\\s+'


    ### Go-specific tokens: http://www.red-bean.com/sgf/go.html ###
    token Point:	'[a-zA-Z]{2}'
    token Move:		'[a-zA-Z]{2}'
    token Stone:	'[a-zA-Z]{2}'

    ### SGF Tokens as specified in http://www.red-bean.com/sgf/sgf4.html ###

    token PropID:	'([a-z]*[A-Z]){1,2}[a-z]*'
    token Number:	'[+-]?[0-9]+'
    token Real:		'[+-]?[0-9]+(\\.[0-9]+)?'
    token Color:	'(B|W)'
    token Text:		'[^\\]]*' # In YAPPS, the longest matches take precedence, 
			     # if they're both the same length, then the 
			     # first one listed in the grammar is used.


    rule GameTree:	"\\(" 			{{ res = [] }}
			(Node 			{{ res.append(Node) }})+
			(GameTree 		{{ res.append(GameTree) }})*
			"\\)"			{{ return res }}

    rule Node:		";"			{{ res = [] }}
			(Property		{{ res.append(Property) }}
			)+			{{ return dict(res) }}

    rule Property:	PropID			{{ res = (PropID, []) }}
			("\\[" ValueType "\\]"	{{ res[1].append(ValueType) }}
			)+			{{ return res }}

    rule ValueType:	Number			{{ return int(Number) }}
			| Real			{{ return float(Real) }}
			| Color			{{ return Color }}
			| Move			{{ return (Move[0].islower() and ord(Move[0])-96 or ord(Move[0])-64, Move[1].islower() and ord(Move[1])-96 or ord(Move[1])-64) }}
			| Text			{{ return Text }}
			| '' 			{{ return None }}

