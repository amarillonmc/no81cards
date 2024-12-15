--向着梦中
function c12866735.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,12866735+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c12866735.condition)
	e1:SetTarget(c12866735.target)
	e1:SetOperation(c12866735.activate)
	c:RegisterEffect(e1)
end
function c12866735.cfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c12866735.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	if not b then return false end
	local g=Group.FromCards(a,b)
	return g:IsExists(c12866735.cfilter,1,nil)
end
function c12866735.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	local g=Group.FromCards(a,b)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c12866735.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 and Duel.IsPlayerCanDraw(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(12866735,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
