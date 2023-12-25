--虚数转生
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	fuef.A(c)
	fuef.FTO(c,c,"m,TH,TH+GA,DE,S,m,,,tg1,op1")
	if cm.glo then return end
	cm.glo = fuef.FC(c,0,"SP,,,,,,op2")(EVENT_LEAVE_FIELD_P,0,"OP:op3")
end
--e1
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g,b = Group.CreateGroup()
	for c in aux.Next(eg) do
		b = true
		for tc in aux.Next(c:GetMaterial()) do
			if b then b = fucf.Filter(tc,"IsLoc+IsRea+AbleTo","GR,RI+MAT,H") and tc:GetReasonCard() == c end
		end
		if b and chk==0 then return 1 end
	end
	if chk==0 then return false end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g,b = Group.CreateGroup()
	for c in aux.Next(eg) do
		b = true
		for tc in aux.Next(c:GetMaterial()) do
			if b then b = fucf.Filter(tc,"IsLoc+IsRea+AbleTo+GChk","GR,RI+MAT,H") and tc:GetReasonCard() == c end
		end
		if b then g = g + c end
	end
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	g = (#g==1 and g or g:Select(tp,1,1,nil)):GetFirst():GetMaterial()
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
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