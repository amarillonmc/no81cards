--荒碑灵 死夜
local m=14000386
local cm=_G["c"..m]
cm.named_with_Gravalond=1
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,14000380,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),1,true,false)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetValue(14000380)
	c:RegisterEffect(e1)
	--fusion effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.Grava(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Gravalond
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,m) then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(m)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.e1con)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.e2con)
	e2:SetOperation(cm.e2op)
	Duel.RegisterEffect(e2,tp)
	--[[local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetTargetRange(LOCATION_GRAVE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTarget(cm.e3tg)
	e3:SetCondition(cm.e3con)
	e3:SetLabelObject(e4)
	Duel.RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetValue(14000380)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_GRAVE,0)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTarget(cm.e3tg)
	e3:SetCondition(cm.e3con)
	e3:SetValue(14000380)
	Duel.RegisterEffect(e3,tp)]]
end
function cm.filter(c)
	return c:IsCode(14000380)
end
function cm.e1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.e2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,3,nil)
end
function cm.e2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local ct=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_GRAVE,0,nil)
	if ct==0 then return end
	Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end
--[[function cm.e3con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,5,nil)
end
function cm.e3tg(e,c)
	return cm.Grava(c)
end
function cm.e3con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,5,nil)
end
function cm.e3tg(e,c)
	local code1,code2=c:GetOriginalCodeRule()
	return (code1 and code1>=14000381 and code1<=14000399) or (code2 and code2>=14000381 and code2<=14000399)
end]]