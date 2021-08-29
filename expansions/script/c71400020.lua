--梦终
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(71400020,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(c71400020.con1)
	e1:SetTarget(c71400020.tg1)
	e1:SetOperation(c71400020.op1)
	e1:SetCountLimit(1,71400020+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c71400020.filter1(c,e,tp)
	return c:IsSetCard(0x714) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400020.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71400020.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>12
end
function c71400020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),tp,POS_FACEDOWN)
	if chk==0 then return yume.YumeFieldCheckTarget(0,1,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND) and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c71400020.op1(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e),tp,POS_FACEDOWN)
	if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)>0 and yume.ActivateYumeField(tp,0,1,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND) then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71400020.filter3),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(71400020,1)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71400020.filter3),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,ft,ft,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c71400020.rmcon)
	e1:SetOperation(c71400020.rmop)
	Duel.RegisterEffect(e1,tp)
end
function c71400020.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,tp,POS_FACEDOWN)
end
function c71400020.flipop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,0,nil,tp,POS_FACEDOWN)
	if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)>0 then
		local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
		if ct>0 then
			Duel.BreakEffect()
			Duel.SetLP(tp,Duel.GetLP(tp)-ct*1000)
		end
	end
end