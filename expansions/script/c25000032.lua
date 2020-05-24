--超古代邪神 加坦杰厄
if not pcall(function() require("expansions/script/c25000024") end) then require("script/c25000024") end
local m,cm=rscf.DefineCard(25000032)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=rscf.SetSummonCondition(c,false,aux.ritlimit)
	local e1,e2=rsef.SV_INDESTRUCTABLE(c,"battle,effect")
	local e3=rsef.QO(c,EVENT_CHAINING,{m,0},{1,m},"neg,pos,dish","dsp,dcal",LOCATION_MZONE,rscon.negcon(2,true),nil,cm.negtg,cm.negop)
	local e4=rsef.FV_LIMIT_PLAYER(c,"act",cm.actval,nil,{0,1})
	local e5=rsef.FV_LIMIT_PLAYER(c,"act",cm.actval2,nil,{0,1})
	local e6,e7=rsef.FV_UPDATE(c,"atk,def",cm.atkval,nil,{0,LOCATION_MZONE })
end
function cm.mat_filter(c)
	return not c:IsLevel(12)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,LOCATION_MZONE)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0))>0 then
		Duel.BreakEffect()
		rsop.SelectSolve(HINTMSG_POSCHANGE,tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,1,nil,cm.solvefun)
	end
end
function cm.solvefun(g,e,tp)
	return Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function cm.actval(e,re)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local rc=re:GetHandler()
	return not rc:IsLocation(LOCATION_SZONE)
end
function cm.actval(e,re)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_GRAVE)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.afilter,tp,rsloc.og,rsloc.og,nil)*100
end
function cm.afilter(c)
	return c:IsFacedown() or c:IsLocation(LOCATION_GRAVE)
end