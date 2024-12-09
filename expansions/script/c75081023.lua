--罪秽叠光
function c75081023.initial_effect(c)
	--revive
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetCountLimit(1,75081023)
	e0:SetTarget(c75081023.ovtg)
	e0:SetOperation(c75081023.ovop)
	c:RegisterEffect(e0)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75081023,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c75081023.handcon)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75081023,3))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,75081024)
	e3:SetTarget(c75081023.mattg)
	e3:SetOperation(c75081023.matop)
	c:RegisterEffect(e3)	
end
function c75081023.cfilter2(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x75c) and c:IsType(TYPE_MONSTER)
end
function c75081023.retcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(75081023)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c75081023.ovfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and c:IsSetCard(0x75c) and c:GetOverlayCount()==0
end
function c75081023.ovfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c75081023.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c75081023.ovfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75081023.ovfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c75081023.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c75081023.ovop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c75081023.ovfilter2,tp,0,LOCATION_MZONE,nil)
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:Select(tp,1,1,nil)
		Duel.Overlay(tc,sg)
	end
	if e:GetLabel()==100 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c75081023.aclimit)
		Duel.RegisterEffect(e1,tp)
	end
end

function c75081023.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(75081023)~=0
end
function c75081023.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_ONFIELD)~=0
end
function c75081023.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end
--
function c75081023.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x75c) and c:IsType(TYPE_XYZ)
end
function c75081023.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c75081023.matfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75081023.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c75081023.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c75081023.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
