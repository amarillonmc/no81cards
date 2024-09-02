--忍之箴言
dofile("expansions/script/c20000000.lua")
fu_HC = fu_HC or {}
-------------------
function fu_HC.glo(c,cm)
	fucf.AddCode(c,175)
	cm.lib = fu_HC
	if fu_HC.chk then return end
	fu_HC.chk = {0, 0}
	fuef.FC(c,"PHS+DP",1):OP("glo_op1*")("CH"):Func("glo_con1,glo_op1*1")("NEGA"):Func("glo_op1*-1")
end
function fu_HC.glo_con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(20000175) 
end
function fu_HC.glo_op1(n)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if tonumber(n) then 
			fu_HC.chk[re:GetHandlerPlayer()+1] = fu_HC.chk[re:GetHandlerPlayer()+1] + n
		else 
			fu_HC.chk = {0, 0}
		end
	end
end
-------------------
function fu_HC.T_initial()
	local cm,m = GetID()
	cm.initial_effect = function(c)
		fu_HC.glo(c,cm)
		cm.e1(c)
		fuef.QO(c):PRO("TG"):RAN("G"):CTL(m):Func("Tin_tg1,Tin_op1")
	end
	return cm,m
end
function fu_HC.Tin_tgf1(c,e)
	return c:IsFacedown() and c:GetSequence()<5 and c:IsCanBeEffectTarget(e)
end
function fu_HC.Tin_tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = fugf.GetFilter(tp,"S",fu_HC.Tin_tgf1,e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 and e:GetHandler():IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	fugf.SelectTg(tp,"S",fu_HC.Tin_tgf1,e)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function fu_HC.Tin_op1(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
	Duel.ConfirmCards(1-tp,tc)
	local chk = tc:IsCode(20000175)
	if Duel.GetLocationCount(tp,LOCATION_SZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq = math.log(Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0),2)-8
	Duel.MoveSequence(tc,seq)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SSet(tp,e:GetHandler())==0 or not chk then return end
	fuef.S(e,EFFECT_TRAP_ACT_IN_SET_TURN):PRO("SET"):RES("EV+STD")
end
-------------------
function fu_HC.M_initial()
	local cm,m = GetID()
	cm.initial_effect = function(c)
		fu_HC.glo(c,cm)
		if not cm.e1 then cm.e1 = fu_HC.M_SP end
		cm.e1(c,m)
		fuef.F(c,m):PRO("PTG"):RAN("M"):TRAN("1+0")
		fuef.FC(c,"CH"):RAN("M"):Func("M_con1,M_op1")
	end
	return cm,m
end
function fu_HC.M_con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
function fu_HC.M_op1(e,tp,eg,ep,ev,re,r,rp)
	fuef.S(e,EFFECT_UPDATE_LEVEL):PRO("SR"):RAN("M"):VAL(1):RES("EV+STD+DIS")
	Duel.Damage(1-tp,e:GetHandler():GetLevel()*100,REASON_EFFECT)
end
-------------------
function fu_HC.M_SP(c,m)
	fuef.QO(c):CAT("SP"):RAN("HG"):CTL(m):Func("M_SP_cos1,M_SP_tg1,op1")
end
function fu_HC.M_SP_cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv = e:GetHandler():GetOriginalLevel()
	if chk==0 then return fugf.GetFilter(tp,"M","IsPos+IsSet+IsTyp+AbleTo+IsLv","FU,5fd1,m,*G,+"..lv,1) end
	local g = fugf.SelectFilter(tp,"M","IsPos+IsSet+IsTyp+AbleTo+IsLv","FU,5fd1,m,*G,+"..lv)
	Duel.SendtoGrave(g,REASON_COST)
end
function fu_HC.M_SP_tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
if not self_table then return end
--------------------------------------------------------
local cm = self_table
function cm.initial_effect(c)
	fuef.A(c,EVENT_ATTACK_ANNOUNCE):CAT("TG"):Func("con1,cos1,tg1,op1")
	fuef.S(c,EFFECT_TRAP_ACT_IN_SET_TURN):PRO("SET"):CON("con2")
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetHandler():GetColumnGroup()
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
	if chk==0 then return fugf.GetFilter(tp,"D","AbleTo+IsSet","G,5fd1",1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=fugf.SelectFilter(tp,"D","AbleTo+IsSet","G,5fd1")
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsCanTurnSet()) then return end
	Duel.BreakEffect()
	c:CancelToGrave()
	Duel.ChangePosition(c,POS_FACEDOWN)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
--e2
cm.con2 = function(e) return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),20000180) end