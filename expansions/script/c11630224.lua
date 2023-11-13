--聚型镜·天下大同
local cm,m=GetID()
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(cm.target)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
cm.SetCard_xxj_Mirror=true
function cm.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetFirst():GetRace(),g:GetFirst():GetAttribute())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local race,attr=e:GetLabel()
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(race)
	e2:SetTarget(function(e,c) return not c:IsCode(10000040) end)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--attr
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(attr)
	e1:SetTarget(function(e,c) return not c:IsCode(10000040) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.cfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local race,attr=tc:GetRace(),tc:GetAttribute()
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(race)
	e2:SetTarget(function(e,c) return not c:IsCode(10000040) end)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--attr
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(attr)
	e1:SetTarget(function(e,c) return not c:IsCode(10000040) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end