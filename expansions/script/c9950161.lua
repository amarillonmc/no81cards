--天地乖离·开辟之星
function c9950161.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950161,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9950161+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c9950161.cost)
	e1:SetTarget(c9950161.target)
	e1:SetOperation(c9950161.activate)
	c:RegisterEffect(e1)
end
function c9950161.cfilter(c)
	return c:IsSetCard(0x9ba5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c9950161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950161.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c9950161.cfilter,1,1,REASON_COST,nil)
end
function c9950161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
	Duel.SetChainLimit(c9950161.chlimit)
end
function c9950161.chlimit(e,ep,tp)
	return tp==ep
end
function c9950161.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local ct1=Duel.Destroy(g,REASON_EFFECT)
	if ct1==0 then return end
	local ct2=Duel.Draw(1-tp,ct1,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Damage(1-tp,ct2*1000,REASON_EFFECT)
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950161,1))
end