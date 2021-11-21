local m=31400122
local cm=_G["c"..m]
cm.name="火鸟之舍身"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(aux.IsDualState)
	e1:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetValue(cm.immefilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_PZONE)
	e4:SetOperation(cm.stop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTarget(cm.sumtg)
	e5:SetOperation(cm.sumop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(aux.IsDualState)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(aux.IsDualState)
	e7:SetTarget(cm.damtg)
	e7:SetOperation(cm.damop)
	c:RegisterEffect(e7)
end
function cm.immefilter(e,te)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-400)
end
function cm.sumtgfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemove() and (not c:IsLocation(LOCATION_EXTRA) or c:IsFaceup()) and c:IsLevelBelow(7)
end
function cm.sumopfilter(c,e)
	return cm.sumtgfilter(c) and not c:IsImmuneToEffect(e)
end
function cm.sumgroupfilter(g)
	return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>0) and g:GetSum(Card.GetLevel)==7
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.sumtgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
		return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) and g:CheckSubGroup(cm.sumgroupfilter,1,g:GetCount())
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.sumopfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=g:SelectSubGroup(tp,cm.sumgroupfilter,false,1,g:GetCount())
	if tg and Duel.Remove(tg,POS_FACEUP,REASON_EFFECT+REASON_RITUAL)~=0 and Duel.SpecialSummonStep(c,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP) then
		c:EnableDualState()
		c:CompleteProcedure()
		Duel.SpecialSummonComplete()
	end
end
function cm.damtgfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsReleasableByEffect() and c:IsLevelBelow(7)
end
function cm.damopfilter(c,e)
	return cm.damtgfilter(c) and not c:IsImmuneToEffect(e)
end
function cm.damgroupfilter(g)
	return g:GetSum(Card.GetLevel)==7
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(cm.damtgfilter,tp,LOCATION_HAND,0,nil):CheckSubGroup(cm.damgroupfilter,1,99) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.damopfilter,tp,LOCATION_HAND,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=g:SelectSubGroup(tp,cm.damgroupfilter,false,1,g:GetCount())
	if not tg then return end
	Duel.Release(tg,REASON_EFFECT)
	if Duel.Damage(1-tp,tg:GetCount()*800,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		Duel.BreakEffect()
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end