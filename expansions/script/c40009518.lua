--黄金之剑毅 格吉特·布雷德
function c40009518.initial_effect(c)
	aux.AddCodeList(c,40009510)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,40009510),aux.NonTuner(nil),1)
	c:EnableReviveLimit()	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009518,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,40009518)
	e1:SetCondition(c40009518.setcon)
	e1:SetTarget(c40009518.settg)
	e1:SetOperation(c40009518.setop)
	c:RegisterEffect(e1)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009518,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,40009518)
	e3:SetCondition(c40009518.tscon)
	e3:SetTarget(c40009518.tstg)
	e3:SetOperation(c40009518.tsop)
	c:RegisterEffect(e3)
end
function c40009518.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c40009518.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,40009510) and c:IsSSetable()
end
function c40009518.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40009518.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c40009518.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c40009518.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function c40009518.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_WARRIOR)
end
function c40009518.tscon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c40009518.cfilter,tp,LOCATION_MZONE,0,1,nil)		
end
function c40009518.tsfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c40009518.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009518.tsfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009518.tsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40009518.tsfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



