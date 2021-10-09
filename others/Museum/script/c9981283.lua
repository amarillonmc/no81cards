--圣诞企鹅
function c9981283.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981283,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9981283)
	e1:SetCost(c9981283.spcost)
	e1:SetTarget(c9981283.sptg)
	e1:SetOperation(c9981283.spop)
	c:RegisterEffect(e1)
   --pos change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981283,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e2:SetCountLimit(1,9981283)
	e2:SetCost(c9981283.poscost)
	e2:SetTarget(c9981283.postg)
	e2:SetOperation(c9981283.posop)
	c:RegisterEffect(e2)
end
function c9981283.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9981283.filter(c,e,tp)
	return c:IsSetCard(0x5a) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981283.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c9981283.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9981283.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981283.filter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9981283.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToRemoveAsCost()
end
function c9981283.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9981283.cfilter,tp,LOCATION_GRAVE,0,1,c) and c:IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9981283.cfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9981283.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(9981283,2))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(9981283,3))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(9981283,2),aux.Stringid(9981283,3))
	end
	e:SetLabel(s)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c9981283.posop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEDOWN_DEFENSE)
		end
	end
end
