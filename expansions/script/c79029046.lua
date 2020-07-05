--黑钢国际·先锋干员-香草
function c79029046.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51858306,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,79029046)
	e1:SetTarget(c79029046.target)
	e1:SetOperation(c79029046.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(48210156,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,079029046)
	e2:SetTarget(c79029046.sptg)
	e2:SetOperation(c79029046.spop)
	c:RegisterEffect(e2)	
end
function c79029046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c79029046.filter(c)
	return c:IsSetCard(0x1904) and c:IsAbleToRemove()
end
function c79029046.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(tp) then return end
	if not Duel.IsExistingMatchingCard(c79029046.filter,tp,LOCATION_DECK,0,1,nil) then return end
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c79029046.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
end
end
function c79029046.filter2(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029046.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(tp) and c79029046.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c79029046.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c79029046.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c79029046.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end