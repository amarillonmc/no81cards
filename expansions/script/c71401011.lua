--花现-「祈」
xpcall(function() require("expansions/script/c71401001") end,function() require("script/c71401001") end)
function c71401011.initial_effect(c)
	--self special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,71401011)
	e1:SetCost(c71401011.cost1)
	e1:SetTarget(c71401011.tg1)
	e1:SetOperation(c71401011.op1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401011,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,71501011)
	e2:SetCondition(c71401011.con2)
	e2:SetTarget(c71401011.tg2)
	e2:SetCost(yume.ButterflyLimitCost)
	e2:SetOperation(c71401011.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401011.filterc1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
end
function c71401011.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401011.filterc1,tp,LOCATION_HAND,0,1,nil) and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71401011.filterc1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71401011.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71401011.filter2ext(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c71401011.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c71401011.filter2ext,tp,LOCATION_ONFIELD,0,1,nil)
end
function c71401011.filter2(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_SPELLCASTER) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsDefenseAbove(0)
end
function c71401011.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c71401011.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c71401011.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c71401011.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c71401011.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local batk=tc:GetBaseAttack()
		local bdef=tc:GetBaseDefense()
		local diff=(batk>bdef) and (batk-bdef) or (bdef-batk)
		local lp=Duel.GetLP(tp)-diff
		Duel.SetLP(tp,lp)
	end
	Duel.SpecialSummonComplete()
end