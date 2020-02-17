--光之国-雷欧 
function c9950994.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9950994.lcheck)
	c:EnableReviveLimit()
 --atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9950994.atkval)
	c:RegisterEffect(e1)
   --negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c9950994.distg)
	c:RegisterEffect(e2)
 --extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950994,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(2)
	e3:SetCondition(c9950994.atcon)
	e3:SetCost(c9950994.atcost)
	e3:SetOperation(c9950994.atop)
	c:RegisterEffect(e3)
 --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950994,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,9950994)
	e3:SetCondition(c9950994.thcon)
	e3:SetTarget(c9950994.thtg)
	e3:SetOperation(c9950994.thop)
	c:RegisterEffect(e3)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950994.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950994.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950994,0))
end
function c9950994.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x9bd1)
end
function c9950994.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c9950994.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9bd1)
end
function c9950994.atkval(e,c)
	return Duel.GetMatchingGroup(c9950994.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)*300
end
function c9950994.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9950994.thfilter(c)
	return c:IsSetCard(0x9bd1) and c:IsAbleToHand()
end
function c9950994.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950994.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950994.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950994.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950994,1))
end
function c9950994.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
		and e:GetHandler():IsChainAttackable(0)
end
function c9950994.costfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x9bd1) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsDiscardable()
end
function c9950994.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950994.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9950994.costfilter,1,1,REASON_DISCARD+REASON_COST)
end
function c9950994.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950994,1))
end