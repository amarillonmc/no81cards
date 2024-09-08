--惧之数码兽 猛鬼兽
function c50224140.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,50224140)
	e1:SetCondition(c50224140.spcon)
	e1:SetTarget(c50224140.sptg)
	e1:SetOperation(c50224140.spop)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,50224140+1)
	e2:SetTarget(c50224140.target)
	e2:SetOperation(c50224140.operation)
	c:RegisterEffect(e2)
end
function c50224140.spcfilter(c)
	return c:IsFacedown()
end
function c50224140.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c50224140.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c50224140.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50224140.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c50224140.chfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function c50224140.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g1=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local g2=Duel.GetMatchingGroup(c50224140.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g1+g2,g1:GetCount()+g2:GetCount(),0,0)
end
function c50224140.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	local g2=Duel.GetMatchingGroup(c50224140.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.ChangePosition(g1,POS_FACEDOWN_DEFENSE)
	Duel.ChangePosition(g2,POS_FACEUP_ATTACK)
end