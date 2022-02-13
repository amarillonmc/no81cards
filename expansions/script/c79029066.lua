--啸岚寒域 支线崩坏
function c79029066.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029066+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c79029066.damcost)
	e1:SetTarget(c79029066.damtg)
	e1:SetOperation(c79029066.damop)
	c:RegisterEffect(e1)
end
c79029066.named_with_KarlanTrade=true 
function c79029066.ctfil(c)
	return c.named_with_KarlanTrade and c:IsAbleToGraveAsCost()
end
function c79029066.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029066.ctfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,e:GetHandler()) end 
	local g=Duel.SelectMatchingCard(tp,c79029066.ctfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,e:GetHandler()) 
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029066.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,2000)
end
function c79029066.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
