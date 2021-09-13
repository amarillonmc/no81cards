--自然秘境
Duel.LoadScript("c33502100.lua")
local m=33502130
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetValue(RACE_PLANT)
	c:RegisterEffect(e2)
	if not BZo_p then
		BZo_p={}
		BZo_p["Effects"]={}
	end
	BZo_p["Effects"]["c33502130"]={}
end
--e1
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2a80) and c:IsAbleToGrave()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		local txg0=Duel.GetOperatedGroup()
		local txg=txg0:GetFirst()
		if BZo_p["Effects"]["c"..txg:GetCode()]~=nil then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_CHAINING)
			e1:SetOperation(BZo_p["Effects"]["c"..txg:GetCode()])
			e1:SetLabel(e)
			e1:SetRange(LOCATION_FZONE)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(txg:GetCode(),0))
		end
	end
end
