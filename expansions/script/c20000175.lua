--忍之箴言
dofile("expansions/script/c20000000.lua")
fu_HC = fu_HC or {}
-------------------
function fu_HC.Initial(_glo)
	local cm, m = fusf.Initial(fu_HC, _glo)
	fusf.AddCode(175)
	return cm, m
end
function fu_HC.IsMantraAct(p)
	return fusf.GetCounter(175, p, "CH") > 0
end
function fu_HC.MInitial(_glo, lv)
	local cm, m = fu_HC.Initial(_glo)
	fusf.ReviveLimit()
	cm.pe1 = fuef.F(m):Pro("PTG"):Ran("M"):Tran(1, 0)
	cm.pe2 = fuef.FC("CH"):Ran("M"):Func("M_pcon2,M_pop2")
	if not lv then return cm, m end
	cm.pe3 = fuef.ProcXyzLv(lv)
	cm.pe4 = fuef.ProcXyzAlter("MProc_cf", nil, 1):Ctl(m + 100)
	cm.MProc_cf = fucf.MakeCardFilter("IsSet+IsRk-IsCode", {"5fd1,+"..tostring(lv), m})
	return cm, m
end
-------------------
function fu_HC.M_pcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep == tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
		and fucf.Filter(re:GetHandler(), "IsCode/IsSet", "175,5fd1")
end
function fu_HC.M_pop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,e:GetHandler():GetCode())
	if Duel.Damage(1 - tp, e:GetHandler():GetRank() * 100, REASON_EFFECT) == 0 then return end
	fuef.S(e, EFFECT_UPDATE_RANK):Pro("SR"):Ran("M"):Val(1):Res("STD+DIS")
end
if self_code ~= 20000175 then return end
--------------------------------------------------------
local cm, m = fusf.Initial()
--AddCounter
fusf.AddCounter(m, "CH", "counter")
function cm.counter(re, tp, cid)
	return re:GetHandler():IsCode(m) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--e1
cm.e1 = fuef.A("ATK"):Cat("TG"):Func("con1,cos1,tg1,op1")
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetHandler():GetColumnGroup()
	local at = Duel.GetAttackTarget()
	return at and g:IsContains(at) or g:IsContains(Duel.GetAttacker())
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Group.FromCards(Duel.GetAttacker())
	local at = Duel.GetAttackTarget()
	if Duel.IsPlayerAffectedByEffect(tp,20000183) and at and at:IsControler(1 - tp) then
		g = g + Duel.GetAttackTarget()
	end
	g = fugf.Filter(g, "AbleTo", "*R")
	if chk==0 then return #g > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g = fugf.Select(tp, g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
local e1g1 = fugf.MakeFilter("D","AbleTo+IsSet","G,5fd1")
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #e1g1(tp) > 0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
local function MoveOp(c, tp)
	if not Duel.IsPlayerAffectedByEffect(tp,20000182) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE) == 0 then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq = math.log(Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0),2)-8
	Duel.Hint(HINT_CARD,tp,20000182)
	Duel.MoveSequence(c, seq)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g = fugf.Select(tp,e1g1(tp))
	if #g > 0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local c = e:GetHandler()
	MoveOp(c, tp)
	if not (c:IsRelateToEffect(e) and c:IsCanTurnSet()) then return end
	Duel.BreakEffect()
	c:CancelToGrave()
	Duel.ChangePosition(c,POS_FACEDOWN)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end
--e2
cm.e2 = fuef.S(EFFECT_TRAP_ACT_IN_SET_TURN):Pro("SET"):Con("con2")
function cm.con2(e)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),20000181) 
end