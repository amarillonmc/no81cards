--异国的招待
function c98500210.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98500210+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--splimit
	--Remove + Normal Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98500210,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c98500210.rmtg)
	e3:SetOperation(c98500210.rmop)
	c:RegisterEffect(e3)
	--extra material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(c98500210.exrtg)
	e4:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_HAND,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--change effect type
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(98500210)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(98500210,1))
	e7:SetCategory(CATEGORY_DRAW+CATEGORY_POSITION)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetTarget(c98500210.target)
	e7:SetOperation(c98500210.activate)
	c:RegisterEffect(e7)
end
function c98500210.rmcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c98500210.rmfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c98500210.rmfilter(c,code)
	return c:IsSetCard(0x985) and not c:IsCode(code) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c98500210.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98500210.rmcfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c98500210.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c98500210.rmcfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	if g1:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c98500210.rmfilter,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst():GetCode())
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
end
function c98500210.exrtg(e,c)
	return c:IsFacedown()
end
function c98500210.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c98500210.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,0,nil)
	local ct=g:GetCount()
	if ct>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
		local ct2=g2:GetCount()
		local g3=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
		local ct3=g3:GetCount()
		if ct3>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_POSCHANGE)
			local g4=Duel.SelectMatchingCard(1-tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,ct2,nil)
			Duel.ChangePosition(g4,POS_FACEDOWN_DEFENSE)
			Duel.BreakEffect()
			local g5=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			local ct5=g5:GetCount()
			Duel.Draw(1-tp,ct5,REASON_EFFECT)
			local g6=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			local ct6=g6:GetCount()
			Duel.Draw(tp,ct6,REASON_EFFECT)
		end
	end
end
