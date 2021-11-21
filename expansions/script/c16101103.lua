--克尔苏加德
function c16101103.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),8,2,c16101103.ovfilter,aux.Stringid(16101103,6))
	c:EnableReviveLimit()
end
function c16101103.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_LINK) and c:IsLinkAbove(3)
end