--方舟骑士-迷迭香·新生
local m=29048740
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(aux.FilterBoolFunction(Card.IsCode,29065546)),nil,nil,cm.syf,1,1)
	c:EnableReviveLimit()
	--Effect 1
	local e01=Effect.CreateEffect(c)
	e01:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e01:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e01:SetProperty(EFFECT_FLAG_DELAY)
	e01:SetCode(EVENT_SPSUMMON_SUCCESS)
	e01:SetCountLimit(1,m)
	e01:SetTarget(cm.sptg)
	e01:SetOperation(cm.spop)
	c:RegisterEffect(e01)
	--Effect 2  
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_MZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m+m)
	e51:SetCondition(cm.sumcon)
	e51:SetCost(cm.spmcost)
	e51:SetTarget(cm.spmtg)
	e51:SetOperation(cm.spmop)
	c:RegisterEffect(e51) 
end
--synchro summon rule filter
function cm.syf(c,syc)
	local setcard=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	return c:GetSynchroLevel(syc)>0 and setcard and c:IsSynchroType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial(syc)
end
--Effect 1
function cm.sp(c,e,tp)
	local setcard=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	return c:IsType(TYPE_TUNER) and setcard and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=(Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE))+1
	local g=Duel.GetMatchingGroup(cm.sp,tp,LOCATION_DECK,0,nil,e,tp)
	if chk==0 then return ft>0 and ct>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=(Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE))+1
	local g=Duel.GetMatchingGroup(cm.sp,tp,LOCATION_DECK,0,nil,e,tp)
	if ft==0 or #g==0 then return end
	if ft>ct then ft=ct end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if #sg==0 then return false end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
--Effect 2
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.spmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0 end
	Duel.Release(c,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(29065546) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function cm.spmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))  
		end
	end
end 
