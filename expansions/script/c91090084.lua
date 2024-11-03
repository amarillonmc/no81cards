--同调世界2
local cm,m=GetID()
function c91090084.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_DECK)
	e0:SetRange(LOCATION_FZONE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e0:SetCondition(cm.reptg2)
	e0:SetOperation(cm.repop2)
	c:RegisterEffect(e0) 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(cm.descon)
	e4:SetOperation(cm.desop)
	c:RegisterEffect(e4)	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCountLimit(1)
	e5:SetCost(cm.countercost)
	e5:SetTarget(cm.lvtg)
	e5:SetOperation(cm.lvop)
	c:RegisterEffect(e5)
end
function cm.fitn(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(8)
end
function cm.efilter(e,te)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.fitn,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and  te:GetOwner()~=e:GetOwner()
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function cm.fit(c,e,tp)
	return  c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
end
function cm.repfilter2(c,tp,re,e)
	return  c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(12) and c:IsAbleToRemove() and re:GetOwner()==c and Duel.IsExistingMatchingCard(cm.fit,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function cm.reptg2(e,tp,eg,ep,ev,re,r,rp)
 return bit.band(r,REASON_EFFECT)~=0 and re
		and  eg:IsExists(cm.repfilter2,1,nil,tp,re,e) 
end
function cm.repfilter3(g,tp,re,e)
	return  g:IsExists(cm.repfilter2,1,nil,tp,re,e) 
end
function cm.repop2(e,tp,eg,ep,ev,re,r,rp)
	if	 Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0))  then 
	local g=eg:SelectSubGroup(tp,cm.repfilter3,false,1,1,tp,re,e)
	if #g<1 then return end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then 
	local sg=Duel.SelectMatchingCard(tp,cm.fit,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
	end
end
function cm.repval2(e,c)
	return  c:IsLocation(LOCATION_ONFIELD)  and c:IsType(TYPE_SYNCHRO) and c:IsLevel(12)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x104d,2)
	end
end
function cm.countercost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x104d,3,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x104d,3,REASON_COST)
end
function cm.lvfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsAttackAbove(2500) 
end
function cm.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) or Duel.IsExistingMatchingCard(cm.fit2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
end
function cm.fit2(c,e,tp)
	return  c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON) 
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g>0 then
	Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local sg=Duel.SelectMatchingCard(tp,cm.fit2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
end