--战车道的重击
function c9910136.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910136+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9910136.cost)
	e1:SetTarget(c9910136.target)
	e1:SetOperation(c9910136.activate)
	c:RegisterEffect(e1)
end
function c9910136.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost()
end
function c9910136.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local g2=Duel.GetOverlayGroup(tp,1,0)
	if g1:GetCount()>0 then g:Merge(g1) end
	if g2:GetCount()>0 then g:Merge(g2) end
	if chk==0 then return g:IsExists(c9910136.cfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,c9910136.cfilter,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c9910136.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9910136.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x952)
end
function c9910136.ctfilter(c)
	local g=Group.FromCards(c)
	g:Merge(c:GetColumnGroup())
	return g:IsExists(c9910136.cfilter2,2,nil)
end
function c9910136.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.Damage(1-tp,1000,REASON_EFFECT)
	local ct2=Duel.Draw(tp,1,REASON_EFFECT)
	if ct1>0 and ct2>0 then
		local g=Duel.GetMatchingGroup(c9910136.desfilter,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910136,0)) then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
