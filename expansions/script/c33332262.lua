--热炎生鲜大售卖！
function c33332262.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33332262+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33332262.target)
	e1:SetOperation(c33332262.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(89785779,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c33332262.thcon)
	e2:SetTarget(c33332262.thtg)
	e2:SetOperation(c33332262.thop)
	c:RegisterEffect(e2)
end
function c33332262.thfilter1(c,tp)
	return c:IsSetCard(0xa552) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsAbleToHand(1-tp)
end
function c33332262.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33332262.thfilter1,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function c33332262.lpfilter(c,tp)
	return Duel.CheckLPCost(tp,c:GetDefense()/2)
end
function c33332262.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c33332262.thfilter1,tp,LOCATION_DECK,0,3,3,nil,tp)
	if sg then
		Duel.ConfirmCards(tp,sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local oc=sg:Filter(c33332262.lpfilter,nil,tp):Select(tp,1,1,nil):GetFirst()
		oc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		if Duel.SendtoHand(oc,tp,REASON_EFFECT)~=0 and oc:IsLocation(LOCATION_HAND)  then
			Duel.PayLPCost(tp,oc:GetDefense()/2)
			sg:RemoveCard(oc)
			if sg:Filter(c33332262.lpfilter,nil,1-tp):GetCount()>=1 and Duel.SelectYesNo(1-tp,aux.Stringid(33332262,2)) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
				local sc=sg:Select(1-tp,1,1,nil):GetFirst()
				sc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
				Duel.SendtoHand(sc,1-tp,REASON_EFFECT)
				Duel.PayLPCost(1-tp,sc:GetDefense()/2)
			end
		end
	end
end
function c33332262.thfilter2(c)
	return c:IsFaceup() and c:IsCode(33332257)
end
function c33332262.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33332262.thfilter2,1,nil)
end
function c33332262.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c33332262.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end