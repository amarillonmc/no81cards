--恶魔娘 法丽丝
function c98920584.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920584,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,98920584)
	e2:SetCost(c98920584.cost)
	e2:SetTarget(c98920584.sptg)
	e2:SetOperation(c98920584.spop)
	c:RegisterEffect(e2)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920584,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c98920584.thcon)
	e1:SetTarget(c98920584.thtg)
	e1:SetOperation(c98920584.thop)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e1)
end
function c98920584.costfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsAbleToRemoveAsCost()
end
function c98920584.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920584.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c98920584.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(tc)
	e:GetHandler():RegisterFlagEffect(98920584,RESET_EVENT+RESET_TODECK+RESET_TOHAND,0,1)
	tc:RegisterFlagEffect(98920584,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c98920584.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920584.filter(c,code)
	return c:IsType(TYPE_TRAP) and c:IsCode(code) and c:IsSSetable()
end
function c98920584.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) and Duel.SelectYesNo(tp,aux.Stringid(98920584,2)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	   local g=Duel.SelectMatchingCard(tp,c98920584.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	   if g:GetCount()>0 then
		  Duel.SSet(tp,g:GetFirst())
	   end
	end
end
function c98920584.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98920584)~=0
end
function c98920584.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject():GetLabelObject()
	if chk==0 then return tc and tc:GetFlagEffect(98920584)~=0 and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c98920584.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	if tc:GetFlagEffect(98920584)~=0 and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end