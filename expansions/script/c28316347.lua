--闪耀的六出花 桑山千雪
function c28316347.initial_effect(c)
	--alstroemeria spsummon-hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,28316347+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c28316347.hspcon)
	c:RegisterEffect(e1)
	--alstroemeria spsummon-grave
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28316347.gspcon)
	e2:SetOperation(c28316347.gspop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,28316347)
	e3:SetTarget(c28316347.thtg)
	e3:SetOperation(c28316347.thop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER+CATEGORY_RELEASE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,28316347)
	e4:SetTarget(c28316347.rectg)
	e4:SetOperation(c28316347.recop)
	c:RegisterEffect(e4)
	c28316347.recover_effect=e4
end
function c28316347.hspcon(e,c)
	if c==nil then return true end
   return Duel.GetLP(e:GetHandlerPlayer())>=9000 and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0
end
function c28316347.alfilter(c)
	return c:IsSetCard(0x287) and c:IsFaceup()
end
function c28316347.gspcon(e,c)
	if c==nil then return true end
	local p=e:GetHandlerPlayer()
	return Duel.GetLP(p)>=9000 and Duel.GetLocationCount(p,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c28316347.alfilter,p,LOCATION_MZONE,0,1,nil)
end
function c28316347.gspop(e,tp,eg,ep,ev,re,r,rp,c)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-2000)
end
function c28316347.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28316347.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28316347.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28316347.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28316347.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsAttribute(ATTRIBUTE_EARTH) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end
function c28316347.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28316347.hkfilter(c)
	return c:IsSetCard(0x283) and c:IsLevel(4) and c:IsAbleToHand()
end
function c28316347.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
	if Duel.GetLP(tp)>=10000 then
		local b1=Duel.IsExistingMatchingCard(c28316347.hkfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,REASON_EFFECT)
		local b3=true
		if not (b1 or b2) then return end
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(28316347,0)},
			{b2,aux.Stringid(28316347,1)},
			{b3,aux.Stringid(28316347,2)})
		if op==1 then
			local lp=Duel.GetLP(tp)
			Duel.SetLP(tp,lp-2000)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c28316347.hkfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		elseif op==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,REASON_EFFECT)
			Duel.HintSelection(g)
			Duel.Release(g,REASON_EFFECT)
		end
	end
end
