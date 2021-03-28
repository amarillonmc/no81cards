--方舟之骑士·藻
function c29065622.initial_effect(c)
	c:EnableCounterPermit(0x11ae)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c29065622.lvtg)
	e1:SetValue(c29065622.lvval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c29065622.imcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c29065622.discon)
	e3:SetOperation(c29065622.disop)
	c:RegisterEffect(e3)
	--change attribute
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(c29065622.attcon)
	e4:SetCost(c29065622.attcost)
	e4:SetTarget(c29065622.atttg)
	e4:SetOperation(c29065622.attop)
	c:RegisterEffect(e4)
end
function c29065622.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetCounter(0x11ae)>0 and c:IsSetCard(0x87af)
end
function c29065622.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 8
	else return lv end
end
function c29065622.imcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c29065622.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local og=c:GetOverlayGroup()
	if not og or og:GetCount()==0
		or og:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)~=og:GetCount() then return false end
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
function c29065622.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c29065622.attcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	return og and og:GetCount()~=0 and og:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)==og:GetCount()
end
function c29065622.attcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065622.attfilter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_WATER)
end
function c29065622.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c29065622.attfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29065622.attfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c29065622.attfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c29065622.attop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_WATER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(-1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
