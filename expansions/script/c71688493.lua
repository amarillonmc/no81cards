--思念龙
local s,id,o=GetID()
function s.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES|CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.syncost)
	e1:SetTarget(s.syntg)
	e1:SetOperation(s.synop)
	c:RegisterEffect(e1)
end
function s.dfilter(c,g,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsLinkAttribute(ATTRIBUTE_FIRE) and c:IsDiscardable(REASON_EFFECT+REASON_DISCARD)
end
function s.fselect(g,e,tp)
	local lv=g:GetSum(Card.GetOriginalLevel)
	return g:IsContains(e:GetHandler()) and Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
end
function s.synfilter(c,e,tp,lv)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsType(TYPE_SYNCHRO)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.syncost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_HAND,0,nil)
    if chk==0 then
        return g:CheckSubGroup(s.fselect,2,2,e,tp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    Duel.SetSelectedCard(e:GetHandler())
    local sg=g:SelectSubGroup(tp,s.fselect,false,2,2,e,tp)
    if sg and sg:GetCount()==2 then
        local lv=sg:GetSum(Card.GetOriginalLevel)
        Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
        e:SetLabel(lv)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    e1:SetTargetRange(1,0)
    e1:SetTarget(s.splimit)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    Duel.RegisterEffect(e2,tp)
end
function s.splimit(e,c)
    return not c:IsRace(RACE_DRAGON)
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.dfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) and g:CheckSubGroup(s.fselect,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp)
    local lv=e:GetLabel()
		local sc=Duel.SelectMatchingCard(tp,s.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv):GetFirst()
		if not sc then return end
		sc:SetMaterial(nil)
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end