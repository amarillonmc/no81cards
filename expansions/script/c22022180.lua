--人理之基 牛若丸
function c22022180.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022180,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22022180)
	e1:SetCost(c22022180.cost)
	e1:SetTarget(c22022180.target)
	e1:SetOperation(c22022180.activate)
	c:RegisterEffect(e1)
end
c22022180.toss_dice=true
function c22022180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c22022180.filter(c)
	return c:IsSetCard(0xff1) and c.toss_dice and c:IsAbleToHand()
end
function c22022180.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022180.filter,tp,LOCATION_DECK,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c22022180.activate(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(tp,1)
	if dc==1 or dc==2 or dc==3 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	elseif dc==4 or dc==5 or dc==6 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c22022180.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end