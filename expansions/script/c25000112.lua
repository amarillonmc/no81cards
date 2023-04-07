local m=25000112
local cm=_G["c"..m]
cm.name="真实的记忆"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.thfilter(c)
	return c:IsCode(25000106,25000109) and c:IsAbleToHand()
end
function cm.fzfilter(c)
	return c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local og=Group.CreateGroup()
	if #g>0 then
		if #g>6 then
			local cg=Duel.GetDecktopGroup(tp,#g-6)
			og=Group.__sub(g,cg)
		else og=g end
	end
	local b1=#og>0 and og:IsExists(Card.IsAbleToHand,1,nil) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_SPELL)
	local b2=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(cm.fzfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) then
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,3))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,TYPE_SPELL)
		Duel.SetTargetParam(ac)
		Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if op~=1 and #g>0 then
		local ct=math.min(6,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
		local t={}
		for i=1,ct do t[i]=i end
		local ac=1
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			ac=Duel.AnnounceNumber(tp,table.unpack(t))
		end
		for i=1,ac do
			local dc=Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence):GetFirst()
			Duel.MoveSequence(dc,0)
		end
		Duel.ConfirmDecktop(tp,ac)
		local og=Duel.GetDecktopGroup(tp,ac)
		local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sc=og:FilterSelect(tp,Card.IsCode,1,1,nil,code):GetFirst()
		if sc then
			if sc:IsAbleToHand() then
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
				Duel.ShuffleHand(tp)
			else Duel.SendtoGrave(sc,REASON_RULE) end
		end
		local dct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if dct>0 then
			Duel.SortDecktop(tp,tp,dct)
			for i=1,dct do
				local dg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(dg:GetFirst(),1)
			end
		end
	end
	if op~=0 then
		if op==2 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			Duel.ShuffleDeck(tp)
		end
	end
end
