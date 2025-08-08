--龙缠之创导龙裔
dofile("expansions/script/c20000450.lua")
local cm, m = fusf.Initial(fu_GD)
fusf.AddCode(464)
fusf.ReviveLimit()
-- e1
cm.e1 = fuef.E(EFFECT_UPDATE_ATTACK, false):Val("val1")
function cm.val1(e, c)
	return math.floor(e:GetHandler():GetAttack() / 2)
end
-- e2
cm.e2 = fuef.E(EFFECT_DESTROY_SUBSTITUTE, false):Val("val2")
function cm.val2(e,re,r,rp)
	return r & (REASON_BATTLE|REASON_EFFECT) ~= 0
end
-- e3
cm.e3 = fuef.FG("e1"):Ran("M"):Tran("S"):Tg("tg3")("e2")
function cm.tg3(e, c)
	return fugf.Filter(e:GetHandler():GetEquipGroup(), "IsRac","DR")
end
-- e4
cm.e4 = fuef.I():Cat("GA+EQ"):Ran("M"):Ctl(1):Func("tg4,op4")
local e4g1 = fugf.MakeFilter("DG", "IsTyp+IsRac+CanBeEq","RI+M,DR,(%1,%2)")
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #e4g1(tp, tp, e:GetHandler()) > 0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,1-tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec = fugf.Select(tp, e4g1(tp, tp, c), "GChk"):GetFirst()
	fusf.Equip(e,tp,ec,c)
end
-- e5
cm.e5 = fuef.QO("CH"):Cat("NEGA+RE"):Ran("M"):Pro("DAM+CAL"):Ctl(m):Func("con5,nbtg,op5")
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c, rc = e:GetHandler(), re:GetHandler()   
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
		and re:IsActiveType(TYPE_MONSTER) and c:IsAttackAbove(rc:GetAttack())
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
-- e6
cm.e6 = fuef.SC("SP"):Func("RPcon1,RPop2")