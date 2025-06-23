--闪耀的六出花 大崎甜花
function c28315944.initial_effect(c)
	--alstroemeria spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,38315944)
	e1:SetCondition(c28315944.spcon)
	e1:SetTarget(c28315944.sptg)
	e1:SetOperation(c28315944.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,28315944)
	e2:SetTarget(c28315944.rectg)
	e2:SetOperation(c28315944.recop)
	c:RegisterEffect(e2)
	c28315944.recover_effect=e2
end
function c28315944.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>8000
end
function c28315944.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c28315944.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28315944.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28315944.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c28315944.sfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c28315944.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,1000,REASON_EFFECT)==0 then return end
	local b1=Duel.IsExistingMatchingCard(c28315944.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetLP(tp)>=10000 and Duel.IsExistingMatchingCard(c28315944.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b3=true
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(28315944,0)},
		{b2,aux.Stringid(28315944,1)},
		{b3,aux.Stringid(28315944,2)})
	if op~=3 then Duel.BreakEffect() end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c28315944.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsFaceup() and c:IsAttackPos() and Duel.SelectOption(tp,aux.Stringid(28315944,3),aux.Stringid(28315944,4))==0 then
			Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		else
			local lp=Duel.GetLP(tp)
			Duel.SetLP(tp,lp-2000)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,c28315944.sfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
