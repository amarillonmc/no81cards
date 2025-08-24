--正义-“织梦者”
function c67201501.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit() 
	aux.AddCodeList(c,67201503,67201510)  
	--aux.AddCodeList(c,67201510)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201501,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67201501)
	e1:SetTarget(c67201501.thtg)
	e1:SetOperation(c67201501.thop)
	c:RegisterEffect(e1)
	c67201501.pendulum_effect=e1 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67201501,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,67201502)
	e4:SetCondition(c67201501.condition)
	e4:SetTarget(c67201501.rmtg)
	e4:SetOperation(c67201501.rmop)
	c:RegisterEffect(e4)
end
function c67201501.thfilter(c)
	return c:IsSetCard(0xc67b) and c:IsAbleToHand()
		and c:GetType()==TYPE_SPELL+TYPE_RITUAL 
end
function c67201501.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201501.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67201501.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67201501.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67201501.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c67201501.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(c67201501.pcfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c67201501.pcfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsFaceup() and aux.IsCodeListed(c,67201503) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()) then return false end
	local te=c.pendulum_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c67201501.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==67201501 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c67201501.retop)
		Duel.RegisterEffect(e1,tp)
		local sg=Duel.SelectMatchingCard(tp,c67201501.pcfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
		if #sg>0 then
			local tc=sg:GetFirst()
			local te=tc.pendulum_effect
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end
function c67201501.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
