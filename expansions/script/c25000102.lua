local m=25000102
local cm=_G["c"..m]
cm.name="内部"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.xtg)
	e2:SetOperation(cm.xop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetTarget(cm.ytg)
	e3:SetOperation(cm.yop)
	c:RegisterEffect(e3)
end
function cm.xfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function cm.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.xfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.xfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.xop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLevelAbove(1) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_MOVE)
		e1:SetLabel(tc:GetOriginalType())
		e1:SetLabelObject(tc)
		e1:SetOperation(cm.rstop)
		Duel.RegisterEffect(e1,tp)
		local e3=e1:Clone()
		e3:SetCode(EVENT_ADJUST)
		Duel.RegisterEffect(e3,tp)
		local typ,lv=tc:GetType(),tc:GetLevel()
		local ctyp=typ&(TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_MONSTER+TYPE_NORMAL)
		tc:SetCardData(4,typ-ctyp+TYPE_MONSTER+TYPE_XYZ)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RANK)
		e2:SetValue(lv)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local tc,typ=e:GetLabelObject(),e:GetLabel()
	if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then return end
	tc:SetCardData(4,typ)
	local g=tc:GetOverlayGroup()
	if #g>0 then Duel.SendtoGrave(g,REASON_RULE) end
	e:Reset()
end
function cm.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function cm.filter2(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function cm.ytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
end
function cm.yop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,e)
	if g:GetCount()>0 then
		local og=g:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,g)
	end
end
