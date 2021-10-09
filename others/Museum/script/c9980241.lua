--物语纪录·花
function c9980241.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9980241+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9980241.target)
	e1:SetOperation(c9980241.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980241,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,99802410)
	e2:SetCondition(c9980241.drcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9980241.drtg)
	e2:SetOperation(c9980241.drop)
	c:RegisterEffect(e2)
end
function c9980241.filter(c)
	return c:IsSetCard(0x5bc4) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9980241.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980241.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9980241.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980241.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9980241.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c9980241.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c9980241.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9980241.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(9980241,2)) then
			Duel.ConfirmCards(1-tp,tc)
			Duel.BreakEffect()
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and not Duel.GetAttacker():IsImmuneToEffect(e) then
				Duel.BreakEffect()
				Duel.ChangeAttackTarget(tc)
			end
		end
	end
end
