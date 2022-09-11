--铳影-行动代号四
xpcall(function() require("expansions/script/c17035101") end,function() require("script/c17035101") end)
function c12825610.initial_effect(c)
	aux.AddCodeList(c,12825605)
	chiki.c4a71rankup(c,c12825610.filter1,c12825610.filter2,12825610)
	chiki.chikiav(c,nil,nil,c12825610.effcon,c12825610.target,c12825610.operation,CATEGORY_DESTROY,12825610,1101)
end
function c12825610.filter1(c)
	return c:GetOverlayCount()>3 and c:IsSetCard(0x4a71) and not c:IsCode(12825605)
end
function c12825610.filter2(c)
	return c:IsCode(12825605)
end
function c12825610.cfilter(c)
	return c:IsFaceup() and c:IsCode(12825605)
end
function c12825610.effcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c12825610.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler())
end
function c12825610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c12825610.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end

