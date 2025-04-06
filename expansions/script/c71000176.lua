--七仟陌的时钟
function c71000176.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xe73),aux.NonTuner(Card.IsSetCard,0xe73),1)
	c:EnableReviveLimit()
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71000176,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,71000176)
	e1:SetTarget(c71000176.tg)
	e1:SetOperation(c71000176.op)
	c:RegisterEffect(e1)
	--2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(c71000176.atklimit)
	c:RegisterEffect(e4)
	--3
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(71000176,0))
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetCountLimit(1,71000176)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCondition(c71000176.spcon)
	c:RegisterEffect(e12)

end
--1
function c71000176.f(c)
	return  c:IsAbleToHand() and c:IsSetCard(0xe73)
end 
function c71000176.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71000176.f,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71000176.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71000176.f,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0  then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--2
function c71000176.atklimit(e,c)
	return c:IsFaceup() and not c:IsCode(71000176) and c:IsRace(RACE_SPELLCASTER)
end
--3
function c71000176.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe73) and c:IsType(TYPE_MONSTER)
end
function c71000176.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71000176.cfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end