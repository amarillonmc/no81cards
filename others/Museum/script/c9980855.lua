--最后的希望
function c9980855.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c9980855.cost)
	e1:SetCondition(c9980855.condition)
	e1:SetTarget(c9980855.target)
	e1:SetOperation(c9980855.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980855,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9980855)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9980855.indtg)
	e2:SetOperation(c9980855.indop)
	c:RegisterEffect(e2)
end
function c9980855.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c9980855.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5bc2) and c:IsDiscardable()
end
function c9980855.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980855.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9980855.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9980855.filter(c,e,tp)
	return c:IsSetCard(0x5bc2) and c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9980855.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c9980855.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9980855.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9980855.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980855.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c9980855.indfilter(c)
	return c:GetFlagEffect(9980855)==0 and c:IsSetCard(0x5bc2) and c:IsFaceup()
end
function c9980855.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9980855.indfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980855.indfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9980855.indfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9980855.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(9980855,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,0)
	end
end
