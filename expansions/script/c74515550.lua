--人偶·敖绫
function c74515550.initial_effect(c)
	aux.EnableDualAttribute(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74515550,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(c74515550.postg)
	e1:SetOperation(c74515550.posop)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetCondition(aux.IsDualState)
	c:RegisterEffect(e2)
end
function c74515550.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c74515550.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74515550.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c74515550.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c74515550.posop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c74515550.posfilter,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()>0 then
		Duel.ChangePosition(g1,POS_FACEDOWN_DEFENSE)
	end
end
