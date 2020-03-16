--琪亚娜·白骑士月光
function c9951193.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
   --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951193,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99511930)
	e1:SetTarget(c9951193.thtg)
	e1:SetOperation(c9951193.thop)
	c:RegisterEffect(e1)
  --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951193,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9951193)
	e2:SetTarget(c9951193.destg)
	e2:SetOperation(c9951193.desop)
	c:RegisterEffect(e2)
   --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951193,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c9951193.spcost)
	e2:SetTarget(c9951193.sptg)
	e2:SetOperation(c9951193.spop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951193.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951193.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951193,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951193,1))
end
function c9951193.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c9951193.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951193.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951193.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951193.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9951193.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY)
		and Duel.IsExistingMatchingCard(c9951193.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c9951193.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c9951193.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9951193.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9951193.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c9951193.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local g=Duel.GetMatchingGroup(c9951193.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	g:AddCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9951193.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRace(RACE_MACHINE) then
		local g=Duel.GetMatchingGroup(c9951193.desfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		if g:GetCount()>0 then
			g:AddCard(tc)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951193,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951193,2))
end
function c9951193.filter(c,e,tp)
	return c:IsCode(9951194,9951197) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9951193.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.CheckReleaseGroup(tp,nil,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9951193.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c9951193.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9951193.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9951193.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end