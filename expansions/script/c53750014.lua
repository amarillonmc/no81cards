if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53750014
local cm=_G["c"..m]
cm.name="异律次元秽魔导 瑞西塔"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,8,2,nil,nil,99)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(cm.efilter)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e1:SetTarget(cm.etg)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(cm.eqcon)
	e2:SetCost(cm.eqcost)
	e2:SetTarget(cm.eqtg)
	e2:SetOperation(cm.eqop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.eqcheck)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(4)
	e4:SetOperation(cm.regop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	e5:SetLabel(5)
	c:RegisterEffect(e5)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e4:SetLabelObject(sg)
	e5:SetLabelObject(e4)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=Card.GetType
		Card.GetType=function(tc)
			if tc:GetFlagEffect(m)>0 then
				return TYPE_SPELL
			else
				return cm[0](tc)
			end
		end
	end
end
function cm.etg(e,c)
	return e:GetHandler():GetEquipGroup():IsContains(c)
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.filter(c)
	return c:GetType()==TYPE_SPELL and not c:IsForbidden() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and cm.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	else e:SetCategory(CATEGORY_EQUIP) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Equip(tp,tc,c) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(c)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsContains(c) then return end
	local g=Group.__band(c:GetEquipGroup(),eg):Filter(function(c)return c:GetFlagEffect(m)>0 and c:IsReason(REASON_COST)end,nil)
	if #g==0 then return end
	g:ForEach(Card.RegisterFlagEffect,m+50,RESET_EVENT+0x1620000+RESET_PHASE+PHASE_END,0,1)
end
function cm.regfilter(c)
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetFlagEffect(m+50)~=0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(cm.regfilter,nil)
	eg:ForEach(Card.ResetFlagEffect,m+50)
	if #g==0 then return end
	local sg=Group.FromCards()
	if e:GetLabel()==4 then sg=e:GetLabelObject() else sg=e:GetLabelObject():GetLabelObject() end
	if c:GetFlagEffect(m)==0 then
		sg:Clear()
		c:RegisterFlagEffect(m,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		if e:GetLabel()==4 then e6:SetLabelObject(e) else e6:SetLabelObject(e:GetLabelObject()) end
		e6:SetCountLimit(1)
		e6:SetOperation(cm.mtop)
		e6:SetReset(EVENT_PHASE+PHASE_END)
		Duel.RegisterEffect(e6,tp)
	end
	sg:Merge(g)
	g:ForEach(Card.CreateRelation,c,RESET_EVENT+RESETS_STANDARD)
end
function cm.mtfilter(c,rc)
	return c:IsRelateToCard(rc) and c:IsCanOverlay()
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if c:GetFlagEffect(m)==0 then return end
	local g=e:GetLabelObject():GetLabelObject():Filter(cm.mtfilter,nil,c)
	if #g>0 then Duel.Overlay(c,g) end
end
