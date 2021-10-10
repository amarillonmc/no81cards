--阿蒙之瞳
local m=40009830
local cm=_G["c"..m]
cm.named_with_Amon=1
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)  
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) end)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)  
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_EXTRA_SET_COUNT)
	c:RegisterEffect(e3) 
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4) 
	--decrease tribute
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DECREASE_TRIBUTE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_SZONE+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_PZONE,0)
	e6:SetCountLimit(1,m)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
	e6:SetValue(0x1)
	c:RegisterEffect(e6) 
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SUMMON)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(cm.ctfilter,tp,LOCATION_EXTRA,0,nil)
		if ct==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToExtra,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.ctfilter,tp,LOCATION_EXTRA,0,nil)
	if ct==0 then return end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.ConfirmDecktop(tp,ct)
	local sg=g:Filter(Card.IsType,nil,TYPE_PENDULUM)
	if sg:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoExtraP(sg,tp,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end