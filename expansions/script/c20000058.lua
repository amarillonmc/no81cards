--虚数转生
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	fuef.A(c)
	fuef.FTO(c,"CUS+m"):CAT("TD+DR+TH+GA"):PRO("DAM+CAL+DE"):RAN("S"):CTL(m):Func("tg1,op1")
	if cm.glo then return end
	cm.glo = fuef.FC(c,"SP",0):OP("op2")(EVENT_LEAVE_FIELD_P):OP("op3")
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	for c in aux.Next(eg) do
		local g, b = Group.CreateGroup(), true
		for tc in aux.Next(c:GetMaterial()) do
			if b then 
				b = (fucf.Filter(tc,"IsLoc+IsRea+AbleTo","GR,RI+MAT,D") and tc:GetReasonCard() == c) 
				g = g + tc
			end
		end
		if b and #c:GetMaterial() > 0 and chk == 0 then
			local b3 = c:GetMaterial():GetSum(Card.GetAttack) > 0 and fugf.GetFilter(tp, "M", "IsRac+IsPos","DR,FU",1)
			return Duel.IsPlayerCanDraw(tp) or fugf.GetFilter(tp,"G","AbleTo+Not",{"H",g},1) or b3
		end
	end
	if chk==0 then return false end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g = Group.CreateGroup()
	for c in aux.Next(eg) do
		local b = true
		for tc in aux.Next(c:GetMaterial()) do
			if b then 
				b = (fucf.Filter(tc,"IsLoc+IsRea+AbleTo","GR,RI+MAT,D") and tc:GetReasonCard() == c) 
			end
		end
		if b and #c:GetMaterial() > 0 then
			g = g + c
		end
	end
	if #g == 0 then return end
	if #g > 1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		g = g:Select(tp,1,1,nil)
		Duel.HintSelection(g)
	end
	g = g:GetFirst():GetMaterial()
	Duel.HintSelection(g)
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT) == 0 then return end
	g = Duel.GetOperatedGroup()
	if fugf.Filter(g,"IsLoc","D",1) then Duel.ShuffleDeck(tp) end
	local ct = #fugf.Filter(g,"IsLoc","DE")
	local b1 = Duel.IsPlayerCanDraw(tp,ct) and aux.Stringid(m,0)
	local b2 = fugf.GetFilter(tp,"G","AbleTo+GChk","H",1) and 1190
	local b3 = g:GetSum(Card.GetAttack) > 0 and fugf.GetFilter(tp, "M", "IsRac+IsPos","DR,FU",1) and aux.Stringid(m,1)
	if not (b1 or b2 or b3) then return end 
	Duel.BreakEffect()
	local op,n = {},0
	for _,b in ipairs({b1,b2,b3}) do
		op[#op + 1], n = b, n + 1
	end
	local op = Duel.SelectOption(tp,table.unpack(op)) + n
	if op == 0 then
		Duel.Draw(tp,ct,REASON_EFFECT)
	elseif op == 1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		g = fugf.SelectFilter(tp,"G","IsSet+AbleTo+GChk","bfd0,H",nil,1,ct)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		local atk = math.floor(g:GetSum(Card.GetAttack)/2)
		g = fugf.GetFilter(tp, "M", "IsRac+IsPos-IsImm", {"DR,FU", e})
		fuef.S(e,EFFECT_UPDATE_ATTACK,g):VAL(atk):RES("EV+STD")
	end
end
--e2
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	for c in aux.Next(fugf.Filter(eg,"IsSTyp","RI")) do
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
--e3
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g = Group.CreateGroup()
	for c in aux.Next(eg) do
		if c:GetFlagEffect(m)>0 then g = g + c end
	end
	if #g>0 then Duel.RaiseEvent(g,EVENT_CUSTOM+m,re,r,rp,ep,ev) end
end