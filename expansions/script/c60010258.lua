--飓风客
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010252)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(cm.condition3)
	e2:SetOperation(cm.activate3)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetOperation(cm.bkop)
	c:RegisterEffect(e3)
end
function cm.fil1(c)
	return c:IsCode(60010252) and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnCount()<3
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnCount()>=3
end
function cm.fil2(c)
	return c:IsType(TYPE_SPELL) and (c:IsType(TYPE_CONTINUOUS) or c:GetType()==TYPE_SPELL) and c:IsAbleToHand()
end
function cm.fil3(c)
	return aux.IsCodeListed(c,60010252) and c:IsAbleToHand() and not c:IsCode(m) and not Duel.IsExistingMatchingCard(cm.checkfil,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function cm.checkfil(c,code)
	return c:IsCode(code) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup()))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local check={}
	local num={}
	check[1]=true
	check[2]=true
	if Duel.IsPlayerCanDraw(tp,1) then check[3]=true else check[3]=false end
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then
	check[4]=true else check[4]=false end
	if Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_GRAVE,0,1,nil) then check[5]=true else check[5]=false end
	if Duel.IsExistingMatchingCard(cm.fil3,tp,LOCATION_DECK,0,1,nil) then check[6]=true else check[6]=false end
	for i=1,6 do num[i]=0 end
	local op1=aux.SelectFromOptions(tp,{check[1],aux.Stringid(m,0)},{check[2],aux.Stringid(m,1)},{check[3],aux.Stringid(m,2)},{check[4],aux.Stringid(m,3)},{check[5],aux.Stringid(m,4)},{check[6],aux.Stringid(m,5)})
	check[op1]=false
	local op2=aux.SelectFromOptions(tp,{check[1],aux.Stringid(m,0)},{check[2],aux.Stringid(m,1)},{check[3],aux.Stringid(m,2)},{check[4],aux.Stringid(m,3)},{check[5],aux.Stringid(m,4)},{check[6],aux.Stringid(m,5)})
	num[op1]=1
	num[op2]=1
	if num[1]==1 then
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
	if num[2]==1 then
		Duel.Recover(tp,1200,REASON_EFFECT)
	end
	if num[3]==1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if num[4]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()):Select(tp,1,1,nil)
		if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	end
	if num[5]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.fil2,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			local cg=Duel.GetOperatedGroup()
			if #cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
				local max=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),#cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local pg=cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS):Select(tp,1,max,nil)
				for tc in aux.Next(pg) do
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			end
		end
	end
	if num[6]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.fil3,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			local cg=Duel.GetOperatedGroup()
			if #cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
				local max=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),#cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local pg=cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS):Select(tp,1,max,nil)
				for tc in aux.Next(pg) do
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			end
		end
	end
end

function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,800,REASON_EFFECT)
	Duel.Damage(1-tp,800,REASON_EFFECT)
	Duel.Recover(tp,1200,REASON_EFFECT)
	Duel.Recover(tp,1200,REASON_EFFECT)
	if Duel.IsPlayerCanDraw(tp,1) then Duel.Draw(tp,1,REASON_EFFECT) end
	if Duel.IsPlayerCanDraw(tp,1) then Duel.Draw(tp,1,REASON_EFFECT) end
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()):Select(tp,1,1,nil)
		if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	end
	if Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()):Select(tp,1,1,nil)
		if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
	end
	if Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.fil2,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			local cg=Duel.GetOperatedGroup()
			if #cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
				local max=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),#cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local pg=cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS):Select(tp,1,max,nil)
				for tc in aux.Next(pg) do
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			end
		end
	end
	if Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.fil2,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			local cg=Duel.GetOperatedGroup()
			if #cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
				local max=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),#cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local pg=cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS):Select(tp,1,max,nil)
				for tc in aux.Next(pg) do
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			end
		end
	end
	if Duel.IsExistingMatchingCard(cm.fil3,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.fil3,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			local cg=Duel.GetOperatedGroup()
			if #cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
				local max=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),#cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local pg=cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS):Select(tp,1,max,nil)
				for tc in aux.Next(pg) do
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			end
		end
	end
	if Duel.IsExistingMatchingCard(cm.fil3,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.fil3,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			local cg=Duel.GetOperatedGroup()
			if #cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
				local max=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),#cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS))
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local pg=cg:Filter(Card.IsType,nil,TYPE_CONTINUOUS):Select(tp,1,max,nil)
				for tc in aux.Next(pg) do
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			end
		end
	end
end
function cm.fil4(c)
	return c:IsRace(RACE_ILLUSION) and c:IsFaceup()
end
function cm.bkop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(cm.fil4,tp,LOCATION_MZONE,0,nil)
		for c in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(300)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e2)
		end
	end
end

