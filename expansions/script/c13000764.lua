--大饥荒
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:SetSPSummonOnce(13000764)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.sprop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
end
function cm.filter(c,e,tp)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end 
function cm.filter2(c,e,tp)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xe09) or c:IsAttribute(ATTRIBUTE_EARTH))
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local aa=Duel.GetMatchingGroupCount(nil,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,nil)
	local bb=Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_REMOVED+LOCATION_GRAVE,nil)
	return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_REMOVED+LOCATION_GRAVE,1,nil) and bb>=aa+10 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local aa,bb
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local ta=Duel.SelectMatchingCard(tp,cm.filter,tp,0,LOCATION_REMOVED+LOCATION_GRAVE,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tb=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if ta:IsType(TYPE_LINK) then
	aa=ta:GetLink()
	end
	if ta:IsType(TYPE_XYZ) then
	aa=ta:GetRank()
	end
	if not ta:IsType(TYPE_LINK) and not ta:IsType(TYPE_XYZ) then
	aa=ta:GetLevel()
end
	if tb:IsType(TYPE_LINK) then
	aa=tb:GetLink()
	end
	if tb:IsType(TYPE_XYZ) then
	bb=tb:GetRank()
	end
	if not tb:IsType(TYPE_LINK) and not tb:IsType(TYPE_XYZ) then
	bb=tb:GetLevel()
end
	Duel.SendtoDeck(ta,nil,2,REASON_COST)
	Duel.SendtoDeck(tb,nil,2,REASON_COST)
	local cc=math.abs(aa-bb)
	Duel.RegisterFlagEffect(tp,13000764,0,0,1,cc)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pt=c:GetOwner()
	local level=Duel.GetFlagEffectLabel(tp,13000764)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,1-pt)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,1-pt)
	Duel.ResetFlagEffect(tp,13000764)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetValue(level)
	c:RegisterEffect(e3)
	local e9=Effect.CreateEffect(e:GetHandler())
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_PHASE+PHASE_END)
	e9:SetCountLimit(1)
	e9:SetOperation(cm.tgop)
	e9:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e9,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetValue(cm.atkval)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
   
end
function cm.atkval(e)
	return Duel.GetMatchingGroupCount(nil,e:GetHandlerPlayer(),LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,nil)*200
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_HAND,0)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end






