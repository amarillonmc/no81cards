--闪耀的六出花 桑山千雪
function c28316347.initial_effect(c)
	--alstroemeria spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,38316347)
	e1:SetCondition(c28316347.spcon)
	e1:SetTarget(c28316347.sptg)
	e1:SetOperation(c28316347.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,28316347)
	e2:SetTarget(c28316347.rectg)
	e2:SetOperation(c28316347.recop)
	c:RegisterEffect(e2)
	c28316347.recover_effect=e2
end
function c28316347.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>8000
end
function c28316347.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c28316347.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28316347.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28316347.recop(e,tp,eg,ep,ev,re,r,rp)
	local b1=true
	local b2=Duel.IsPlayerCanDraw(tp,1)
	local b3=Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28316347,0)},
		{b2,aux.Stringid(28316347,1)},
		{b3,aux.Stringid(28316347,2)})
	if op==1 then
		Duel.Recover(tp,1000,REASON_EFFECT)
	elseif op==2 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif op==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		Duel.Release(g,REASON_EFFECT)
	end
end
