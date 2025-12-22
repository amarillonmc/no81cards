--闪耀的六出花 大崎甘奈
function c28315943.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--alstroemeria spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,38315943)
	e1:SetCondition(c28315943.spcon)
	e1:SetTarget(c28315943.sptg)
	e1:SetOperation(c28315943.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,28315943)
	e2:SetTarget(c28315943.rectg)
	e2:SetOperation(c28315943.recop)
	c:RegisterEffect(e2)
	c28315943.recover_effect=e2
end
function c28315943.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>8000
end
function c28315943.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c28315943.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c28315943.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28315943.thfilter(c)
	return (c:IsSetCard(0x283) and c:IsLevel(4) or c:IsCode(28335405)) and c:IsAbleToHand()
end
function c28315943.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,1000,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c28315943.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28315943,0)) then
		local c=e:GetHandler()
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c28315943.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		local tcode,acode=tc:GetCode(),c:GetCode()--Tenka & Amana
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if not c:IsRelateToChain() or c:IsFacedown() then return end
		--c:SetHint(CHINT_CARD,tcode)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCondition(c28315943.regcon)
		e1:SetOperation(c28315943.regop)
		e1:SetLabel(tcode,acode)
		Duel.RegisterEffect(e1,tp)
	end
end
function c28315943.chkfilter(c,code)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousCodeOnField()==code
end
function c28315943.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c28315943.chkfilter,1,nil,e:GetLabel())
end
function c28315943.rlfilter(c,code)
	return c:IsCode(code) and c:IsFaceup() and c:IsReleasableByEffect()
end
function c28315943.regop(e,tp,eg,ep,ev,re,r,rp)
	local _,code=e:GetLabel()
	local g=Duel.GetMatchingGroup(c28315943.rlfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,code)
	if #g==0 then return end
	Duel.Hint(HINT_CARD,0,28315943)
	Duel.HintSelection(g)
	Duel.Release(g,REASON_EFFECT)
end
