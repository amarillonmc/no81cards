--纯白义勇队誓约
function c75080012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75080012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75080012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75080012.target)
	e1:SetOperation(c75080012.activate)
	c:RegisterEffect(e1)
end
function c75080012.thfilter(c)
	return c:IsSetCard(0x758) and c:IsAbleToHand()
end
function c75080012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c75080012.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75080012.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c75080012.thfilter,tp,LOCATION_MZONE,0,1,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c75080012.spfilter(c,e,tp)
	return c:IsSetCard(0x758) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c75080012.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and not ct==1 then return true end
	if Duel.IsExistingMatchingCard(c75080012.spfilter,tp,LOCATION_HAND,0,ct,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(75080012,1)) then
		local sg=Duel.SelectMatchingCard(tp,c75080012.spfilter,tp,LOCATION_HAND,0,ct,ct,nil,e,tp)
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(800)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		Duel.SetLP(tp,Duel.GetLP(tp)-ct*500)
	end
end