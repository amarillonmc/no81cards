--念力飞行大师
function c9910200.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c9910200.lcheck)
	c:EnableReviveLimit()
end
function c9910200.lcheck(g)
	return g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_BOTTOM)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_LEFT)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_RIGHT)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP)
end
