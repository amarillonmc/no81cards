-- 万人的英雄
Duel.LoadScript("c60013002.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60013001)
	--安息
	Heidemarie.AnXi(c)
	--连结
	Heidemarie.LianJie(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.isChaosZeroNightmare=true
function cm.fil(c)
	return c:IsCode(60013002) and c:IsFaceup()
end
function cm.dcfil(c)
	return (c:IsPublic() or aux.IsCodeListed(c,60013001)) and c:IsDiscardable()
end
function cm.s4fil(c)
	return aux.IsCodeListed(c,60013001) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,1,c) and Duel.IsPlayerCanDraw(tp,2) then b1=true end
	local b2=false
	if Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	local b3=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,1,c) and Duel.IsPlayerCanDraw(tp,3) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	local b4=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingMatchingCard(cm.s4fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b4=true end
	local b5=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,1,c) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b5=true end
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,1,c) and Duel.IsPlayerCanDraw(tp,2) then b1=true end
	local b2=false
	if Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	local b3=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,1,c) and Duel.IsPlayerCanDraw(tp,3) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	local b4=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,1,c) and Duel.IsExistingMatchingCard(cm.s4fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,c) then b4=true end
	local b5=false
	if Duel.IsExistingMatchingCard(cm.dcfil,tp,LOCATION_HAND,0,1,c) and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_SZONE,0,1,nil) then b5=true end
	if not b1 and not b2 and not b3 and not b4 and not b5 then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,1)},
		{b2,aux.Stringid(m,2)},
		{b3,aux.Stringid(m,3)},
		{b4,aux.Stringid(m,4)},
		{b5,aux.Stringid(m,5)})
	if op==2 or op==3 or op==4 or op==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
		if not Duel.Destroy(dg,REASON_EFFECT) then return end
	end
	if op==1 or op==3 or op==4 or op==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local dg=Duel.GetMatchingGroup(cm.dcfil,tp,LOCATION_HAND,0,nil):Select(tp,1,1,nil)
		if not Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD) then return end
	end

	if op==1 or op==2 then 
		Duel.Draw(tp,2,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	elseif op==3 then 
		Duel.Draw(tp,3,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	elseif op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.s4fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local g=Duel.GetOperatedGroup()
			for tc in aux.Next(g) do
				tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	elseif op==5 then
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			local g=Duel.GetOperatedGroup()
			for tc in aux.Next(g) do
				tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(cm.atktg)
			e1:SetValue(4000)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_PIERCE)
			e2:SetValue(DOUBLE_DAMAGE)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.atktg(e,c)
	return c:IsCode(60013001) and c:IsFaceup()
end









