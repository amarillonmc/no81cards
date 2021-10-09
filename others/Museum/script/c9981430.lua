--平成三杰·戴拿-强壮型
function c9981430.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9bd1),3)
	c:EnableReviveLimit()
 --destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981430,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c9981430.destg)
	e4:SetOperation(c9981430.desop)
	c:RegisterEffect(e4)
 --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981430,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1921430)
	e2:SetTarget(c9981430.srtg)
	e2:SetOperation(c9981430.srop)
	c:RegisterEffect(e2)
 --atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9981430.atkcon)
	e3:SetValue(3000)
	c:RegisterEffect(e3)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981430,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c9981430.target)
	e2:SetOperation(c9981430.operation)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981430.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981430.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9981430,0))
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981430,1))
end
function c9981430.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9981430.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9981430.srfilter(c)
	return c:IsSetCard(0x9bd1) and c:IsType(TYPE_MONSTER) and not c:IsCode(9981430) and c:IsAbleToHand()
end
function c9981430.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981430.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9981430.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981430.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9981430.filter(c)
	return c:IsFaceup()
end
function c9981430.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c9981430.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9981430.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9981430.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9981430.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c9981430.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bd1)
end
function c9981430.atkcon(e)
	return Duel.GetMatchingGroupCount(c9981430.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)>=3
end