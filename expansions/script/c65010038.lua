--幻梦迷境 超高速
function c65010038.initial_effect(c)
	--spsummon self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65010038)
	e1:SetCost(c65010038.spscost)
	e1:SetTarget(c65010038.spstg)
	e1:SetOperation(c65010038.spsop)
	c:RegisterEffect(e1)
	--the power
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,65010039)
	e2:SetCost(c65010038.pwcost)
	e2:SetTarget(c65010038.pwtg)
	e2:SetOperation(c65010038.pwop)
	c:RegisterEffect(e2)
end
function c65010038.spscostfil(c)
	return c:IsSetCard(0x6da0) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function c65010038.spscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010038.spscostfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c65010038.spscostfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c65010038.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end

function c65010038.spsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end

function c65010038.costfil(c)
	return c:IsSetCard(0x6da0) and c:IsAbleToRemoveAsCost()
end

function c65010038.pwcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010038.costfil,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65010038.costfil,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c65010038.retcon)
		e1:SetOperation(c65010038.retop)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c65010038.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c65010038.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c65010038.thfil2(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToHand()
end
function c65010038.pwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010038.thfil2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65010038.pwop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65010038.thfil2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_REMOVED,0,1,nil,0x6da0) and Duel.SelectYesNo(tp,aux.Stringid(65010038,0)) then
			Duel.BreakEffect()
			local mg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_REMOVED,0,1,1,nil,0x6da0)
			if mg:GetCount()>0 then
				Duel.SendtoGrave(mg,REASON_EFFECT)
			end
		end
	end
end