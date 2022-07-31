local m=31400120
local cm=_G["c"..m]
cm.name="不死的贪欲吞噬者"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),8,3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(cm.eatop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(cm.adval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.reptg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetOperation(cm.immop)
	c:RegisterEffect(e5)
end
function cm.eatop(e,tp,eg,ep,ev,re,r,rp)
	local num=eg:FilterCount(cm.eatfilter,nil,tp)
	if num==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_HAND+LOCATION_ONFIELD,num,num,nil)
	local ovg=mg:Clone()
	mg:ForEach(
		function(tc)
			if tc:IsImmuneToEffect(e) then
				ovg:RemoveCard(tc)
			end
		end
	)
	ovg:ForEach(
		function(tc)
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
		end
	)
	Duel.Overlay(e:GetHandler(),ovg)
end
function cm.eatfilter(c,tp)
	return c:IsLocation(LOCATION_HAND) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function cm.adval(e,c)
	return e:GetHandler():GetOverlayCount()*500
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter)
		e1:SetLabelObject(re)
		e1:SetReset(RESET_EVENT+RESET_CHAIN)
		c:RegisterEffect(e1)
	end
end
function cm.efilter(e,re)
	return re==e:GetLabelObject()
end