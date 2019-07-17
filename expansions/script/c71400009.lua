--梦之书中的公式证明图表
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c),4,2)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetDescription(aux.Stringid(71400009,0))
	e1:SetCondition(c71400009.condition)
	e1:SetTarget(c71400009.target)
	e1:SetOperation(c71400009.operation)
	c:RegisterEffect(e1)
end
function c71400009.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	e:SetLabel(ct)
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c71400009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function c71400009.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 then return end
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local mcount=e:GetLabel()
		if not mcount or mcount<=0 or not Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,mcount,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,mcount,mcount,nil)
		Duel.HintSelection(sg)
		if Duel.Destroy(sg,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.SetLP(tp,Duel.GetLP(tp)-1000)
		end
	end
end