--幻梦龙 无限
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm = self_table
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.AddCodeList(c,20000059)
	fuef.I(c,c,"SH,SH,,P,m,,cos2,tg2,op2")(nil,c,",,,E,,,bfgcost,tg1,op1")
end
--e1
function cm.tgf1(c)
	return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack())
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and fugf.GetFilter(tp,"M+M",cm.tgf1,nil,1) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g = fugf.GetFilter(tp,"M+M",cm.tgf1)
	for tc in aux.Next(fugf.GetFilter(tp,"M+M",cm.tgf1)) do
		local atk = tc:GetAttack()
		fuef.S(e,tc,EFFECT_SET_BASE_ATTACK,",,"..atk..",,,EV+STD")
		atk = tc:GetBaseAttack()
		fuef.S(e,tc,EFFECT_SET_ATTACK_FINAL,",,"..atk..",,,EV+STD")
	end
end
--e2
function cm.cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"H","IsDiscardable",nil,1) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"D","IsCod+AbleTo","59,H",1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=fugf.SelectFilter(tp,"D","IsCod+AbleTo","59,H")
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end