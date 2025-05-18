--沉默的毒骑士 影潜者 莫达利昂
function c40011510.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	--transform
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c40011510.transcon)
	e2:SetOperation(c40011510.transop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,40011510)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e3:SetCost(c40011510.setcost)
	e3:SetTarget(c40011510.settg)
	e3:SetOperation(c40011510.setop)
	c:RegisterEffect(e3)
end
function c40011510.dfilter(c)
	return c:IsSetCard(0xaf1b) and c:IsDiscardable()
end
function c40011510.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c40011510.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c40011510.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c40011510.setfilter(c)
	return c:IsSetCard(0xaf1b) and not c:IsCode(40011510) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c40011510.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40011510.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c40011510.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c40011510.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(TYPE_TRAP)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(40011510,0))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c40011510.transcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalCode()==40011510 and c:IsLocation(LOCATION_SZONE) and c:IsFacedown()
end
function c40011510.transop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(9911631,true)
	c:ReplaceEffect(9911631,0,0)
end
