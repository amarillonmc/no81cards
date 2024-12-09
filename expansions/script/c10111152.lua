function c10111152.initial_effect(c)
	c:SetUniqueOnField(1,0,10111152)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10111152.sprcon)
	c:RegisterEffect(e1)
    	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111152,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c10111152.tgcon)
	e2:SetTarget(c10111152.thtg)
	e2:SetOperation(c10111152.thop)
	c:RegisterEffect(e2)
    	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe4))
	e3:SetValue(c10111152.atkval)
	c:RegisterEffect(e3)
	 --Battle!!
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_END_PHASE)
   	e4:SetCountLimit(1)
	e4:SetTarget(c10111152.batg)
	e4:SetOperation(c10111152.baop)
	c:RegisterEffect(e4)
	--grant effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c10111152.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c10111152.spfilter(c)
	return c:IsFacedown() or not (c:IsSetCard(0xe4))
end
function c10111152.sprcon(e,c,tp,eg,ep,ev,re,r,rp)
if c==nil then return true end
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(c10111152.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10111152.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_HAND)
end
function c10111152.filter(c)
	return c:IsSetCard(0xe4) and c:IsType(TYPE_MONSTER) and c:IsAttack(1400) and c:IsAbleToHand() and not c:IsCode(10111152)
end
function c10111152.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111152.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10111152.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10111152.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10111152.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe4)
end
function c10111152.atkval(e,c)
	return Duel.GetMatchingGroupCount(c10111152.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*200
end
function c10111152.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return c:IsAttackable()
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c10111152.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackable() and c:IsControler(tp) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=g:GetFirst()
		if tc:IsControler(1-tp) and tc:IsRelateToEffect(e) then
			Duel.CalculateDamage(c,tc)
		end
	end
end
function c10111152.eftg(e,c)
	return c:IsSetCard(0xe4)
end