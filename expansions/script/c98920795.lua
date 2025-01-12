--黑羽驯鸟师-玄翼之隼匠·布莱克
function c98920795.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x33),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920795,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98920795)
	e3:SetCost(c98920795.spcost)
	e3:SetTarget(c98920795.sptg)
	e3:SetOperation(c98920795.spop)
	c:RegisterEffect(e3)	
	Duel.AddCustomActivityCounter(98920795,ACTIVITY_SPSUMMON,c98920795.counterfilter)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920795,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,98920795)
	e1:SetCondition(c98920795.spcon2)
	e1:SetTarget(c98920795.sptg2)
	e1:SetOperation(c98920795.spop2)
	c:RegisterEffect(e1)
end
function c98920795.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_SYNCHRO)
end
function c98920795.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c98920795.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGraveAsCost()
end
function c98920795.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(98920795,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c98920795.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920795.filter(c,e,tp)
	return c:IsSetCard(0x33) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920795.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local t=math.floor(Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)/2)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=t
		and Duel.IsExistingMatchingCard(c98920795.filter,tp,LOCATION_DECK,0,t,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,t,tp,LOCATION_DECK)
end
function c98920795.spop(e,tp,eg,ep,ev,re,r,rp)
	local t=math.floor(Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)/2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and t>=2 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<t then return end
	local g=Duel.GetMatchingGroup(c98920795.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>=t then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,t,t,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920795.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c98920795.RitualUltimateFilter(c,filter,e,tp,m1,greater_or_equal,chk)
	if not c:IsType(TYPE_SYNCHRO) or not c:IsCode(73218989,9012916,60992105) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsAbleToRemove,c,c)
	local lv=c:GetLevel()
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function c98920795.RitualExtraFilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c98920795.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			local mg=Duel.GetMatchingGroup(c98920795.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil)
			return Duel.IsExistingMatchingCard(c98920795.RitualUltimateFilter,tp,LOCATION_EXTRA,0,1,nil,filter,e,tp,mg,'Equal')
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function c98920795.cfilter2(c)
	return c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
end
function c98920795.spop2(e,tp,eg,ep,ev,re,r,rp)
		::RitualUltimateSelectStart::
		local mg=Duel.GetMatchingGroup(c98920795.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(c98920795.RitualUltimateFilter),tp,LOCATION_EXTRA,0,1,1,nil,filter,e,tp,mg,'Equal')
		local tc=tg:GetFirst()
		local mat
		if tc then
			mg=mg:Filter(Card.IsAbleToRemove,tc,tc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local lv=tc:GetLevel()
			Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,'Equal')
			mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,true,1,lv,tp,tc,lv,'Equal')
			Auxiliary.GCheckAdditional=nil
			if not mat then goto RitualUltimateSelectStart end
			Duel.Remove(mat,POS_FACEUP,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
end