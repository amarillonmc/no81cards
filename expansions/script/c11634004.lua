--海晶少女浪潮
local m=11634004
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
end
function cm.f(c) 
	return c:IsFaceup() and c:IsSetCard(0x12b)
end 
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(cm.f,tp,LOCATION_ONFIELD,0,nil)
	local gt=Duel.GetMatchingGroupCount(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and gt>0 end   
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(cm.f,tp,LOCATION_ONFIELD,0,nil)
	local dg=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	local count=ct
	while count>0 do
		cm.rap(e,tp,dg)
		count=count-1
	end
	dg=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
	Duel.AdjustAll()
	local ag=dg:Filter(Card.IsAttack,nil,0)
	if #ag>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m) 
		Duel.BreakEffect()
		Duel.Destroy(ag,REASON_EFFECT)
	end
end
function cm.rap(e,tp,g)
	local c=e:GetHandler()
	local dg=g:Clone()
	if #dg>0 then
		for tc in aux.Next(dg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-500)
			tc:RegisterEffect(e1)
		end
		dg=g:Clone()
		local act=dg:FilterCount(Card.IsAttack,nil,0)
		if act>0 then
			Duel.BreakEffect()
			if Duel.IsPlayerCanDiscardDeck(1-tp,1) then
				Duel.Hint(HINT_CARD,0,m) 
				Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
				local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				if #og>0 then
					for tac in aux.Next(og) do
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_CANNOT_TRIGGER)
						e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
						e1:SetDescription(aux.Stringid(m,1))
						e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
						tac:RegisterEffect(e1,true)
					end
				end
			end
		end
	end
end
--act in hand
function cm.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12b) and c:IsLinkAbove(3)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.hcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

