--神花姬-羽乃
function c72411210.initial_effect(c)
			--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72411210,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCountLimit(1,72411210)
	e1:SetCost(c72411210.spcost)
	e1:SetTarget(c72411210.sptg)
	e1:SetOperation(c72411210.spop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c72411210.discon0)
	e2:SetOperation(c72411210.disop)
	c:RegisterEffect(e2)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c72411210.discon1)
	e4:SetOperation(c72411210.disop)
	c:RegisterEffect(e4)
end
function c72411210.cfilter(c,ft)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0xe728) and (ft>0 or c:GetSequence()<5)
end
function c72411210.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c72411210.cfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c72411210.cfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c72411210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c72411210.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
end
function c72411210.discon0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	return rp==1-tp and (re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL)) and loc==LOCATION_SZONE
		and seq==4-aux.MZoneSequence(c:GetSequence())
end
function c72411210.discon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	seq=aux.MZoneSequence(seq)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and seq==4-aux.MZoneSequence(c:GetSequence())
end
function c72411210.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,72411210)
	Duel.NegateEffect(ev)
end
