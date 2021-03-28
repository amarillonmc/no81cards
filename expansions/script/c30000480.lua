--暗渡寂
function c30000480.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,30000480)
	e1:SetCost(c30000480.spcost)
	e1:SetTarget(c30000480.sptg)
	e1:SetOperation(c30000480.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c30000480.rectg)
	e2:SetOperation(c30000480.recop)
	c:RegisterEffect(e2)
end
function c30000480.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable() and c:IsAttribute(ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,c:GetLevel(),nil)
end
function c30000480.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000480.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.DiscardHand(tp,c30000480.costfilter,1,1,REASON_COST+REASON_DISCARD)
	local g=Duel.GetOperatedGroup()
	e:SetLabel(g:GetFirst():GetLevel())
end
function c30000480.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c30000480.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,e:GetLabel(),nil)
	local g=Duel.GetDecktopGroup(tp,e:GetLabel())
	if Duel.SendtoGrave(g,REASON_EFFECT)~0 then
		local og=Duel.GetOperatedGroup()
		og=og:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		for tc in aux.Next(og) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function c30000480.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c30000480.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end