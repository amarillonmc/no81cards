--Heavenly Maid : Cleaning
function c33700207.initial_effect(c)
	--For the rest of the turn after this card is activated, if card(s) are discarded or sent to GY from your oppponent's hand, You can send "Heavenly Maid" monster(s) you control to the GY, up to the number of cards discarded/sent to GY, then add the same number of those card(s) to your Hand, also reveal those cards. These revealed card(s) are banished when they would be sent to the GY. You can only activate 1 "Heavenly Maid : Cleaning" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33700207+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c33700207.activate)
	c:RegisterEffect(e1)
end
function c33700207.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(c33700207.drop)
	e1:SetValue(c33700207.drval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
--[[
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c33700207.drcon1)
	e1:SetOperation(c33700207.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e5=e1:Clone()
	e5:SetCode(EVENT_REMOVE)
	Duel.RegisterEffect(e5,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c33700207.regcon)
	e2:SetOperation(c33700207.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e4=e2:Clone()
	e4:SetCode(EVENT_REMOVE)
	Duel.RegisterEffect(e4,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c33700207.drcon2)
	e3:SetOperation(c33700207.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
]]
end
function c33700207.repfilter(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_HAND) and (c:GetDestination()==LOCATION_GRAVE or c:IsReason(REASON_DISCARD))
end
function c33700207.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c33700207.hfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return eg:IsExists(c33700207.repfilter,1,nil,tp) and g:GetCount()>0 end
	local msg=HINTMSG_TOGRAVE
	if e:GetCode()==EVENT_REMOVE then msg=HINTMSG_DISCARD end
	if Duel.SelectYesNo(tp,msg) then
		local g=eg:Filter(c33700207.repfilter,nil,tp)
		local ct=g:GetCount()
		local sg=g:Select(tp,1,ct,nil)
		local sct=sg:GetCount()
		if sct<g:GetCount() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g=g:Select(tp,1,sct,nil)
		end
		Duel.Hint(HINT_CARD,0,33700207)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetOwner())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetOwner())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCondition(function(e) return e:GetHandler():IsPublic() end)
			e2:SetValue(LOCATION_REMOVED)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
		end
		return true
	else return false end
end
function c33700207.drval(e,c)
	return false
end
function c33700207.cfilter(c,tp)
	return c:GetPreviousControler()==1-tp and (c:IsLocation(LOCATION_GRAVE) or c:IsReason(REASON_DISCARD)) and c:IsPreviousLocation(LOCATION_HAND)
end
function c33700207.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700207.cfilter,1,nil,tp) 
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c33700207.hfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x444) and c:IsAbleToGraveAsCost()
end
function c33700207.drop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33700207.hfilter,tp,LOCATION_MZONE,0,nil)
	local msg=HINTMSG_TOGRAVE
	if e:GetCode()==EVENT_REMOVE then msg=HINTMSG_DISCARD end
	if g:GetCount()==0 or not Duel.SelectYesNo(tp,msg) then return end
	local sg=g:Select(tp,1,eg:GetCount(),nil)
	local ct,tg=sg:GetCount()
	if ct<eg:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tg=eg:Select(tp,1,ct2,nil)
	else tg=eg:Clone() end
	Duel.Hint(HINT_CARD,0,33700207)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.SendtoHand(tg,tp,REASON_EFFECT)==0 then return end
	local dg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	for tc in aux.Next(dg) do
		local e1=Effect.CreateEffect(e:GetOwner())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetOwner())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCondition(function(e) return e:GetHandler():IsPublic() end)
		e2:SetValue(LOCATION_REMOVED)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
function c33700207.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33700207.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp,33700207)==0 
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c33700207.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,33700207,RESET_CHAIN,0,1)
end
function c33700207.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33700207)>0
end
function c33700207.drop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,33700207)
	local g=Duel.GetMatchingGroup(c33700207.hfilter,tp,LOCATION_MZONE,0,nil)
	local msg=HINTMSG_TOGRAVE
	if e:GetCode()==EVENT_REMOVE then msg=HINTMSG_DISCARD end
	if g:GetCount()==0 or not Duel.SelectYesNo(tp,msg) then return end
	local sg=g:Select(tp,1,eg:GetCount(),nil)
	local ct,tg=sg:GetCount()
	if ct<eg:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tg=eg:Select(tp,1,ct2,nil)
	else tg=eg:Clone() end
	Duel.Hint(HINT_CARD,0,33700207)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.SendtoHand(tg,tp,REASON_EFFECT)==0 then return end
	local dg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	for tc in aux.Next(dg) do
		local e1=Effect.CreateEffect(e:GetOwner())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetOwner())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e2:SetCondition(function(e) return e:GetHandler():IsPublic() end)
		e2:SetValue(LOCATION_REMOVED)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
