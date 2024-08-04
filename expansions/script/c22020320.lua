--人理之基 美杜莎
function c22020320.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020320,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22020320)
	e1:SetCondition(c22020320.spcon)
	e1:SetTarget(c22020320.sptg)
	e1:SetOperation(c22020320.spop)
	c:RegisterEffect(e1)
	--spsummon opp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22020320,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,22020321)
	e3:SetCondition(c22020320.condition)
	e3:SetTarget(c22020320.target)
	e3:SetOperation(c22020320.operation)
	c:RegisterEffect(e3)
end
function c22020320.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x6ff1) and re:GetHandler():IsType(TYPE_MONSTER)
end
function c22020320.filter(c,e,tp)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22020320.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22020320.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)>=1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	end
end
function c22020320.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22020320.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
			and Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)>=1
			and Duel.SelectYesNo(tp,aux.Stringid(22020320,1)) then
			Duel.BreakEffect()
			local sg=g1:RandomSelect(1-tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c22020320.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetPreviousControler()==tp
end
function c22020320.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22020320.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
