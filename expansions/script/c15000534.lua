local m=15000534
local cm=_G["c"..m]
cm.name="灵核机的铸型·荣耀"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),1,1)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.negcon)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,15000534)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.r1tg)
	e3:SetValue(cm.rval)
	c:RegisterEffect(e3)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetLeftScale()
	return e:GetHandler():GetFlagEffect(15000534)==0 and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and (re:GetHandler():GetLevel()<=x or (re:GetHandler():IsType(TYPE_PENDULUM) and re:GetHandler():GetLeftScale()<=x)) and Duel.IsChainDisablable(ev)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		e:GetHandler():RegisterFlagEffect(15000534,RESET_EVENT+RESETS_STANDARD,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f3e) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.r1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and re~=e end
	if Duel.SelectYesNo(tp,aux.Stringid(15000534,0)) then
		if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			--send replace
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EFFECT_SEND_REPLACE)
			e3:SetRange(LOCATION_PZONE)
			e3:SetTarget(cm.r2tg)
			e3:SetValue(cm.rval)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
			c:RegisterFlagEffect(15000538,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(15000538,1))
		end
		return true
	else return false end
end
function cm.rval(e,c)
	return false
end
function cm.r2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_PZONE) and c:IsFaceup() and c:IsAbleToExtra() and re~=e end
	if c:IsLocation(LOCATION_PZONE) and c:IsFaceup() and c:IsAbleToExtra() and re~=e then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT+REASON_REDIRECT)
		return true
	else return false end
end