--铳影-行动代号三
Duel.LoadScript("c12825622.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12825604)
	chiki.c4a71rankup(c,s.filter1,s.filter2,12825609)
	chiki.chikiav(c,nil,nil,s.effcon,s.target,s.operation,nil,12825609,1102)
end
function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x4a76) and not c:IsCode(12825604)
end
function s.filter2(c)
	return c:IsCode(12825604)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(12825604)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler())
end
function s.setfilter(c)
	return c:IsSetCard(0x4a76) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end