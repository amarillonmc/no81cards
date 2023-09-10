local m=53722011
local cm=_G["c"..m]
cm.name="转极的大祭环"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:GetOriginalCodeRule()==m and c:IsFaceup()
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3531) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	if not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,c) then
		Duel.Hint(HINT_CARD,0,m)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetLabel(0)
		e1:SetCondition(cm.drcon)
		e1:SetOperation(cm.drop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetRange(LOCATION_REMOVED)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.clear)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_TO_GRAVE)
		e3:SetRange(LOCATION_REMOVED)
		e3:SetCondition(cm.atkcon)
		e3:SetOperation(cm.atkop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_TO_DECK)
		e4:SetRange(LOCATION_REMOVED)
		e4:SetCondition(cm.reccon)
		e4:SetOperation(cm.recop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e4)
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP) end
	end
end
function cm.cfilter1(c,tp)
	return c:IsSetCard(0x3531) and c:IsPreviousLocation(LOCATION_HAND) and c:IsPreviousControler(tp) and c:GetAttribute()~=0
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter1,1,nil,tp)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) then return end
	e:SetLabel(ct+1)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function cm.cfilter2(c,tp)
	return c:IsSetCard(0x3531) and c:IsControler(tp)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter2,1,nil,tp)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2,true)
end
function cm.cfilter3(c,tp)
	return c:IsSetCard(0x3531) and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp)
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter3,1,nil,tp)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,200,REASON_EFFECT)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
