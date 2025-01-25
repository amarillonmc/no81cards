--lavafissure of dragon palace
--21.12.25
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.hand)
	e2:SetDescription(aux.Stringid(m,3))
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(cm.condition)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetCondition(cm.clearcon)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_CHAIN_NEGATED)
		ge4:SetCondition(cm.rscon)
		ge4:SetOperation(cm.reset)
		Duel.RegisterEffect(ge4,0)
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local tf=re:GetHandler():IsRelateToEffect(re)
	local cid=re:GetHandler():GetRealFieldID()
	cm[ev]={re,tf,cid}
	re:GetHandler():RegisterFlagEffect(m+2,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm[ev]={re,false,0}
	re:GetHandler():ResetFlagEffect(m+2)
end
function cm.clearcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	local i=1
	while cm[i] do
		cm[i]=nil
		i=i+1
	end
end
function cm.filter(c,lv)
	return c:IsSetCard(0x6978) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(lv) and c:GetLevel()%2==0
end
function cm.hand(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT)
	return te and te:GetHandler():IsSetCard(0x6978)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Group.CreateGroup()
		for i=1,Duel.GetCurrentChain() do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(te) and (tc:IsReleasableByEffect() or (tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL+TYPE_TRAP) and not tc:IsHasEffect(EFFECT_UNRELEASABLE_EFFECT) and not tc:IsHasEffect(EFFECT_UNRELEASABLE_NONSUM) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE))) then g:AddCard(tc) end
		end
		return #g>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,#g*2)
	end
	local g=Group.CreateGroup()
	for i=1,Duel.GetCurrentChain() do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc:IsRelateToEffect(te) and (tc:IsReleasableByEffect() or (tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL+TYPE_TRAP) and not tc:IsHasEffect(EFFECT_UNRELEASABLE_EFFECT) and not tc:IsHasEffect(EFFECT_UNRELEASABLE_NONSUM) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE))) then g:AddCard(tc) end
	end
	local hg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,#g*2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,hg,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local i=1
	while type(cm[i])=="table" do
		local te,tf,cid=table.unpack(cm[i])
		local tc=te:GetHandler()
		if ((i<=Duel.GetCurrentChain() and tc:IsRelateToEffect(te)) or (i>Duel.GetCurrentChain() and tf and tc:GetFlagEffect(m+2)>0)) and (tc:IsReleasableByEffect() or (tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL+TYPE_TRAP) and not tc:IsHasEffect(EFFECT_UNRELEASABLE_EFFECT) and not tc:IsHasEffect(EFFECT_UNRELEASABLE_NONSUM) and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE))) then g:AddCard(tc) end
		i=i+1
	end
	local hg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,#g*2)
	if #hg>0 then
		local lvt={}
		for i=1,#g do
			if hg:IsExists(Card.IsLevel,1,nil,i*2) then table.insert(lvt,i) end
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local ct=Duel.AnnounceNumber(tp,table.unpack(lvt))
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg=g:Select(tp,ct,ct,nil)
			local rct=Duel.Release(rg,REASON_EFFECT)
			if rct>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tg=hg:FilterSelect(tp,Card.IsLevel,1,1,nil,rct*2)
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
		end
	end
end
function cm.cfilter(c,tp)
	return c:GetType()&0x82==0x82 and c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
end
function cm.thfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsAbleToHand()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(cm.cfilter,nil,tp)
	local tg=g:Filter(Card.IsAbleToHand,nil)
	if chk==0 then return c:IsAbleToDeck() and #tg>0 and c:GetFlagEffect(m+1)==0 end
	c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=eg:FilterSelect(tp,cm.thfilter,1,1,nil,e)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end