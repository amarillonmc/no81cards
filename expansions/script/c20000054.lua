--无亘龙 杜米利奥尼
xpcall(function() dofile("expansions/script/c20000052.lua") end,function() dofile("script/c20000052.lua") end)
local cm = fu_imm.initial(self_table,"SH","FC",EVENT_CHAIN_SOLVED,",,M,,con1,op1")
--e1
cm.con1 = function(e,tp,eg,ep,ev,re,r,rp)return re and re:GetHandler()==e:GetHandler()end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	for c in aux.Next(fugf.GetFilter(tp,"M","IsTyp+IsRac+IsPos","RI+M,DR,FU")) do
		fuef.S(e,c,EFFECT_UPDATE_ATTACK,",,M,250,,,,EV+STD")
	end
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler():GetReasonCard()
	if chk==0 then return fugf.Filter(c:GetMaterial(),"IsRLv",{"+1",c},1) and fugf.GetFilter(tp,"D","IsSet+AbleTo","3fd0,H",1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetReasonCard()
	local g=fugf.Filter(c:GetMaterial(),"IsRLv",{"+1",c})
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g=fugf.SelectFilter(tp,"D","IsSet+AbleTo","3fd0,H",nil,1,#g)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end