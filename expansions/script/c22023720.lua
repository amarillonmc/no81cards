--人理之基 美杜莎·莉莉
function c22023720.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c22023720.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023720,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22023720)
	e1:SetCondition(c22023720.spcon)
	e1:SetTarget(c22023720.sptg)
	e1:SetOperation(c22023720.spop)
	c:RegisterEffect(e1)
	--atk gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c22023720.value)
	c:RegisterEffect(e2)
end
function c22023720.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or (c:IsSynchroType(TYPE_MONSTER) and c:IsSetCard(0x6ff1))
end
function c22023720.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c22023720.filter(c,e,tp)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(3) and c:IsAbleToHand()
end
function c22023720.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22023720.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)>=1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	end
end
function c22023720.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22023720.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
			and Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)>=1
			and Duel.SelectYesNo(tp,aux.Stringid(22023720,1)) then
			Duel.BreakEffect()
			local sg=g1:RandomSelect(1-tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c22023720.vfilter(c)
	return c:IsFacedown()
end
function c22023720.value(e,c)
	return Duel.GetMatchingGroupCount(c22023720.vfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*300
end