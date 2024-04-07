--无亘龙 乔西
xpcall(function() dofile("expansions/script/c20000052.lua") end,function() dofile("script/c20000052.lua") end)
local cm, m = GetID()
function cm.initial_effect(c)
	fu_imm.give(cm, "TH", fuef.F(nil, EFFECT_CHANGE_DAMAGE):PRO("PTG"):RAN("M"):TRAN(0,1):VAL("val1"))(c)
	if cm.glo then return end
	cm.glo = {0, 0}
	fuef.FC(c,EVENT_PHASE_START+PHASE_DRAW,0):OP("op3*1")(EVENT_BATTLE_DAMAGE):OP("op3*")
end
--e1
function cm.val1(e,re,dam,r,rp,rc)
	local val = dam
	if r == REASON_BATTLE and cm.glo[2-rp] > dam then val = cm.glo[2-rp] end
	return val
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #e:GetHandler():GetReasonCard():GetMaterial()>0 and fugf.GetFilter(tp,"GR","IsSet+AbleTo+IsPos","3fd0,H,FU",1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetReasonCard():GetMaterial()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g=fugf.SelectFilter(tp,"GR","IsSet+AbleTo+IsPos+GChk","3fd0,H,FU",nil,1,#g)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
--e3
function cm.op3(chk)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if fusf.NotNil(chk) then 
			cm.glo = {0, 0}
		else 
			cm.glo[ep+1] = ev > cm.glo[ep+1] and ev or cm.glo[ep+1] 
		end
	end
end