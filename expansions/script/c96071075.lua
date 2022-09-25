--神道觉醒 夜溟彼岸花
local m=96071075
local set=0xff7
local set=0xff8
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x18)
	--cannot
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.imcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.efilter1)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(cm.reptg)
	c:RegisterEffect(e5)
	--counter
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,4))
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_CUSTOM+m)
	e6:SetTarget(cm.cttg)
	e6:SetOperation(cm.ctop)
	c:RegisterEffect(e6)
	--atk & def
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(cm.atkval)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)
	--immune
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_IMMUNE_EFFECT)
	e9:SetCondition(cm.immcon)
	e9:SetValue(cm.efilter2)
	c:RegisterEffect(e9)
end
cm.card_code_list={96071000}
cm.assault_name=96071054
	--cannot
function cm.imcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end
function cm.efilter1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
	--material
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(1-tp) and cm.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
	--destroy replace
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local c=e:GetHandler()
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,e,0,0,0,0)
		return true
	else return false end
end
	--counter
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x18,1) end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
	--atk & def
function cm.atkval(e,c)
	return c:GetCounter(0x18)*1000
end
	--immune
function cm.immcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function cm.efilter2(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end