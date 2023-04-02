--顾盼的永夏 野村美希
require("expansions/script/c9910950")
function c9910955.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910955)
	e1:SetCost(c9910955.spcost)
	e1:SetTarget(c9910955.sptg)
	e1:SetOperation(c9910955.spop)
	c:RegisterEffect(e1)
	--add effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(9910955)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCountLimit(1,9910956)
	c:RegisterEffect(e2)
end
function c9910955.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 end
	Duel.ConfirmCards(tp,g)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c9910955.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910955.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=false
	if c:IsRelateToEffect(e) then
		res=Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
	end
	QutryYx.ExtraEffectSelect(e,tp,res)
end
