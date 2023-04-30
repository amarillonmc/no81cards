local m=53796102
local cm=_G["c"..m]
cm.name="集刑"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e0:SetTarget(cm.target)
	e0:SetOperation(cm.operation)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetCondition(cm.cpcon)
	e2:SetValue(cm.cpval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(m)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetCondition(cm.cpcon)
	e4:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_REMOVE_TYPE)
	e5:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(cm.adjustop)
	c:RegisterEffect(e6)
	e2:SetLabelObject(e6)
	e4:SetLabelObject(e6)
	e5:SetLabelObject(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetOperation(cm.reset)
	Duel.RegisterEffect(e7,0)
	SNNM.Global_in_Initial_Reset(c,{e7})
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(m)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCondition(function(e)return e:GetHandler():GetEquipTarget()end)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,1))
	e9:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_TO_GRAVE)
	e9:SetCondition(cm.rmcon)
	e9:SetTarget(cm.rmtg)
	e9:SetOperation(cm.rmop)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_LEAVE_FIELD_P)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetRange(LOCATION_SZONE)
	e10:SetOperation(cm.regop)
	c:RegisterEffect(e10)
	e9:SetLabelObject(e10)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then Duel.Equip(tp,e:GetHandler(),tc) end
end
function cm.cpcon(e)
	return Duel.IsExistingMatchingCard(function(c)return c:IsType(TYPE_EFFECT) and c:IsFaceup()end,0,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) and e:GetLabelObject():GetLabel()~=0
end
function cm.cpval(e)
	return e:GetLabelObject():GetLabel()
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec then return end
	if ec:GetFlagEffect(m)==0 then
		ec:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(cm.resetop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1,true)
		e:SetLabelObject(e1)
	end
	if ec:IsImmuneToEffect(e) then return end
	local exg=Group.FromCards(ec)
	local g=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_EFFECT) and c:IsFaceup()end,tp,LOCATION_MZONE,LOCATION_MZONE,ec)
	if #g==0 then return end
	local tg,val=g:GetMaxGroup(Card.GetBaseAttack)
	local b=false
	local cpc=e:GetLabelObject():GetLabelObject()
	if tg:IsExists(aux.NOT(Card.IsRelateToCard),1,nil,c) or (not cpc or not cpc:IsRelateToCard(c)) then b=true end
	tg:ForEach(Card.CreateRelation,c,RESET_EVENT+RESETS_STANDARD)
	if not b then return end
	local tc=tg:GetFirst()
	if #tg>1 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		tc=tg:Select(tp,1,1,nil):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
	end
	local pcid=e:GetLabelObject():GetLabel()
	if pcid~=0 then ec:ResetEffect(pcid,RESET_COPY) end
	local cid=ec:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD)
	e:GetLabelObject():SetLabelObject(tc)
	e:GetLabelObject():SetLabel(cid)
	e:SetLabel(tc:GetOriginalCode())
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsHasEffect(m) and e:GetLabel()~=0 then c:ResetEffect(e:GetLabel(),RESET_COPY) end
	local tc=e:GetLabelObject()
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(m+50)
	e1:SetLabel(tc:GetOriginalCode())
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	if c:IsHasEffect(m) then return end
	local g=Duel.GetMatchingGroup(nil,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	g:ForEach(Card.ReleaseRelation,c,RESET_EVENT+RESETS_STANDARD)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if not ec then return end
	if not eg:IsContains(ec) then return end
	local t={}
	local le={ec:IsHasEffect(m+50)}
	for _,v in pairs(le) do table.insert(t,v:GetLabel()) end
	e:SetLabel(table.unpack(t))
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetLabelObject():GetLabel())
	return e:GetHandler():IsReason(REASON_LOST_TARGET) and not e:GetHandler():GetPreviousEquipTarget():IsLocation(LOCATION_ONFIELD+LOCATION_OVERLAY)
end
function cm.rmfilter(c,t)
	return c:IsFaceup() and c:IsCode(table.unpack(t))
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,{e:GetLabel()})
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,{e:GetLabel()})
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		if ct>0 then Duel.Damage(tp,ct*1000,REASON_EFFECT) end
	end
end
