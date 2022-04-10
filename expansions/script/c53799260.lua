local m=53799260
local cm=_G["c"..m]
cm.name="深陷泥沼"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(cm.chop)
	c:RegisterEffect(e1)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsLocation(LOCATION_FZONE) or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	local op=re:GetOperation()
	local repop=function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:GetEquipTarget() then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
			if tc and ((Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:CheckUniqueOnField(tp)) or (c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5)) then
				if c:IsStatus(STATUS_LEAVE_CONFIRMED) then c:CancelToGrave() end
				Duel.Equip(tp,c,tc)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_EQUIP_LIMIT)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(function(e,c)return c==e:GetLabelObject()end)
				e2:SetLabelObject(tc)
				c:RegisterEffect(e2)
			else Duel.SendtoGrave(tc,REASON_RULE) end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	re:SetOperation(repop)
end
