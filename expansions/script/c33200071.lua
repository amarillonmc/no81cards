--铁战灵兽 波士可多拉
function c33200071.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200071+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200071.spcon)
	e1:SetOperation(c33200071.spop)
	c:RegisterEffect(e1)   
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c33200071.indct)
	c:RegisterEffect(e2)  
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,33200072)
	e3:SetTarget(c33200071.thtg)
	e3:SetOperation(c33200071.thop)
	c:RegisterEffect(e3)
end
--e1
function c33200071.spfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x322) and not c:IsCode(33200071) and c:IsAbleToDeckAsCost()
		and (ft>0 or c:GetSequence()<5)
end
function c33200071.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c33200071.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c33200071.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c33200071.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end

--e2
function c33200071.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end

--e3
function c33200071.thfilter(c)
	return c:IsSetCard(0x322) and c:IsAbleToHand()
end
function c33200071.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c33200071.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200071.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33200071.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
		Duel.ConfirmCards(1-tp,sg1)
		local cg=sg1:RandomSelect(1-tp,1)
		local tc=cg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand()
		Duel.ShuffleDeck(tp)
	end
end
