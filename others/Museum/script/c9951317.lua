--神体结界·奥德修斯
function c9951317.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,4,c9951317.ovfilter,aux.Stringid(9951317,1),4,c9951317.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9951317.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c9951317.defval)
	c:RegisterEffect(e2)
 --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951317,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,9951317)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c9951317.cost)
	e3:SetTarget(c9951317.target)
	e3:SetOperation(c9951317.operation)
	c:RegisterEffect(e3)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951317.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951317.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951317,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951317,2))
end
function c9951317.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba5) and c:IsRank(5,6,7)
end
function c9951317.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9951317)==0 end
	Duel.RegisterFlagEffect(tp,9951317,RESET_PHASE+PHASE_END,0,1)
end
function c9951317.atkfilter(c)
	return c:IsSetCard(0xba5) and c:GetAttack()>=0
end
function c9951317.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c9951317.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c9951317.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9951317.filter(c)
	return c:IsSetCard(0xba5) and c:IsLevel(5,6,7) and c:IsSummonableCard() and c:IsAbleToHand()
end
function c9951317.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951317.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9951317.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9951317.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951317,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951317,3))
end