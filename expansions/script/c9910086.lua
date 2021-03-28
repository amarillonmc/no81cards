--绘裳之月神
function c9910086.initial_effect(c)
	--turn set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910086)
	e1:SetTarget(c9910086.target)
	e1:SetOperation(c9910086.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910087)
	e2:SetTarget(c9910086.reptg)
	e2:SetValue(c9910086.repval)
	e2:SetOperation(c9910086.repop)
	c:RegisterEffect(e2)
end
function c9910086.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c9910086.thfilter(c)
	return c:IsSetCard(0x9951) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9910086.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)~=0 then
		local g=Duel.GetMatchingGroup(c9910086.thfilter,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910086,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c9910086.repfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c9910086.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_RELEASE) and c:IsAbleToRemove()
		and eg:IsExists(c9910086.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c9910086.repval(e,c)
	return c9910086.repfilter(c,e:GetHandlerPlayer())
end
function c9910086.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
