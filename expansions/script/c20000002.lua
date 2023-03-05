--俯瞰苍界之鸦
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c20000000") end) then require("script/c20000000") end
fu_kurusu = fu_kurusu or {}
local FK=fu_kurusu
function FK.A(c,code,cat,tg,op)
	aux.AddCodeList(c,20000001)
	local e1=fucg.ef.A(c,0,cat|CATEGORY_TOHAND,nil,"TG","O",FK.A_con1,nil,tg,op,c)
	local e2=fucg.ef.A(c,"TH","SH","FC",nil,"O",nil,FK.A_cos2,FK.A_tg2,FK.A_op2,c)
	return e1,e2
end
function FK.RH(e,tp,eg,ep,ev,re,r,rp)
	local res={RESET_PHASE+PHASE_STANDBY,Duel.GetCurrentPhase()<=PHASE_STANDBY and 2 or 1}
	fucg.ef.FC(e,0,EVENT_PHASE+PHASE_STANDBY,nil,nil,1,FK.RH_con,FK.RH_op,tp,res,Duel.GetTurnCount())
end
function FK.A_con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,20000002)>0
end
function FK.A_cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=fucg.gf.GGF(tp,"G",0,{Card.IsType,Card.IsAbleToRemoveAsCost},TYPE_SPELL)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g=g:Select(tp,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function FK.A_tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fucg.gf.GGF(tp,"D",0,{Card.IsCode,Card.IsAbleToHand},20000001,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function FK.A_op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=fucg.gf.GGF(tp,"D",0,{Card.IsCode,Card.IsAbleToHand},20000001):Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function FK.RH_f(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function FK.RH_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and fucg.gf.GGF(tp,"G",0,FK.RH_f,nil,1)
end
function FK.RH_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=fucg.gf.GGF(tp,"G",0,aux.NecroValleyFilter(FK.RH_conf)):Select(tp,1,1,nil):GetFirst()
	if tc then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end
if not cm then return end
--------------------------------------------------------
function cm.initial_effect(c)
	local e1,e2=FK.A(c,m,CATEGORY_TOHAND,cm.tg,cm.op)
end
--e1
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(16) and FK.RH_f(chkc) end
	if chk==0 then return Duel.IsExistingTarget(FK.RH_f,tp,16,16,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,FK.RH_f,tp,16,16,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,16)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and Duel.SendtoHand(tc,tp,REASON_EFFECT)>0 then FK.RH(e,tp,eg,ep,ev,re,r,rp) end
end