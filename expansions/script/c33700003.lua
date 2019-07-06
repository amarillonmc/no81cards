--Protoform召唤阵
function c33700003.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c33700003.condition)
	e1:SetTarget(c33700003.target)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c33700003.spcon)
	e2:SetTarget(c33700003.sptg)
	e2:SetOperation(c33700003.spop)
	c:RegisterEffect(e2)
	 Duel.AddCustomActivityCounter(33700003,ACTIVITY_SPSUMMON,c33700003.counterfilter)
end
function c33700003.counterfilter(c)
	return c:IsSetCard(0x6440) or c:IsSetCard(0x3440) or c:IsSetCard(0x5440)
end
function c33700003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(33700003,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c33700003.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c33700003.splimit(e,c)
	return not (c:IsSetCard(0x6440) or c:IsSetCard(0x3440) or c:IsSetCard(0x5440))
end
function c33700003.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x3440) or c:IsSetCard(0x6440) end,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil)
end
function c33700003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c33700003.spcon(e,tp,eg,ep,ev,re,r,rp) and  c33700003.spcost(e,tp,eg,ep,ev,re,r,rp,0) and c33700003.sptg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(33700003,0))  then
   e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:SetOperation(c33700003.spop)
	 c33700003.spcost(e,tp,eg,ep,ev,re,r,rp,1) 
	 c33700003.sptg(e,tp,eg,ep,ev,re,r,rp,1)	   
	else
		e:SetCategory(0)
		 e:SetOperation(nil)
	end
end
function c33700003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.GetFieldCard(tp,LOCATION_PZONE,1)
end
function c33700003.spfilter(c,lsc,rsc,e,tp)
	 local lv=c:GetLevel()
	return lv>lsc and lv<rsc and c:IsSetCard(0x6440) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c33700003.spfilter,tp,LOCATION_GRAVE,0,1,nil,lsc,rsc,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end
function c33700003.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lsc=Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local cg=Duel.GetMatchingGroupCount(c33700003.spfilter,tp,LOCATION_GRAVE,0,nil,lsc,rsc,e,tp)
	local g=Duel.SelectMatchingCard(tp,c33700003.spfilter,tp,LOCATION_GRAVE,0,1,cg,nil,lsc,rsc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end