function c119150521.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,119150520+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c119150521.spcon)
	e1:SetCost(c119150521.spcost)
	e1:SetTarget(aux.TRUE)
	e1:SetOperation(c119150521.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,119150521)
	e2:SetTarget(c119150521.target2)
	e2:SetOperation(c119150521.operation2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c119150521.target3)
	e3:SetOperation(c119150521.operation3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c119150521.regop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c119150521.damcon)
	e5:SetOperation(c119150521.damop)
	c:RegisterEffect(e5)
end
function c119150521.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end
function c119150521.costfilter(c)
	return c:IsSetCard(0xfb) and not c:IsPublic() and c:IsDiscardable()
end
function c119150521.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and Duel.IsExistingMatchingCard(c119150521.costfilter,tp,LOCATION_HAND,0,2,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c119150521.costfilter,tp,LOCATION_HAND,0,2,2,c)
	g:AddCard(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tg=g:FilterSelect(tp,Card.IsDiscardable,2,2,nil)
	Duel.SendtoGrave(tg,REASON_COST+REASON_DISCARD)
end
function c119150521.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SKIP_BP)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	Duel.RegisterEffect(e2,tp)
end
function c119150521.desfilter(c,tp)
	if c:IsFacedown() or not c:IsAbleToHand() then return false end
	return c:IsSetCard(0xfb) and (c:IsLocation(LOCATION_MZONE) or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c119150521.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c119150521.desfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c119150521.desfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c119150521.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c119150521.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)==1 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c119150521.filter(c)
	return c:IsSetCard(0xfb) and not c:IsCode(119150521) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function c119150521.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c119150521.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c119150521.operation3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c119150521.filter,tp,LOCATION_HAND,0,1,1,nil)
	if not g then return end
	Duel.Summon(tp,g:GetFirst(),true,nil)
end
function c119150521.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard(0xfb) and not rc:IsType(TYPE_LINK) then
		e:GetHandler():RegisterFlagEffect(119150521,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
	end
end
function c119150521.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return c:GetFlagEffect(119150521)~=0 and rc:IsSetCard(0xfb) and not rc:IsType(TYPE_LINK)
end
function c119150521.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,119150521)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end