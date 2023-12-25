--无亘皇帝之跃升
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000050)
	aux.AddRitualProcGreater2(c,aux.FilterBoolFunction(Card.IsCode,20000050),nil,aux.TRUE,nil,nil,cm.opr)
	fuef.FTO(c,c,"SP,,TH+GA,,G,m,con1,,tg1,op1")
end
--r
function cm.opr(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	local atk = 0
	for c in aux.Next(mat) do
		atk = atk + c:GetBaseAttack()
	end
	atk = math.floor(atk/2) + tc:GetBaseAttack()
	fuef.S(e,tc,EFFECT_SET_BASE_ATTACK,",IG,,"..(atk)..",,,,EV+STD")
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return fugf.Filter(eg,"IsSTyp","RI",1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return fugf.GetFilter(tp,"G","IsTyp+AbleTo+Not",{"RI+S,H",e},1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)

	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		local g=fugf.GetFilter(tp,"G","IsTyp+AbleTo+GChk","RI+M,H")
		if #g>0 and Duel.SelectYesNo(tp,1190) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			g=g:Select(tp,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
