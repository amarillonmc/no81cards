--悲叹之律－序曲
function c22050020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22050020,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22050020+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22050020.target)
	e1:SetOperation(c22050020.activate)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22050020,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(c22050020.operation)
	c:RegisterEffect(e2)
end
function c22050020.filter(c)
	return c:IsSetCard(0xff8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22050020.filter0(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0xff8)
end
function c22050020.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xff8) and c:IsAbleToGrave()
end
function c22050020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22050020.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(c22050020.filter0,tp,LOCATION_MZONE,0,1,nil)>=0 and Duel.IsExistingMatchingCard(c22050020.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	end
end
function c22050020.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22050020.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetMatchingGroupCount(c22050020.filter0,tp,LOCATION_MZONE,0,1,nil)>=1 and Duel.IsExistingMatchingCard(c22050020.tgfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(22050020,1)) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectMatchingCard(tp,c22050020.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoGrave(g1,REASON_EFFECT)
			end
		end
	end
end
function c22050020.filter1(c)
	return c:IsFaceup() and c:IsCanAddCounter(0xfec,1)
end
function c22050020.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22050020.filter1,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do 
		tc:AddCounter(0xfec,1)
		tc=g:GetNext()
	end
end
