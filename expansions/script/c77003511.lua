--灵械姬的抓捕
local m=77003511
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Effect 2  
	local e02=Effect.CreateEffect(c)  
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetCategory(CATEGORY_ATKCHANGE)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_MZONE)
	e02:SetCountLimit(1)
	e02:SetCost(cm.akcost)
	e02:SetTarget(cm.aktg)
	e02:SetOperation(cm.akop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e02)
	c:RegisterEffect(e3)
end
--Effect 1
function cm.f(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x3eec)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsCanOverlay() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local chk1=Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_MZONE,0,1,nil)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and chk1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tg=Duel.SelectMatchingCard(tp,cm.f,tp,LOCATION_MZONE,0,1,1,nil)
		if #tg==0 then return false end
		Duel.HintSelection(tg)
		Duel.Overlay(tg:GetFirst(),tc)
	end
end
--Effect 2
function cm.eftg(e,c)
	local g=e:GetHandler():GetColumnGroup()
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x3eec) and g:IsContains(c)
end
--Buff Effect
function cm.akcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.mf(c)
	return c:IsFaceup() and (c:GetLevel()>0 or c:GetRank()>0) and c:IsRace(RACE_MACHINE)
end
function cm.aktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.mf,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
end
function cm.akop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.mf,tp,LOCATION_MZONE,0,nil)
	if c:IsFaceup() and c:IsRelateToEffect(e) and #g>0 then
		local val=g:GetSum(Card.GetLevel)
		local rval=g:GetSum(Card.GetRank)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue((val+rval)*100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
