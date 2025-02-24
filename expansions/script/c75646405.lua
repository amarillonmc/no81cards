--Stella-ruim 鹿乃
function c75646405.initial_effect(c)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCost(c75646405.cost)
	e1:SetTarget(c75646405.target)
	e1:SetOperation(c75646405.operation)
	c:RegisterEffect(e1)
	--top
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e4:SetCountLimit(1,75646405)
	e4:SetCost(c75646405.topcost)
	e4:SetTarget(c75646405.tg)
	e4:SetOperation(c75646405.op)
	c:RegisterEffect(e4)
end
function c75646405.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) and g:FilterCount(Card.IsAbleToGraveAsCost,nil)==1 and Duel.IsExistingMatchingCard(c75646405.filter,tp,LOCATION_DECK,0,1,g:GetFirst(),e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	if (g:GetFirst():IsSetCard(0x32c4) or g1:GetFirst():IsSetCard(0x32c4))then e:SetLabel(1) else e:SetLabel(0) end
	g:Merge(g1)
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646405.filter(c,e,tp)
	return  c:IsSetCard(0x32c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75646405.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646405.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c75646405.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp,c75646405.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetLabel()==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0xff0000)
		e1:SetValue(500)
		e:GetHandler():RegisterEffect(e1)
	end
end
function c75646405.topcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c75646405.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,e:GetHandler(),0x32c4) end
end
function c75646405.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(75646402,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),0x32c4)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		local g1=Duel.GetOperatedGroup()
		if g1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ConfirmDecktop(tp,1) end
	end
end