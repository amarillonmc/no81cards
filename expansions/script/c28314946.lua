--闪耀的放课后 园田智代子
function c28314946.initial_effect(c)
	--hokura spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28314946,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,28314946)
	e1:SetCost(c28314946.spcost)
	e1:SetTarget(c28314946.sptg)
	e1:SetOperation(c28314946.spop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28314946,1))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,38314946)
	e2:SetCondition(c28314946.reccon)
	e2:SetCost(c28314946.cost)
	e2:SetTarget(c28314946.rectg)
	e2:SetOperation(c28314946.recop)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
end
function c28314946.chkfilter(c)
	return c:IsSetCard(0x283) and c:IsNonAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c28314946.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28314946.chkfilter,tp,LOCATION_HAND,0,1,nil) end
	c28314946.cost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c28314946.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c28314946.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c28314946.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28314946.reccon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c28314946.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28314946.thfilter(c)
	return c:IsSetCard(0x283) and c:IsLevel(4) and c:IsAbleToHand() and aux.NecroValleyFilter()(c)
end
function c28314946.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if aux.GetAttributeCount(g)>=3 and Duel.IsExistingMatchingCard(c28314946.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28314946,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c28314946.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c28314946.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFlagEffectLabel(tp,28314946) or 0
	ct=ct|e:GetLabel()
	if ct==e:GetLabel() then
		Duel.RegisterFlagEffect(tp,28314946,RESET_PHASE+PHASE_END,0,1,ct)
	else
		Duel.SetFlagEffectLabel(tp,28314946,ct)
	end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+28362118,e,0,0,0,0)
end
