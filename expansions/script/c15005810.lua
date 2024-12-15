local m=15005810
local cm=_G["c"..m]
cm.name="天翎渊之鹭"
function cm.initial_effect(c)
	--Public
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spscon)
	e2:SetTarget(cm.spstg)
	e2:SetOperation(cm.spsop)
	c:RegisterEffect(e2)
end
function cm.trigfilter(c,tp)
	return c:IsSetCard(0x5f43) and c:IsControler(tp) and not c:IsReason(REASON_DRAW)
		and not (c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and not c:IsPublic())
		and (not c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) or (c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) and c:IsPublic()))
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.trigfilter,1,nil,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cm.pubfilter(c)
	return c:IsSetCard(0x5f43) and not c:IsPublic()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,0,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local tc=Duel.SelectMatchingCard(tp,cm.pubfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if not tc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetDescription(66)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	tc:RegisterEffect(e1)
end
function cm.spscon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.tgfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsAbleToGrave()
end
function cm.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPublic() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(cm.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
	end
end