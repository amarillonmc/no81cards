--铳影-行动代号三
xpcall(function() require("expansions/script/c17035101") end,function() require("script/c17035101") end)
function c12825609.initial_effect(c)
	aux.AddCodeList(c,12825604)
	chiki.c4a71rankup(c,c12825609.filter1,c12825609.filter2,12825609)
	chiki.chikiav(c,nil,nil,c12825609.effcon,c12825609.target,c12825609.operation,nil,12825609,1102)
end
function c12825609.filter1(c)
	return c:IsSetCard(0x4a71) and not c:IsCode(12825604)
end
function c12825609.filter2(c)
	return c:IsCode(12825604)
end
function c12825609.cfilter(c)
	return c:IsFaceup() and c:IsCode(12825604)
end
function c12825609.effcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c12825609.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler())
end
function c12825609.setfilter(c)
	return c:IsSetCard(0x4a71) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
end
function c12825609.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12825609.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c12825609.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c12825609.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end