local m=25000072
local cm=_G["c"..m]
cm.name="筋骨械炮"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.filter1(c,tp)
	local p,rac=c:GetControler(),c:GetOriginalRace()
	local g=Group.__add(Duel.GetFieldGroup(p,LOCATION_DECK,0),Duel.GetFieldGroup(p,LOCATION_HAND,0):Filter(Card.IsFacedown,nil))
	return c:IsFaceup() and c:IsReleasable() and c:GetRace()~=rac and (Duel.IsExistingMatchingCard(cm.filter2,p,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,c,c:GetOriginalAttribute()) or (p~=tp and #g>0))
end
function cm.filter2(c,rac)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and c:IsRace(rac)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	e:SetLabel(rg:GetFirst():GetOriginalRace(),rg:GetFirst():GetControler())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local rac,p=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.filter2,p,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,nil,rac)
	Duel.Destroy(g,REASON_EFFECT)
end
