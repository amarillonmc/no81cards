--SNo.102 圣光天使 辉星
function c49678550.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c49678550.XyzCondition)
	e1:SetTarget(c49678550.XyzTarget)
	e1:SetOperation(c49678550.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	c:EnableReviveLimit()
	Duel.AddCustomActivityCounter(49678550,ACTIVITY_SPSUMMON,c49678550.counterfilter)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49678550,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,49678550)
	e2:SetTarget(c49678550.sptg)
	e2:SetOperation(c49678550.spop)
	c:RegisterEffect(e2)
end
c49678550.xyz_number=102

function c49678550.counterfilter(c)
	return c:IsSetCard(0x86) or not c:IsSummonLocation(LOCATION_HAND) or not c:IsSummonLocation(LOCATION_GRAVE)
end
function c49678550.Xyzfilter(c,e,sc)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup() and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c49678550.EXyzfilter(c,e,sc)
	return c:IsSetCard(0x86) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:IsCanBeXyzMaterial(sc) and c:IsXyzLevel(sc,4)
end
function c49678550.XyzCondition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetCustomActivityCount(49678550,tp,ACTIVITY_SPSUMMON)~=0 then return false end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_SPSUMMON_COUNT_LIMIT) then return false end
	local mg=Duel.GetMatchingGroup(c49678550.Xyzfilter,tp,LOCATION_MZONE,0,nil,e,c)
	local og=Duel.GetMatchingGroup(c49678550.EXyzfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,c)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and ct>1 then ct=1 end
	if mg:GetCount()<3 and (ct<(3-mg:GetCount()) or og:GetCount()<(3-mg:GetCount())) then return false end
	og:Merge(mg)
	return Duel.CheckXyzMaterial(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),4,3,3,og)
end
function c49678550.XyzLevelFreeGoal(g,tp,xyzc,ct)
	return Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0 and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE | LOCATION_HAND)<=c49678550.ct
end
function c49678550.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=Duel.GetMatchingGroup(c49678550.Xyzfilter,tp,LOCATION_MZONE,0,nil,e,c)
	local og=Duel.GetMatchingGroup(c49678550.EXyzfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,c)
	mg:Merge(og)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and ct>1 then ct=1 end
	c49678550.ct=ct
	local g=mg:SelectSubGroup(tp,c49678550.XyzLevelFreeGoal,true,3,3,tp,c,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		c49678550.ct=0
	return true
	else return false end
end
function c49678550.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	local sg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=mg:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	local num=mg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE | LOCATION_HAND)
	if num>0 then
		local ct=Duel.SpecialSummon(mg:Filter(Card.IsLocation,nil,LOCATION_GRAVE | LOCATION_HAND),0,tp,tp,false,false,POS_FACEUP_ATTACK)
		local og=Duel.GetOperatedGroup()
		if og:FilterCount(Card.IsPreviousLocation,nil,LOCATION_HAND)>0 then Duel.ShuffleHand(tp) end
	end
	Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	if ct and ct<num then return false end
	if mg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<3 then return end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c49678550.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c49678550.splimit(e,c)
	return not c:IsSetCard(0x86) and (c:IsSummonLocation(LOCATION_HAND) or c:IsSummonLocation(LOCATION_GRAVE))
end

function c49678550.spfilter(c,e,tp)
	return c:IsSetCard(0x86) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c49678550.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup():Filter(c49678550.spfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and og:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function c49678550.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local og=e:GetHandler():GetOverlayGroup():Filter(c49678550.spfilter,nil,e,tp)
	local g=og:Select(tp,1,ct,nil)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)>0 and Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) and Duel.SelectYesNo(tp,aux.Stringid(49678550,1)) then
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
