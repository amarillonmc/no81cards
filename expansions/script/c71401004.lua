--蝶现-「像」
xpcall(function() require("expansions/script/c71401001") end,function() require("script/c71401001") end)
function c71401004.initial_effect(c)
	--same effect sends this card to grave or banishes it, and spsummon another card check
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	local e0a=yume.AddThisCardBanishedAlreadyCheck(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71401004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,71401004)
	e1:SetCost(c71401004.cost1)
	e1:SetTarget(c71401004.tg1)
	e1:SetOperation(c71401004.op1)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1a:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1a:SetCondition(c71401004.con1)
	e1a:SetLabelObject(e0)
	c:RegisterEffect(e1a)
	local e1b=e1a:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1b:SetRange(LOCATION_REMOVED)
	e1b:SetLabelObject(e0a)
	c:RegisterEffect(e1b)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71401004,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,71501004)
	e2:SetCondition(c71401004.con2)
	e2:SetCost(yume.ButterflyLimitCost)
	e2:SetTarget(c71401004.tg2)
	e2:SetOperation(c71401004.op2)
	c:RegisterEffect(e2)
	yume.ButterflyCounter()
end
function c71401004.filtercon1(c,tp,se)
	return se==nil or c:GetReasonEffect()~=se
end
function c71401004.con1(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c71401004.filtercon1,1,nil,tp,se)
end
function c71401004.filterc1(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
		and Duel.GetMZoneCount(tp,c)>0
end
function c71401004.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401004.filterc1,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.GetCustomActivityCount(71401001,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71401004.filterc1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.RegButterflyCostLimit(e,tp)
end
function c71401004.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71401004.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71401004.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function c71401004.filter2ext(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function c71401004.filter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove()
end
function c71401004.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71401004.filter2ext,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c71401004.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c71401004.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71401004.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
end