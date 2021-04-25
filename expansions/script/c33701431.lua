--MINMES
local m=33701431
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,33701424)
	--change code
	aux.EnableChangeCode(c,33701424,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage conversion
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EVENT_DAMAGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.reccon)
	e2:SetOperation(cm.recop)
	c:RegisterEffect(e2)
end
function cm.reccop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and rc~=e:GetHandler() and (rc:IsCode(33701424) or rc:IsSetCard(9449))
end
function cm.tgfilter(c)
	return c:IsCode(33701424) and c:IsAbleToGrave()
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_HAND,0,e:GetHandler())
	if g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(g1,REASON_EFFECT)
		Duel.Recover(ep,ev*2,REASON_EFFECT)
	else
		Duel.Recover(ep,ev,REASON_EFFECT)
	end
end
