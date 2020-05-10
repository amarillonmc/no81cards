--超古代邪神 加坦杰厄
if not pcall(function() require("expansions/script/c25000024") end) then require("script/c25000024") end
local m,cm=rscf.DefineCard(25000032)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1,e2=rsef.SV_INDESTRUCTABLE(c,"battle,effect")
	local e3=rsef.QO(c,EVENT_CHAINING,{m,0},{1,m},"neg,pos,dish","dsp,dcal",LOCATION_MZONE,rscon.negcon(nil,true),nil,cm.negtg,cm.negop)
	local e4=rsef.FV_LIMIT_PLAYER(c,"act",cm.actval,nil,{0,1})
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,2)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if rsop.SelectSolve(HINTMSG_POSCHANGE,tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,1,nil,cm.solvefun)>0 then 
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if #g>0 then
			local sg=g:RandomSelect(tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function cm.solvefun(g,e,tp)
	return Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function cm.actval(e,re)
	local rc=re:GetHandler()
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsLocation(LOCATION_SZONE) and rc:IsFacedown()) or rc:IsLocation(LOCATION_GRAVE)
end