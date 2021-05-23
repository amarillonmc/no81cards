--深土之物的苏醒
if not pcall(function() require("expansions/script/c30000100") end) then require("script/c30000100") end
local m,cm = rscf.DefineCard(30013005)
function cm.initial_effect(c)
	local e1 = rsef.A(c,nil,nil,{1},nil,nil,rscon.excard2(Card.IsSetCard,LOCATION_ONFIELD,0,1,nil,0x92c),nil,cm.tg,cm.act)
	local e2 = rsef.QO(c,nil,"pos",{1,m},"pos","tg",LOCATION_GRAVE,nil,rscost.cost({Card.IsAbleToDeckAsCost,"dum"},{cm.tdfilter,{"td",cm.fun},LOCATION_GRAVE }),rstg.target(Card.IsCanChangePosition,"pos",LOCATION_MZONE),cm.posop)
end
function cm.posop(e,tp)
	local tc = rscf.GetTargetCard()
	if not tc then return end
	local pos = 0
	if tc:IsFaceup() and tc:IsCanTurnSet() then pos = pos | POS_FACEDOWN_DEFENSE end
	if tc:IsFacedown() then pos = pos | POS_FACEUP_ATTACK end   
	if pos == 0 then return end
	Duel.ChangePosition(tc,Duel.SelectPosition(tp,tc,pos))
end
function cm.tdfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsType(TYPE_FLIP)
end
function cm.fun(g,e,tp)
	g:AddCard(e:GetHandler())
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.pfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_FLIP) and c:IsCanChangePosition()
end
function cm.pfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_FLIP) and c:IsCanTurnSet()
end
function cm.afilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FLIP)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1 = Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_MZONE,0,1,nil)
	local b2 = Duel.IsExistingMatchingCard(cm.pfilter2,tp,LOCATION_MZONE,0,1,nil)
	local b3 = Duel.IsExistingMatchingCard(cm.afilter,tp,LOCATION_MZONE,0,1,nil)
	if chk == 0 then return b1 or b2 or b3 end
	local op = rshint.SelectOption(tp,b1,{m,1},b2,"dpd",b3,"atk")
	if op == 1 or op == 2 then 
		e:SetCategory(CATEGORY_POSITION)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
	elseif op == 3 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	end
	e:SetLabel(op)
end
function cm.act(e,tp)
	local c = e:GetHandler()
	local op = e:GetLabel()
	local flist = {cm.pfilter,cm.pfilter2,cm.afilter}
	local g,tc = rsop.SelectSolve(HINTMSG_SELF,tp,flist[op],tp,LOCATION_MZONE,0,1,1,nil,{})
	if not tc then return end
	if op == 1 then
		Duel.ChangePosition(tc,Duel.SelectPosition(tp,tc,POS_FACEUP))
	elseif op == 2 then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	elseif op == 3 then
		local atk = tc:GetBaseAttack() + tc:GetBaseDefense()	
		local e1,e2 = rscf.QuickBuff({e:GetHandler(),tc},"fatk,fdef",atk,"rst",rsrst.std_ep)
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
