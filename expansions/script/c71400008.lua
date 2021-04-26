--异梦书中的三足怪物
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400008.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c),4,3)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--nuke
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400008,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c71400008.condition)
	e1:SetCost(c71400008.cost)
	e1:SetTarget(c71400008.target)
	e1:SetOperation(c71400008.operation)
	c:RegisterEffect(e1)
end
function c71400008.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD,nil)>2
end
function c71400008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71400008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),1-tp,0)
end
function c71400008.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.SetLP(tp,Duel.GetLP(tp)-1500)
	end
end