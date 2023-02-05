--极星天 格尔赛蜜
function c98920010.initial_effect(c)
		--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98920010)
	e2:SetCost(c98920010.spcost)
	e2:SetTarget(c98920010.sptg)
	e2:SetOperation(c98920010.spop)
	c:RegisterEffect(e2)
	local e22=e2:Clone()
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e22)   
 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920010,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98920010.con)
	e1:SetCost(c98920010.cost)
	e1:SetOperation(c98920010.operation)
	c:RegisterEffect(e1)
end
function c98920010.filter(c,e,tp)
	return c:IsSetCard(0x42) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98920010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920010.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920010.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end
function c98920010.costfilter(c,ec)
	return c:IsSetCard(0x42) and c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost()
end
function c98920010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c98920010.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c98920010.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,c)
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabelObject(cg:GetFirst())
end
function c98920010.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()   
	local code=tc:GetCode()
	local lv=tc:GetLevel()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(lv)
	c:RegisterEffect(e1)	  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(TYPE_TUNER)
	c:RegisterEffect(e2)  
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetValue(code)
	c:RegisterEffect(e3)
end
function c98920010.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c98920010.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c98920010.cfilter,tp,LOCATION_MZONE,0,1,nil)
end