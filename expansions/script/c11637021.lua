--“客人，您这样我们很难办”
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e01=e1:Clone()
	e01:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e01)
end

function s.filter(c,tp)
	return c:IsSetCard(0x9221) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousControler(tp) and bit.band(c:GetPreviousTypeOnField(),TYPE_FUSION+TYPE_MONSTER)==TYPE_FUSION+TYPE_MONSTER
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filter,nil,tp)
	local num=g:GetSum(Card.GetPreviousAttackOnField)
	local dnum=math.floor(num/1000)
	local g=Duel.GetDecktopGroup(1-tp,dnum)
	if chk==0 then return dnum>0 and g:FilterCount(Card.IsAbleToHand,nil)==dnum end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,dnum,1-tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil,tp)
	local num=g:GetSum(Card.GetPreviousAttackOnField)
	local dnum=math.floor(num/1000)
	local g=Duel.GetDecktopGroup(1-tp,dnum)
	if g:FilterCount(Card.IsAbleToHand,nil)==dnum then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end