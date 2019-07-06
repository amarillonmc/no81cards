--铁虹弹阵
if not pcall(function() require("expansions/script/c33700720") end) then require("script/c33700720") end
local m=33700724
local cm=_G["c"..m]
function cm.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(rsneov.LPCon)
	e1:SetCost(rsneov.ToGraveCost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)	
end
function cm.rfilter(c)
	return c:IsReleasableByEffect() and c:GetTextDefense()>0 and c:IsSetCard(0x44e)
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.SelectReleaseGroup(tp,cm.rfilter,1,1,nil,ATTRIBUTE_FIRE)
	Duel.HintSelection(g)
	local def=g:GetFirst():GetTextDefense()
	if def<0 then def=0 end
	if Duel.Release(g,REASON_COST)~=0 then
		Duel.Damage(1-tp,def,REASON_EFFECT)
	end
end

