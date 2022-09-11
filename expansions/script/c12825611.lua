--铳影-行动代号五
xpcall(function() require("expansions/script/c17035101") end,function() require("script/c17035101") end)
function c12825611.initial_effect(c)
	aux.AddCodeList(c,12825606)
	chiki.c4a71rankup(c,c12825611.filter1,c12825611.filter2,12825611)
	chiki.chikiav(c,LOCATION_GRAVE,nil,c12825611.effcon,c12825611.target,c12825611.operation,CATEGORY_DESTROY,12825611,1100)
end
function c12825611.filter1(c)
	return c:GetOverlayCount()>1 and c:IsSetCard(0x4a71) and not c:IsCode(12825606)
end
function c12825611.filter2(c)
	return c:IsCode(12825606)
end
function c12825611.cfilter(c)
	return c:IsFaceup() and c:IsCode(12825606)
end
function c12825611.effcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c12825611.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler())
end
function c12825611.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c12825611.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c12825611.desfilter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c12825611.desfilter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c12825611.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c12825611.desfilter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
