--万界星尘 拉尼亚凯亚
function c9910646.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,nil,nil,99)
	c:EnableReviveLimit()
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9910646.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9910646.imcon)
	e3:SetOperation(c9910646.imop)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c9910646.xmcon)
	e4:SetOperation(c9910646.xmop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c9910646.valcheck)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c9910646.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c9910646.imcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetFlagEffect(9910646)
end
function c9910646.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(9910646,0)) then
		if c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(c9910646.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(9910646,RESET_CHAIN,0,1)
		end
	end
end
function c9910646.efilter(e,re)
	return re:GetOwner()~=e:GetOwner()
end
function c9910646.valcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=0
	if c:GetSummonType()==SUMMON_TYPE_XYZ then ct=c:GetOverlayCount() end
	e:GetLabelObject():SetLabel(ct)
end
function c9910646.xmcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c9910646.xmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()-c:GetOverlayCount()
	local loc=LOCATION_ONFIELD+LOCATION_GRAVE 
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,loc,loc,c,tp)
	if ct<=0 or ct>g:GetCount() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:Select(tp,ct,ct,nil)
	Duel.HintSelection(sg)
	for tc in aux.Next(sg) do
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		tc:CancelToGrave()
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
