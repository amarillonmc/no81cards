--无亘风暴
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	fuef.B_A(c,c,",,TH,,,,,tg1,op1")
end
--e1
function cm.tgf1(g,atk)
	return g:IsExists(Card.IsAttackBelow,1,nil,atk)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk = 0
	for c in aux.Next(fugf.GetFilter(tp,"M","IsTyp+IsPos","RI+M,FU")) do
		atk = atk + c:GetAttack()
	end
	local g = fugf.GetFilter(tp,"M","IsPos","FU")
	if chk==0 then return g:CheckSubGroup(cm.tgf1,1,#g,atk) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.opf1(g,atk)
	for c in aux.Next(g) do
		atk = atk - c:GetAttack()
	end
	return atk>0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local atk = 0
	for c in aux.Next(fugf.GetFilter(tp,"M","IsTyp+IsPos","RI+M,FU")) do
		atk = atk + c:GetAttack()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g = fugf.GetFilter(tp,"+M","IsPos","FU"):SelectSubGroup(tp,cm.opf1,false,1,99,atk)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
