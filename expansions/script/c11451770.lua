--加速连接防火龙
local m=11451770
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--link effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.sccon)
	e2:SetCost(cm.sccost)
	e2:SetTarget(cm.sctg)
	e2:SetOperation(cm.scop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.spfilter(c,e,tp)
	return c:IsLink(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.spcheck(c,tp,rc,mg,opchk)
	return Duel.GetLocationCountFromEx(tp,tp,rc,c)>0 and (opchk or Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,c,mg))
end
function cm.scfilter(c,e,tp,rc,chkrel,chknotrel,tgchk,opchk)
	if not (c:IsCode(5043010) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)) then return false end
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	mg:AddCard(c)
	if tgchk then
		return cm.spcheck(c,tp,nil,mg,opchk)
	else
		return chkrel and cm.spcheck(c,tp,rc,mg-rc)
	end
end
function cm.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local c=e:GetHandler()
	local ect1=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	local ect2=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028) and aux.ExtraDeckSummonCountLimit[tp]
	local chkrel=c:IsReleasable()
	local b1=chkrel and Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,chkrel,nil)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2) and (not ect1 or ect1>1) and (not ect2 or ect2>1) and b1 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) end
	Duel.Release(c,REASON_COST)
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==100 then
			e:SetLabel(0)
			return true
		end
		local c=e:GetHandler()
		local ect1=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
		local ect2=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028) and aux.ExtraDeckSummonCountLimit[tp]
		return Duel.IsPlayerCanSpecialSummonCount(tp,2) and (not ect1 or ect1>1) and (not ect2 or ect2>1) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL) and Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,nil,nil,true)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,nil,nil,true,true)
	local tc=g:GetFirst()
	local res=false
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummonStep(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(2500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1,true)
			tc:CompleteProcedure()
			res=true
		end
	end
	Duel.SpecialSummonComplete()
	Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	local tg=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if res and #tg>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:Select(tp,1,1,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		sg:GetFirst():RegisterEffect(e1,true)
		Duel.LinkSummon(tp,sg:GetFirst(),nil)
	end
end