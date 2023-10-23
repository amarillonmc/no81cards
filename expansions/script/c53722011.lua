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
	if not GC_Adjust then
		GC_Adjust=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SUMMON_COST)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge1:SetCode(EFFECT_SPSUMMON_COST)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SUMMON_SUCCESS)
		ge3:SetOperation(cm.reset)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge4,0)
		local ge5=ge3:Clone()
		ge5:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge3:Clone()
		ge6:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(ge6,0)
		local ge7=ge3:Clone()
		ge7:SetCode(EVENT_CHAIN_SOLVING)
		ge7:SetOperation(cm.check)
		Duel.RegisterEffect(ge7,0)
		local ge8=ge3:Clone()
		ge8:SetCode(EVENT_CHAIN_SOLVED)
		Duel.RegisterEffect(ge8,0)
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	GC_Check=true
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	GC_Check=false
end
function cm.filter(c)
	return c:IsCode(m) and c:IsFaceup()
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
	--[[else
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_ADJUST)
		e5:SetRange(LOCATION_REMOVED)
		e5:SetCondition(cm.spcon)
		e5:SetOperation(cm.spop)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e5,true)--]]
	end
end
function cm.unicity_check(tp)
	return not Duel.IsExistingMatchingCard(aux.NOT(Card.IsSetCard),tp,LOCATION_GRAVE,0,1,nil,0x3531)
end
function cm.cfilter1(c,tp)
	return c:IsSetCard(0x3531) and c:IsPreviousLocation(LOCATION_HAND) and c:IsPreviousControler(tp) and c:GetAttribute()~=0
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter1,1,nil,tp) and cm.unicity_check(tp)
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
	return eg:IsExists(cm.cfilter2,1,nil,tp) and cm.unicity_check(tp)
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
	return eg:IsExists(cm.cfilter3,1,nil,tp) and cm.unicity_check(tp)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,200,REASON_EFFECT)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not GC_Check
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP) end
	end
	e:Reset()
end
