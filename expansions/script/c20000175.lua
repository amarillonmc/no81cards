--忍之箴言
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
fu_HC = fu_HC or {}
function fu_HC.glo(c)
	aux.AddCodeList(c,20000175)
	if fu_HC.chk then return end
	fu_HC.chk = 0
	local ge1 = fuef.FC(c,1,"",EVENT_CHAINING,",,",fu_HC.glo_con1,fu_HC.glo_op1(1))
	local ge2 = fuef.Clone(ge1,1,{"COD","NEGA"},{"OP",fu_HC.glo_op1(-1)})
	local ge3 = fuef.FC(c,1,"",EVENT_PHASE_START+PHASE_DRAW,",,,",fu_HC.glo_op1())
end
function fu_HC.IsAct()
	return fu_HC.chk > 0
end
function fu_HC.glo_con1(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(20000175)
end
function fu_HC.glo_op1(n)
	return function()
		fu_HC.chk = n and fu_HC.chk + n or 0
	end
end
if not cm then return end
--------------------------------------------------------
function cm.initial_effect(c)
	local e1=fuef.B_A(c,c,",SH",EVENT_ATTACK_ANNOUNCE,",",cm.con1,cm.cos1,cm.tg1,cm.op1)
	local e2=fuef.S(c,c,"",EFFECT_TRAP_ACT_IN_SET_TURN,"SET,,,",cm.con2)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetColumnGroup()
	if Duel.IsPlayerAffectedByEffect(tp,20000181) then
		for tc in aux.Next(fugf.GetFilter(tp,"MS","IsPos+IsSet","FU,5fd1")) do
			g=g+tc:GetColumnGroup()
		end
	end
	return Duel.GetAttackTarget() and g:IsContains(Duel.GetAttackTarget()) or g:IsContains(Duel.GetAttacker())
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.FromCards(Duel.GetAttacker())
	if Duel.IsPlayerAffectedByEffect(tp,20000182) and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsControler(1-tp) then
		g=g+Duel.GetAttackTarget()
	end
	if chk==0 then return fugf.Filter(g,"AbleTo","*R",1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if #g~=1 then g=g:Select(tp,1,1,nil) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"D","AbleTo+IsSet","H,5fd1",1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=fugf.SelectFilter(tp,"D","AbleTo+IsSet","H,5fd1")
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsCanTurnSet()) then return end
	Duel.BreakEffect()
	c:CancelToGrave()
	Duel.ChangePosition(c,POS_FACEDOWN)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
--e2
function cm.con2(e)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),20000180)
end