--真伪莫辨
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010261)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(cm.smcost)
	e3:SetTarget(cm.smtg)
	e3:SetOperation(cm.smop)
	c:RegisterEffect(e3)
end
function cm.filter(c,tp)
	return (c:IsCode(60010261) or (c:IsRace(RACE_ILLUSION) and c:IsLevelBelow(4) and Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_MZONE,0,1,nil))) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or Duel.IsExistingMatchingCard(cm.bsfil,tp,LOCATION_SZONE,0,1,nil)
end
function cm.fil2(c)
	return c:IsCode(60010261) and c:IsFaceup()
end
function cm.bsfil(c)
	return c:IsCode(60010262,60010263,60010264,60010265) and c:IsFaceup()
end
function cm.bsfil1(c)
	return c:IsCode(60010262) and c:IsFaceup()
end
function cm.bsfil2(c)
	return c:IsCode(60010264) and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local t=0
		local mg=Duel.GetOperatedGroup()
		if Duel.IsExistingMatchingCard(cm.bsfil1,tp,LOCATION_SZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dc=Duel.SelectMatchingCard(tp,cm.bsfil1,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil):GetFirst()
			if Duel.Destroy(dc,REASON_EFFECT)~=0 and mg:GetFirst():GetAttack()~=0 then
				t=t+1
				Duel.Damage(1-tp,mg:GetFirst():GetAttack(),REASON_EFFECT)
			end
		end
		if Duel.IsExistingMatchingCard(cm.bsfil2,tp,LOCATION_SZONE,0,1,nil) and Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dc=Duel.SelectMatchingCard(tp,cm.bsfil2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil):GetFirst()
			if Duel.Destroy(dc,REASON_EFFECT)~=0 then
				t=t+1
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_CHAINING)
				e1:SetOperation(cm.actop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			end
		end
		if t~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:GetHandler():IsRace(RACE_ILLUSION) then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.smter(c,tp)
	return c:IsFaceup() and c:IsCode(60010261) and Duel.IsExistingMatchingCard(cm.smter2,tp,LOCATION_MZONE,0,1,c,c:GetAttribute())
end
function cm.smter2(c,attr)
	return c:IsFaceup() and not c:IsAttribute(attr)
end
function cm.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smter,tp,LOCATION_MZONE,0,1,nil,tp) end
end
function cm.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(cm.smter,tp,LOCATION_MZONE,0,1,nil,tp) then return end
	local tc=Duel.SelectMatchingCard(tp,cm.smter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	local sc=Duel.SelectMatchingCard(tp,cm.smter2,tp,LOCATION_MZONE,0,1,1,nil,tc:GetAttribute()):GetFirst()
	if not sc then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetRange(0xff)
	e1:SetValue(sc:GetAttribute())
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	tc:RegisterEffect(e1)
end