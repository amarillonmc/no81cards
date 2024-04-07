--无亘龙 帕哈拉
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
fu_imm = fu_imm or {}
function fu_imm.initial(_cat, _fuef)
	local _cm, _m = GetID()
	_cm.initial_effect = fu_imm.give(_cm, _cat, _fuef)
	return _cm, _m
end
function fu_imm.give(_cm, _cat, _fuef)
	_cm.lib = fu_imm
	return function(c)
		_fuef:Owner(c, false)
		fuef.FG(c):RAN("GR"):TRAN("M+0"):Func("give_con1,give_tg1"):OBJ(_fuef.e)
		local _r_chk = fuef.STO(c,"BM"):CON("give_con2"):TG("FALSE")
		if fusf.NotNil(_cat) then _r_chk:CAT(_cat):PRO("DE"):CTL(c:GetCode()):Func("tg2,op2") end
	end
end
fu_imm.give_con1 = function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():GetFlagEffect(20000052)>0 end
function fu_imm.give_tg1(e,c) return fucf.Filter(c,"IsTyp+IsRac","RI+M,DR") end
function fu_imm.give_con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if fucf.IsLoc(c,"GR") and r==REASON_RITUAL and fucf.IsRac(c:GetReasonCard(),"DR") then
		c:RegisterFlagEffect(20000052,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(20000052,0))
		return true
	end
	return false
end
--------------------------------
if not self_table then return false end
local cm, m = fu_imm.initial("SH", fuef.SC(nil, EVENT_BATTLE_DAMAGE):RAN("M"):CTL(1):Func("con1,op1"))
--e1
cm.con1 = function(e,tp,eg,ep,ev,re,r,rp) return ep~=tp end
function cm.op1(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_CARD, tp, m)
	Duel.Draw(tp,1,REASON_EFFECT) 
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"D","IsTyp+AbleTo","RI+M,H",1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=fugf.SelectFilter(tp,"D","IsTyp+AbleTo","RI+M,H")
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end