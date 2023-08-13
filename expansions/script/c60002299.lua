if not pcall(function() require("expansions/script/c60002290") end) then require("script/c60002290") end
local cm,m=lanp.U("设置卡","黄昏","黄昏圣堂")
function cm.initial_effect(c)
	local e1=lane.B_A(c,c,{m,0},",FC,","O",cm.con,"",cm.tg,cm.op)
	local e2=lane.FTO(c,c,{m,1},"TD,SP,DE+CAL+DAM,G,",cm.con1,"",cm.tg1,cm.op1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.tg(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return #dusk.begin~=0 and cm.check(dusk.begin)~=0 and Duel.IsPlayerCanDraw(cm.check(dusk.begin)) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=cm.check(dusk.begin)
	if ct==0 then return false end
	for i=1,#dusk.begin do
		local re=dusk.begin[i][1]
		if aux.GetValueType(re) == "Effect" then
			local op=re:GetOperation()
			if op then op(re,tp,eg,ep,ev,re,r,rp) end
		end
	end
	Duel.Draw(tp,ct,REASON_EFFECT)
	for i=1,#dusk.begin do
		 table.remove(dusk.begin)
	end
end
function cm.check(tab)
	local ct=0
	for i=1,#tab do
		if aux.GetValueType(tab[i][1]) == "Effect" then ct=ct+1 end
	end
	return ct
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return lang.Filter(eg,"IsSummonPlayer+IsSummonType",{tp,0x4a000000},1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return lanc.Filter(c,"IsSSetable",false) end
end
function cm.op1(e,tp,eg,ep,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if Duel.SSet(tp,c)>0 and lang.GetFilter(tp,"G","IsName","黄昏圣堂",1) then
		local g=lang.GetFilter(tp,"G","IsName","黄昏圣堂")
		if #g~=0 then
			lanp.U("效果处理",Duel.SendtoDeck,g,{nil,2,"EFF"})
		end
	end
end