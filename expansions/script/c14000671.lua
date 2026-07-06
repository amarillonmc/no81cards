--混调色-深色
local s,id,o=GetID()
s.named_with_Combine_Color=1
function s.cc(c)
	if not c then return false end
	if _G["Combine_Color_Global_Codes"] and (_G["Combine_Color_Global_Codes"][c:GetCode()] or _G["Combine_Color_Global_Codes"][c:GetOriginalCode()]) then return true end
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Combine_Color
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.negcon)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
end
function s.ffilter(c,fc,sub,mg,sg)
	return s.cc(c) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function s.atkval(e,c)
	local g=c:GetMaterial()
	if g:GetCount()==0 then return 0 end
	local mt={}
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_MONSTER) then mt[TYPE_MONSTER]=true end
		if tc:IsType(TYPE_SPELL) then mt[TYPE_SPELL]=true end
		if tc:IsType(TYPE_TRAP) then mt[TYPE_TRAP]=true end
	end
	local ct=0
	if mt[TYPE_MONSTER] then ct=ct+1 end
	if mt[TYPE_SPELL] then ct=ct+1 end
	if mt[TYPE_TRAP] then ct=ct+1 end
	return g:GetCount()*ct*100
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not (rp==1-tp and Duel.IsChainDisablable(ev)) then return false end
	if not (Duel.GetTurnPlayer()==tp or Duel.GetCurrentPhase()==PHASE_BATTLE) then return false end
	if e:GetHandler():GetFlagEffect(id)>0 then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_HAND or loc==LOCATION_GRAVE
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			if tc:IsOnField() and tc:IsFacedown() then
				Duel.ConfirmCards(1-tp,tc)
			end
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function s.tgfilter(c)
	return s.cc(c) and c:IsAbleToGrave()
end