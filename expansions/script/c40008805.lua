--宝石马
function c40008805.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c40008805.matfilter,1,1)
	c:EnableReviveLimit()  
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008805,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,40008805)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c40008805.cost)
	e1:SetOperation(c40008805.operation)
	c:RegisterEffect(e1)  
end
function c40008805.matfilter(c)
	return c:IsLinkRace(RACE_ROCK) and not c:IsLinkType(TYPE_LINK)
end
function c40008805.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_ROCK) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:GetAttack()>0
end
function c40008805.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008805.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40008805.cfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.SendtoGrave(g,REASON_COST)
end
function c40008805.spfilter(c,e,tp)
	return c:IsSetCard(0x47) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008805.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local ct=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c40008805.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40008805,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
end