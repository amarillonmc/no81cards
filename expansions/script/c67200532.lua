--挣脱的珊海环舰
function c67200532.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c67200532.matfilter,1,1)
	c:EnableReviveLimit()
end
function c67200532.matfilter(c)
	return c:IsLinkSetCard(0x3675) and not c:IsLinkType(TYPE_LINK)
end