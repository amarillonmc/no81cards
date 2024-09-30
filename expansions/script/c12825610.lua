--铳影-行动代号四
Duel.LoadScript("c12825622.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12825605)
	chiki.c4a71rankup(c,s.filter1,s.filter2,12825610)
	chiki.chikiav(c,nil,nil,s.effcon,s.target,s.operation,CATEGORY_DESTROY,12825610,1101)
end
function s.filter1(c)
	return c:GetOverlayCount()>3 and c:IsSetCard(0x4a76) and not c:IsCode(12825605) and c:IsFaceup()
end
function s.filter2(c)
	return c:IsCode(12825605)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(12825605)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end

