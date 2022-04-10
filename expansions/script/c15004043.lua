local m=15004043
local cm=_G["c"..m]
cm.name="异再神建立"
function cm.initial_effect(c)
	c:EnableCounterPermit(0xf3f)
	c:SetCounterLimit(0xf3f,12)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	local e2=Effect.Clone(e1)
	e2:SetCode(EVENT_SPSUMMON_NEGATED)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RITUAL))
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,15004043)
	e4:SetCost(cm.spcost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf3f,1)
end
function cm.atkval(e,c)
	return e:GetHandler():GetCounter(0xf3f)*200
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabelObject(e)
	if chk==0 then return e:GetHandler():GetCounter(0xf3f)~=0 and e:GetHandler():IsCanRemoveCounter(tp,0xf3f,e:GetHandler():GetCounter(0xf3f),REASON_COST) end
	e:SetLabel(e:GetHandler():GetCounter(0xf3f))
	e:GetHandler():RemoveCounter(tp,0xf3f,e:GetHandler():GetCounter(0xf3f),REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5f3f) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.fselect(g,tp,ct)
	return Duel.GetMZoneCount(tp)>=g:GetCount() and g:GetSum(Card.GetLevel)==ct and aux.dncheck(g)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetMZoneCount(tp)
	if ft>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then return e:GetLabelObject()==e and g:CheckSubGroup(cm.fselect,1,ft,tp,e:GetHandler():GetCounter(0xf3f)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if (not g:CheckSubGroup(cm.fselect,1,ft,tp,ct)) or ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,ft,tp,ct)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end