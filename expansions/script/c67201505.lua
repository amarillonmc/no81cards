--世界-“秘偶”
function c67201505.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--revive limit
	c:EnableReviveLimit()
	--aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
	aux.AddCodeList(c,67201503,67201509)
	--aux.AddCodeList(c,67201509)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67201505)
	e1:SetTarget(c67201505.target)
	e1:SetOperation(c67201505.activate)
	c:RegisterEffect(e1)
	c67201505.pendulum_effect=e1 
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201505,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCountLimit(1)
	e3:SetTarget(c67201505.cttg)
	e3:SetOperation(c67201505.ctop)
	c:RegisterEffect(e3) 
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67201505,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,67201506)
	--e4:SetCondition(c67201505.condition)
	e4:SetTarget(c67201505.rmtg)
	e4:SetOperation(c67201505.rmop)
	c:RegisterEffect(e4)  
end
function c67201505.filter(c,tp)
	return aux.IsCodeListed(c,67201503) and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(c67201505.filter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c67201505.filter2(c,mc)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand() and aux.IsCodeListed(mc,c:GetCode())
end
function c67201505.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201505.filter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	local dg=Duel.GetMatchingGroup(c67201505.filter,tp,LOCATION_ONFIELD,0,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67201505.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c67201505.filter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local mg=Duel.GetMatchingGroup(c67201505.filter2,tp,LOCATION_DECK,0,nil,g:GetFirst())
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
--
function c67201505.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==c and tc and tc:IsControlerCanBeChanged(false) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c67201505.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.GetControl(tc,tp)~=0 then
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(67201505,3))
			e4:SetCategory(CATEGORY_CONTROL)
			e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e4:SetCode(EVENT_BATTLE_START)
			e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e4:SetCountLimit(1)
			e4:SetTarget(c67201505.cttg)
			e4:SetOperation(c67201505.ctop)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4,true)
		end
	end
end
--
function c67201505.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(c67201505.pcfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c67201505.pcfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsFaceup() and aux.IsCodeListed(c,67201503) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()) then return false end
	local te=c.pendulum_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c67201505.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c67201505.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		if sg:GetFirst():IsLocation(LOCATION_HAND) then
			local tc=sg:GetFirst()
			local te=tc.pendulum_effect
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end