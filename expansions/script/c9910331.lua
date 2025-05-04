--潜匿罪恶的匪魔城
function c9910331.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910331+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9910331.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910331,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MSET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c9910331.setcon1)
	e2:SetTarget(c9910331.settg)
	e2:SetOperation(c9910331.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCondition(c9910331.setcon2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c9910331.setcon2)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_SSET)
	e5:SetCondition(c9910331.setcon1)
	c:RegisterEffect(e5)
end
function c9910331.thfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x3954) and c:IsRace(RACE_FIEND) and c:IsAbleToHand()
end
function c9910331.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910331.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910331,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9910331.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c9910331.cfilter(c,tp)
	return c:IsFacedown() and c:IsControler(tp)
end
function c9910331.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910331.cfilter,1,nil,tp)
end
function c9910331.setfilter(c)
	return c:IsSetCard(0x3954) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c9910331.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910331.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9910331.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9910331.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SSet(tp,g:GetFirst())~=0 then
		local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #sg>=2 and Duel.SelectYesNo(tp,aux.Stringid(9910331,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tg=sg:Select(tp,2,2,nil)
			Duel.HintSelection(tg)
			Duel.BreakEffect()
			if tg:FilterCount(Card.IsAbleToHand,nil)==2
				and Duel.SelectOption(tp,aux.Stringid(9910331,3),aux.Stringid(9910331,4))==1 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
			else
				Duel.Destroy(tg,REASON_EFFECT)
			end
		end
	end
end
