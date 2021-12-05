local m=53703009
local cm=_G["c"..m]
cm.name="圆盘生物 撒旦莫亚"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.tpcost)
	e2:SetTarget(cm.tptg)
	e2:SetOperation(cm.tpop)
	c:RegisterEffect(e2)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3533) and c:IsAbleToHandAsCost()
end
function cm.tpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.tpfilter(c,tp)
	return c:IsSetCard(0x3533) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (c:IsLocation(LOCATION_HAND) or (((c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()) or c:IsLocation(LOCATION_GRAVE)) and Duel.GetTurnPlayer()==tp))
end
function cm.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tpfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,tp) end
end
function cm.tpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.GetFieldCard(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.tpfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
end
