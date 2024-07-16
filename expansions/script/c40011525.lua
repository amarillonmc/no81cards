--受监视的密会
function c40011525.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,40011525)
	e2:SetTarget(c40011525.srtg)
	e2:SetOperation(c40011525.srop)
	c:RegisterEffect(e2) 
	-- 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf1b))
	e3:SetTargetRange(LOCATION_SZONE,0)
	c:RegisterEffect(e3) 
	--atk 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0) 
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf1b))
	e4:SetValue(300)
	c:RegisterEffect(e4) 
	--cannot be target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetTarget(function(e,c)
	return c:IsFacedown() end)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--cannot be attacked
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_PUBLIC)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c40011525.atcon)
	e6:SetTargetRange(0,LOCATION_HAND)
	c:RegisterEffect(e6)
end
function c40011525.srfilter(c)
	return c:IsSetCard(0xaf1b) and c:IsAbleToHand()
end
function c40011525.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40011525.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40011525.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40011525.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40011525.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf1b) and c:IsSummonLocation(LOCATION_SZONE)
end
function c40011525.atcon(e)
	return Duel.IsExistingMatchingCard(c40011525.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end





