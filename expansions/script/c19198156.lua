--魔救之奇迹-仙子晶石
function c19198156.initial_effect(c)

--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsSetCard,0x140),nil,nil,aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),1,1)
	c:EnableReviveLimit()
--to hand1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19198156,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,19198156)
	e1:SetCondition(c19198156.thcon)	
	e1:SetTarget(c19198156.thtg)
	e1:SetOperation(c19198156.thop)
	c:RegisterEffect(e1)
--to hand 2
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19198156,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,19198157)
	e2:SetCondition(c19198156.spcon)
	e2:SetTarget(c19198156.sptg)
	e2:SetOperation(c19198156.spop)
	c:RegisterEffect(e2)
 --nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(c19198156.tnval)
	c:RegisterEffect(e3)
end
--to hand1
function c19198156.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c19198156.thfilter(c)
	return c:IsSetCard(0x140) and  c:IsAbleToHand()
end
function c19198156.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19198156.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c19198156.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c19198156.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		end
	end
	--local e1=Effect.CreateEffect(c)
   -- e1:SetType(EFFECT_TYPE_FIELD)
   -- e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
   -- e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
   -- e1:SetTargetRange(1,0)
   -- e1:SetTarget(c19198156.splimit)
   -- e1:SetReset(RESET_PHASE+PHASE_END)
   -- Duel.RegisterEffect(e1,tp)
end
--function c19198156.splimit(e,c)
--	return not c:IsSetCard(0x14d)
--end

--to hand 2
function c19198156.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c19198156.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c19198156.thfilter2(c)
	return c:IsSetCard(0x140) and c:IsAbleToHand()
end
function c19198156.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount()
	if ct>0 and g:FilterCount(c19198156.thfilter2,nil)>0 and Duel.SelectYesNo(tp,aux.Stringid(19198156,2)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c19198156.thfilter2,1,3,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		ct=g:GetCount()-sg:GetCount()
	end
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
		--for i=1,ct do
			--local mg=Duel.GetDecktopGroup(tp,1)
		   -- Duel.MoveSequence(mg:GetFirst(),1)
	   -- end
	end
end
function c19198156.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
