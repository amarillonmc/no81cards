local m=31410009
local cm=_G["c"..m]
cm.name="风间检察官"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(cm.handtg)
	e1:SetOperation(cm.handop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.chkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.counterop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(cm.econ)
	e4:SetValue(cm.elimit)
	e4:SetLabel(0)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetTargetRange(0,1)
	e6:SetLabel(1)
	c:RegisterEffect(e6)
end
function cm.handfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_WIND)
end
function cm.handtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingMatchingCard(cm.handfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.handop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local tg=Duel.SelectMatchingCard(tp,cm.handfilter,tp,LOCATION_DECK,0,1,1,nil)
	if not (tg:GetCount()>0) then return end
	Duel.SendtoExtraP(tg,tp,REASON_EFFECT)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.IsPlayerCanDraw(1) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) then return end
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not tc1 or not tc2 then return false end
	if not tc1:IsAttribute(ATTRIBUTE_WIND) or not tc1:IsAttribute(ATTRIBUTE_WIND) then return end
	e:GetHandler():RegisterFlagEffect(31410000,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,nil,aux.Stringid(31410000,2))
end
function cm.counterop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	if ep==tp then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	else
		e:GetHandler():RegisterFlagEffect(m+1,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.cfilter(c,type)
	return c:IsFaceup() and c:IsType(type)
end
function cm.econ(e)
	if e:GetHandler():GetFlagEffect(31410000)==0 then return false end
	local ct=0
	for i,type in ipairs({TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK}) do
		if Duel.IsExistingMatchingCard(cm.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,type) then
			ct=ct+1
		end
	end
	return e:GetHandler():GetFlagEffect(m+e:GetLabel())>=ct
end
function cm.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end