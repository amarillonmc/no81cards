--深渊的呼唤VII 末世搜救
local s,id,o=GetID()
function s.initial_effect(c)
	s.sp(c)
	s.set(c)
end


function s.set(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(2)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.poscon2)
	e3:SetTarget(s.postg2)
	e3:SetOperation(s.posop2)
	c:RegisterEffect(e3)
end
function s.poscfilter(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown()
end
function s.poscon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.poscfilter,1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x882) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(s.checkfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function s.checkfilter(c,cd)
	return c:IsCode(cd)
end
function s.postg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.posop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and s.postg(e,tp,eg,ep,ev,re,r,rp,0) then
		s.posop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.posposposfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local sg=Duel.GetMatchingGroup(s.posposposfilter,tp,0,LOCATION_MZONE,nil)
		return #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(88800103,0)) end
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sc=Duel.SelectMatchingCard(tp,s.posposposfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE)
end
function s.sp(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(2)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+1)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsFacedown() 
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then return false end
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	s.spposlimt(e,tp,eg,ep,ev,re,r,rp)
end

function s.spposlimt(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return (sumpos&POS_ATTACK)>0
end