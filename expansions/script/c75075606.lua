--白日梦的 露瑟娜斯
function c75075606.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75075606,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,75075606)
	e1:SetTarget(c75075606.thtg)
	e1:SetOperation(c75075606.thop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e0)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75075606,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,75075607)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c75075606.postg)
	e2:SetOperation(c75075606.posop)
	c:RegisterEffect(e2)
	--public
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c75075606.atkcon)
	e3:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(1)
	c:RegisterEffect(e4) 
	--public
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_PUBLIC)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c75075606.atkcon1)
	e5:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e5) 
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(1)
	c:RegisterEffect(e6)  
end
function c75075606.thfilter(c)
	return c:IsSetCard(0x757) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c75075606.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75075606.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75075606.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75075606.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c75075606.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanChangePosition() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c75075606.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
--
function c75075606.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE) and Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c75075606.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE) and Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end