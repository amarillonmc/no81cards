--百万吨拳击
function c10113016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10113016.target)
	e1:SetOperation(c10113016.activate)
	c:RegisterEffect(e1)	
end
function c10113016.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c10113016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g,dg=Duel.GetMatchingGroup(c10113016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil),Group.CreateGroup()
	if g:GetCount()>0 then
	   local tg=g:GetMaxGroup(Card.GetAttack)
	   g:Sub(tg)
	   dg:Merge(g)
	end
	if chk==0 then return dg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function c10113016.activate(e,tp,eg,ep,ev,re,r,rp)
	local g,dg=Duel.GetMatchingGroup(c10113016.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil),Group.CreateGroup()
	if g:GetCount()>0 then
	   local tg=g:GetMaxGroup(Card.GetAttack)
	   g:Sub(tg)
	   dg:Merge(g)
	   if dg:GetCount()>0 then
		  Duel.Destroy(dg,REASON_EFFECT)
	   end
	end
end