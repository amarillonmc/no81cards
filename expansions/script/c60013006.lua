-- 剑之雨
--Duel.LoadScript("c.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,7))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,8))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.hcon)
	e2:SetTarget(cm.htg)
	e2:SetOperation(cm.hop)
	c:RegisterEffect(e2)
end
cm.isChaosZeroNightmare=true
function cm.fil(c)
	return c:IsCode(60013002) and c:IsFaceup()
end
function cm.s3fil(c)
	return c:IsCode(60013005) and c:IsAbleToHand()
end
function cm.s4fil(c)
	return c:IsCode(60013008)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=false
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then b1=true end
	local b2=false
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	local b3=false
	if Duel.IsExistingMatchingCard(cm.s3fil,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	local b4=false
	if Duel.IsExistingMatchingCard(cm.s4fil,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b4=true end
	if chk==0 then return b1 or b2 or b3 or b4 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then b1=true end
	local b2=false
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	local b3=false
	if Duel.IsExistingMatchingCard(cm.s3fil,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	local b4=false
	if Duel.IsExistingMatchingCard(cm.s4fil,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b4=true end
	if not b1 and not b2 and not b3 and not b4 then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,1)},
		{b2,aux.Stringid(m,2)},
		{b3,aux.Stringid(m,3)},
		{b4,aux.Stringid(m,4)})
	if op==2 or op==3 or op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
		if not Duel.Destroy(dg,REASON_EFFECT) then return end
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Select(tp,1,1,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Select(tp,1,1,nil)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.s3fil,tp,LOCATION_GRAVE,0,1,99,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.GetMatchingGroup(cm.s4fil,tp,LOCATION_HAND,0,nil):Select(tp,1,1,nil)
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT)~=0 and Duel.Destroy(dg,REASON_EFFECT)~=0 then
			if Duel.GetTurnPlayer()==tp then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(0,1)
				e1:SetValue(cm.actlimit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.hfil(c)
	return c:IsCode(60013005) and c:IsAbleToHand()
end
function cm.hcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and Duel.IsExistingMatchingCard(cm.hfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(cm.hfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return end

	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_PUBLIC)
	e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e11)

	local b1=Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil)
	local op=aux.SelectFromOptions(tp,
		{true,aux.Stringid(m,1)},
		{b1,aux.Stringid(m,5)})
	if op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
		if not Duel.Destroy(dg,REASON_EFFECT) then return end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.hfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,op,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end








