--奥特兄弟·雷欧
function c9951540.initial_effect(c)
		--xyz summon
	aux.AddXyzProcedure(c,c9951540.mfilter,10,2,c9951540.ovfilter,aux.Stringid(9951540,1))
	c:EnableReviveLimit()
 c:SetSPSummonOnce(9951540)
 --code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(9950994)
	c:RegisterEffect(e1)
--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9951540.atkval)
	c:RegisterEffect(e1)
   --negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c9951540.distg)
	c:RegisterEffect(e2)
 --extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951540,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c9951540.atcon)
	e3:SetCost(c9951540.atcost)
	e3:SetOperation(c9951540.atop)
	c:RegisterEffect(e3)
 --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951540,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,9951540)
	e3:SetCondition(c9951540.thcon)
	e3:SetTarget(c9951540.thtg)
	e3:SetOperation(c9951540.thop)
	c:RegisterEffect(e3)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951540.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951540.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951540,0))
end
function c9951540.mfilter(c)
	return c:IsSetCard(0x9bd1) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c9951540.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5bd4) and c:IsLevel(7)
end
function c9951540.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c9951540.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9bd1)
end
function c9951540.atkval(e,c)
	return Duel.GetMatchingGroup(c9951540.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)*300
end
function c9951540.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9951540.thfilter(c)
	return c:IsSetCard(0x5bd4) and c:IsAbleToHand()
end
function c9951540.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951540.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951540.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951540.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951540,1))
end
function c9951540.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdcon(e,tp,eg,ep,ev,re,r,rp)
		and e:GetHandler():IsChainAttackable(0)
end
function c9951540.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9951540.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951540,2))
end