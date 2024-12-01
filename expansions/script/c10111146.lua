function c10111146.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10111146)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c10111146.target)
	e1:SetOperation(c10111146.activate)
	c:RegisterEffect(e1)
 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111146,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101111460)
	e2:SetCondition(c10111146.spcon2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10111146.sptg2)
	e2:SetOperation(c10111146.spop2)
	c:RegisterEffect(e2)
end
function c10111146.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c10111146.tgfilter(c)
	return c:IsSetCard(0x1a4) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c10111146.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10111146.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10111146.posfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c10111146.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10111146.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10111146.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c10111146.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c10111146.spfilter(c,e,tp)
	return c:IsSetCard(0x1a4) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10111146.spcon2(e,tp,eg,ep,ev,re,r,rp)
	 local a=Duel.GetAttacker()
	 return a:IsControler(1-tp)
end
function c10111146.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10111146.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10111146.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10111146.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
		local at=Duel.GetAttacker()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,tc)
		end
	end
end