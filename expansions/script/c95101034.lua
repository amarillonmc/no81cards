--妖精集群
function c95101034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetCountLimit(1,95101034+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c95101034.target)
	e1:SetOperation(c95101034.activate)
	c:RegisterEffect(e1)
end
function c95101034.tfilter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsRace(RACE_FAIRY) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c95101034.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c95101034.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95101034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c95101034.tfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c95101034.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c95101034.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c95101034.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if ft<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=c:GetCode()
		local g=Duel.GetMatchingGroup(c95101034.spfilter,tp,LOCATION_DECK,0,nil,e,tp,code)
		local ct=g:GetCount()
		if ct==0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if ct>ft then ct=ft end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
