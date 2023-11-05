--海晶少女·扇贝
local m=11634001
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.sprcon)
	c:RegisterEffect(e1)
	--Effect 2
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,1))
	e51:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_GRAVE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m+m)
	e51:SetCondition(cm.lscon)
	e51:SetCost(aux.bfgcost)
	e51:SetTarget(cm.lstg)
	e51:SetOperation(cm.lsop)
	c:RegisterEffect(e51) 
end
function cm.matval(e,lc,mg,c,tp)
	if not lc:IsAttribute(ATTRIBUTE_WATER) then return false,nil end
	return true,not mg or true
end
--Effect 1
function cm.ff(c)
	return c:IsFaceup() and c:IsSetCard(0x12b)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local b1=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	local b2=#g==0
	local b3=#g>0 and g:FilterCount(cm.ff,nil)==#g
	return b1 and (b2 or b3)
end
--Effect 2
function cm.lscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end  
function cm.matfilter(c)
	if cm.hf(c) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(75)
		e1:SetValue(cm.matval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		e1:Reset()
	end
	return c:IsFaceupEx() and c:IsSetCard(0x12b)
end
function cm.hf(c)
	return  c:IsSetCard(0x12b) and c:IsLocation(LOCATION_HAND)
end
function cm.lkfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLinkSummonable(mg)
end
function cm.lstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_MZONE 
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.matfilter,tp,loc,0,nil)
		return Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.lsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_HAND+LOCATION_MZONE 
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,loc,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=tg:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,mg)
	end
end