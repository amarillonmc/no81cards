--破灭的魔女 古尔维格
local s,id,o=GetID()
function c75081167.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcCodeFun(c,75081165,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6754),1,true,true)
	aux.AddContactFusionProcedure(c,s.cfilter,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,aux.ContactFusionSendToDeck(c))   
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c75081151.negcon)
	e1:SetOperation(c75081151.negop)
	c:RegisterEffect(e1)  
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.pencon)
	e4:SetTarget(s.pentg)
	e4:SetOperation(s.penop)
	c:RegisterEffect(e4)
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c75081151.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ev<2 then return false end
	local te=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT)
	return rp==1-tp and te and te:GetHandler():IsSetCard(0x6754) 
		and Duel.GetFlagEffect(c,id)==0
		and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev)
end
function c75081151.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(c,id)==0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.RegisterFlagEffect(c,id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
--
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
	end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and aux.NecroValleyFilter()(c) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end