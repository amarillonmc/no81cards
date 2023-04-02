--绘色的永夏 羽未
require("expansions/script/c9910950")
function c9910972.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5954),2,2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c9910972.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910972)
	e2:SetCondition(c9910972.spcon)
	e2:SetCost(c9910972.spcost)
	e2:SetTarget(c9910972.sptg)
	e2:SetOperation(c9910972.spop)
	c:RegisterEffect(e2)
end
function c9910972.indtg(e,c)
	return (c==e:GetHandler() and c:IsLinkState())
		or (c:IsFaceup() and c:IsSetCard(0x5954) and e:GetHandler():GetLinkedGroup():IsContains(c))
end
function c9910972.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910972.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9910972.spfilter(c,e,tp)
	return c:IsSetCard(0x5954) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910972.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,4)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c9910972.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and #rg==4 and rg:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,3,0,0)
end
function c9910972.spop(e,tp,eg,ep,ev,re,r,rp)
	local res=false
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910972.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0
			if res then
				Duel.BreakEffect()
				local rg=Duel.GetDecktopGroup(tp,3)
				Duel.ConfirmCards(tp,rg)
				Duel.DisableShuffleCheck()
				Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
