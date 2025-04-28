--创导龙裔·龙缠者
dofile("expansions/script/c20000450.lua")
local cm, m = fuef.initial(fu_GD, nil, "AddCode,ReviveLimit", 464)
cm.e1 = fuef.E(EFFECT_UPDATE_ATTACK, false):VAL("val1")
cm.e2 = fuef.E(EFFECT_DESTROY_SUBSTITUTE, false):VAL("val2")
cm.e3 = fuef.FG("e1"):RAN("M"):TRAN("S"):TG("tg3")("e2")
cm.e4 = fuef.I():CAT("GA+EQ"):RAN("M"):CTL(1):Func("tg4,op4")
cm.e5 = fuef.QO("CH"):CAT("NEGA+RE"):RAN("M"):PRO("DAM+CAL"):CTL(m):Func("con5,nbtg,op5")
-- e1
function cm.val1(e, c)
	return math.floor(e:GetHandler():GetAttack() / 2)
end
-- e2
function cm.val2(e,re,r,rp)
	return r & (REASON_BATTLE|REASON_EFFECT) ~= 0
end
-- e3
function cm.tg3(e, c)
	return fugf.Filter(e:GetHandler():GetEquipGroup(), "IsRac","DR")
end
-- e4
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp, "DG", "IsTyp+IsRac+CanEq","RI+M,DR,%1", 1, tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,1-tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec = fugf.Select(tp, "DG", "IsTyp+IsRac+CanEq+GChk","RI+M,DR,%1", 1, 1, tp):GetFirst()
	fusf.Equip(e,tp,ec,c)
end
-- e5
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c, rc = e:GetHandler(), re:GetHandler()   
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER) and c:IsAttackAbove(rc:GetAttack())
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
