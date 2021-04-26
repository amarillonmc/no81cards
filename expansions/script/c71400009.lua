--异梦书中的公式证明图表
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c),4,2)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetDescription(aux.Stringid(71400009,0))
	e1:SetCountLimit(1,71400009)
	e1:SetTarget(c71400009.tg1)
	e1:SetOperation(c71400009.op1)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(c71400009.raval)
	c:RegisterEffect(e2)
end
function c71400009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c71400009.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mcount=c:GetOverlayCount()
	if mcount<=0 or not Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,mcount,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,mcount,nil)
	Duel.HintSelection(sg)
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.SetLP(tp,Duel.GetLP(tp)-1000)
	end
end
function c71400009.raval(e,c)
	local oc=e:GetHandler():GetOverlayCount()
	return math.max(0,oc-1)
end