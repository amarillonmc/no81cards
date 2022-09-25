--银 河 眼 恐 暴 龙
local m=22348004
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22348004)
	e1:SetCondition(c22348004.spcon)
	e1:SetCost(c22348004.spcost)
	e1:SetTarget(c22348004.sptg)
	e1:SetOperation(c22348004.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348004,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,22348005)
	e3:SetTarget(c22348004.sp2tg)
	e3:SetOperation(c22348004.sp2op)
	c:RegisterEffect(e3)

	--XyzSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348004,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1,22348006)
	e4:SetTarget(c22348004.xyztg)
	e4:SetOperation(c22348004.xyzop)
	c:RegisterEffect(e4)
end


function c22348004.spfilter(c,sp)
	return c:IsSummonPlayer(sp)
end
function c22348004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348004.spfilter,1,nil,1-tp)
end
function c22348004.cfilter(c)
	return c:IsSetCard(0x55,0x7b) and c:IsDiscardable()
end
function c22348004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard( c22348004.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
  Duel.DiscardHand(tp, c22348004.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end


--function c22348004.cfilter(c)
--   return c:IsSetCard(0x55,0x7b) and not c:IsPublic()
--end
--function c22348004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
--	if chk==0 then return Duel.IsExistingMatchingCard(c22348004.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
--	local g=Duel.SelectMatchingCard(tp,c22348004.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
--	Duel.ConfirmCards(1-tp,g)
--	Duel.ShuffleHand(tp)
--end


function c22348004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end



function c22348004.spfilter2(c,e,tp)
	return c:IsCode(93717133) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348004.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348004.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22348004.sp2op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348004.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end



function c22348004.xyzfilter(c)
	return c:IsSetCard(0x7b) and c:IsXyzSummonable(nil)
end
function c22348004.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348004.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22348004.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348004.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end

