--桃绯皇女 宫国朱璃
function c9910503.initial_effect(c)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910503,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910503)
	e1:SetCondition(c9910503.atkcon)
	e1:SetTarget(c9910503.atktg)
	e1:SetOperation(c9910503.atkop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,9910513)
	e2:SetTarget(c9910503.thtg)
	e2:SetOperation(c9910503.thop)
	c:RegisterEffect(e2)
	c9910503.tsukisome_release_effect=e2
end
function c9910503.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa950)
end
function c9910503.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c9910503.cfilter,1,nil)
end
function c9910503.atkfilter(c)
	return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack())
end
function c9910503.atkfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_RITUAL)
end
function c9910503.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atkg=Duel.GetMatchingGroup(c9910503.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local num=math.floor(#atkg/3)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910503.atkfilter2,tp,LOCATION_MZONE,0,1,nil)
		and (num<1 or Duel.IsPlayerCanDraw(tp,num)) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910503.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910503.atkfilter2,tp,LOCATION_MZONE,0,nil)
	tc=g:GetFirst()
	if not tc then return end
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local atkg=Duel.GetMatchingGroup(c9910503.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local num=math.floor(#atkg/3)
	if num<1 then return end
	Duel.Draw(tp,num,REASON_EFFECT)
end
function c9910503.thfilter(c)
	return c:IsSetCard(0xa950) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910503.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910503.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910503.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910503.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
