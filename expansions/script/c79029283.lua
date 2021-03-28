--企鹅战法·"点"读机
function c79029283.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029283)
	e1:SetCost(c79029283.accost)
	e1:SetOperation(c79029283.activate)
	c:RegisterEffect(e1)  
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029283.negcon)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c79029283.negtg)
	e1:SetOperation(c79029283.negop)
	c:RegisterEffect(e1)	
end
function c79029283.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)~=0 end
end
function c79029283.activate(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("无穷无尽的挑战哪，这正是咱们一直期望的不是吗，黑角？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029283,0))
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
	local count=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmCards(0,g)
	count=count+1
	local tc=g:GetFirst()
	if tc:GetCode()==ac then
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-500)
	Duel.SendtoGrave(tc,REASON_EFFECT)
	local chk=true
	while chk do
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmCards(0,g)
	count=count+1 
	local tc=g:GetFirst()
	if tc:GetCode()==ac then
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-500) 
	Duel.SendtoGrave(tc,REASON_EFFECT)
	if count==7 then return false end
	else
	chk=false
	end
  end 
end
end
function c79029283.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)~=0 and ep~=tp
end
function c79029283.cfilter(c,rtype,e)
	return c:IsType(rtype) and c:IsAbleToRemoveAsCost() and e:GetHandler():GetMaterial():IsContains(c) 
end
function c79029283.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c79029283.negop(e,tp,eg,ep,ev,re,r,rp)
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
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.ConfirmCards(0,g)
	local tc=g:GetFirst()
	if tc:GetCode()==ac then
	Debug.Message("想要老夫我做什么，请不必顾虑，尽管说。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029283,1))
	if Duel.NegateActivation(ev) then
	Duel.Destroy(eg,REASON_EFFECT)
	end
	end
end
