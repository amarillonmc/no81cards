--尽露的永夏 三谷良一
function c9910968.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910968.flag)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910968)
	e1:SetCost(c9910968.spcost)
	e1:SetTarget(c9910968.sptg)
	e1:SetOperation(c9910968.spop)
	c:RegisterEffect(e1)
end
function c9910968.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910968.costfilter(c)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_WATER)
		and c:IsAbleToGraveAsCost()
end
function c9910968.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910968.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910968.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910968.filter(c)
	return c:IsSetCard(0x5954) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c9910968.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=Duel.IsExistingMatchingCard(c9910968.filter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not res or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if res then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(0)
	end
end
function c9910968.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetLabel()==1 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
