--坚毅可汗芾洛塔
function c87531065.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c87531065.atktg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87531065,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,87531065)
	e2:SetCost(c87531065.cost)
	e2:SetTarget(c87531065.drtg)
	e2:SetOperation(c87531065.drop)
	c:RegisterEffect(e2)
end
function c87531065.atktg(e,c)
	return c:IsFaceup()
end
function c87531065.discfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToGraveAsCost() and c:GetDefense()>c:GetAttack()
end
function c87531065.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c87531065.discfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c87531065.discfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c87531065.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c87531065.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end