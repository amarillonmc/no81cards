local m=53763009
local cm=_G["c"..m]
cm.name="牢狱之神 兰柯珞克"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,7,2,nil,nil,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e1:SetLabelObject(sg)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.atkcon1)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.ctcon1)
	e4:SetValue(cm.ctval1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCondition(cm.atkcon2)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCondition(cm.ctcon2)
	e6:SetValue(cm.ctval2)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCondition(cm.ctcon3)
	e7:SetValue(cm.ctval3)
	c:RegisterEffect(e7)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsActiveType(TYPE_MONSTER) then return false end
	local ex,tg=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	return ex and tg:IsContains(re:GetHandler()) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetValue(re:GetHandler():GetAttribute())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc and tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			local sg=e:GetLabelObject()
			if c:GetFlagEffect(m)==0 or Duel.GetCurrentPhase()==PHASE_STANDBY then
				if c:GetFlagEffect(m)==0 then sg:Clear() end
				if Duel.GetCurrentPhase()==PHASE_STANDBY then tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,0,1) end
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e2:SetLabelObject(e)
				e2:SetCountLimit(1)
				if Duel.GetCurrentPhase()==PHASE_STANDBY then
					e2:SetLabel(Duel.GetTurnCount())
					e2:SetCondition(cm.retcon)
					e2:SetReset(RESET_PHASE+PHASE_STANDBY,2)
					c:RegisterFlagEffect(m,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_STANDBY,0,2)
				else
					e2:SetReset(RESET_PHASE+PHASE_STANDBY)
					c:RegisterFlagEffect(m,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_STANDBY,0,1)
				end
				e2:SetOperation(cm.retop)
				Duel.RegisterEffect(e2,tp)
			end
			sg:AddCard(tc)
			tc:CreateRelation(c,RESET_EVENT+0x1fc0000)
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.mtfilter(c,rc)
	return c:IsRelateToCard(rc) and c:IsCanOverlay() and c:GetFlagEffect(m)==0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if c:GetFlagEffect(m)==0 then return end
	local g=e:GetLabelObject():GetLabelObject():Filter(cm.mtfilter,nil,c)
	if #g>0 then Duel.Overlay(c,g) end
end
function cm.atkcon1(e)
	return e:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
function cm.ctcon1(e)
	return e:GetHandler():IsAttribute(ATTRIBUTE_EARTH)
end
function cm.ctval1(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_MONSTER)
end
function cm.atkcon2(e)
	return e:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
function cm.ctcon2(e)
	return e:GetHandler():IsAttribute(ATTRIBUTE_FIRE)
end
function cm.ctval2(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_TRAP)
end
function cm.ctcon3(e)
	return e:GetHandler():IsAttribute(ATTRIBUTE_WIND)
end
function cm.ctval3(e,re,rp)
	return aux.tgoval(e,re,rp) and re:IsActiveType(TYPE_SPELL)
end
