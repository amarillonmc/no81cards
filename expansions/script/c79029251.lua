--个人行动-威塞克斯的信件
function c79029251.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029251)
	e1:SetCost(c79029251.accost)
	e1:SetOperation(c79029251.activate)
	c:RegisterEffect(e1)   
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,7951)
	e2:SetTarget(c79029251.drtg)
	e2:SetOperation(c79029251.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c79029251.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)~=0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(g) do
		local code=c:GetCode()
		if not ag:IsExists(Card.IsCode,1,nil,code) then
			ag:AddCard(c)
			table.insert(codes,code)
		end
	end
	table.sort(codes)
	--c:IsCode(codes[1])
	local afilter={codes[1],OPCODE_ISCODE}
	if #codes>1 then
		--or ... or c:IsCode(codes[i])
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}   
	e:SetLabel(ac)
end
function c79029251.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmCards(0,g)
	if g:GetFirst():GetCode()==ac then
	local op=0
	if Duel.GetFlagEffect(tp,79029251)==0 then
	op=Duel.SelectOption(tp,aux.Stringid(79029251,0),aux.Stringid(79029251,1))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029251,0))
	end
	if op==0 then
	local tc=Duel.CreateToken(tp,79029081)
	Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,79029251,0,0,0)
	else
	Duel.SendtoHand(g:GetFirst(),tp,REASON_EFFECT) 
	Duel.ConfirmCards(0,g:GetFirst())
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)~=0 and Duel.SelectYesNo(tp,aux.Stringid(79029251,2)) then
	local cc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SendtoHand(cc,tp,REASON_EFFECT)
	Duel.ConfirmCards(0,cc)
	end
	end 
	end   
end
function c79029251.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and e:GetHandler():IsPreviousLocation(LOCATION_HAND) and e:GetHandler():GetReasonPlayer()~=tp end
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5-ht)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5-ht)
end
function c79029251.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ht=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ht<5 then
		local x=Duel.Draw(p,5-ht,REASON_EFFECT)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-x*700)
	end
end
end





