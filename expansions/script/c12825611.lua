--铳影-行动代号五
Duel.LoadScript("c17035101.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12825606)
	chiki.c4a71rankup(c,s.filter1,s.filter2,12825611)
	chiki.chikiav(c,LOCATION_GRAVE,nil,s.effcon,s.target,s.operation,CATEGORY_DESTROY,12825611,1100)
end
function s.filter1(c)
	return c:GetOverlayCount()>1 and c:IsSetCard(0x4a76) and not c:IsCode(12825606) and c:IsFaceup()
end
function s.filter2(c)
	return c:IsCode(12825606)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(12825606)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler())
end
function s.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
