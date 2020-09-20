--fate 斯卡哈
function c9950920.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c9950920.mfilter,4,2)
	c:EnableReviveLimit()
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950920,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9950920.setcon)
	e2:SetTarget(c9950920.settg)
	e2:SetOperation(c9950920.setop)
	c:RegisterEffect(e2)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(9950920,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c9950920.cost)
	e2:SetTarget(c9950920.target)
	e2:SetOperation(c9950920.operation)
	c:RegisterEffect(e2)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950920.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950920.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950920,0))
end
function c9950920.mfilter(c)
	return c:IsSetCard(0xba5) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c9950920.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and re:GetHandler():IsSetCard(0xba5)
end
function c9950920.filter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c9950920.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9950920.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9950920.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9950920.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950920,0))
end
function c9950920.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9950920.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9950920.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,dc)
	if dc:IsSetCard(0xba5) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,2000,REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950920,0))
end
