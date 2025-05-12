--悬丝协律·盛装开幕
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	--spsummon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1101)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1101)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.destg2)
	e2:SetOperation(s.desop2)
	c:RegisterEffect(e2)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetTargetPlayer(tp)
end
function s.desfilter(c)
	return c:IsSetCard(0x5a7d) and c:IsType(TYPE_MONSTER)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	local tg=g:Filter(s.desfilter,nil)
	if #tg>0 and Duel.SelectYesNo(p,aux.Stringid(id,2)) then
		local ct=tg:GetClassCount(Card.GetCode)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
		local sg=tg:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		Duel.Destroy(sg,REASON_EFFECT)
	end
	Duel.ShuffleDeck(p)
end
function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	Duel.SetTargetPlayer(tp)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	local tg=g:Filter(s.desfilter,nil)
	if #tg>0 and Duel.SelectYesNo(p,aux.Stringid(id,2)) then
		local ct=tg:GetClassCount(Card.GetCode)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
		local sg=tg:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		Duel.Destroy(sg,REASON_EFFECT)
	end
	Duel.ShuffleDeck(p)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(1193)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(s.retcon)
	e1:SetOperation(s.retop)
	Duel.RegisterEffect(e1,tp)
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.IsExistingMatchingCard(s.akfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function s.retfilter(c)
	return c:IsSetCard(0x5a7d) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.akfilter(c)
	return c:IsCode(id) and c:IsAbleToHand() and c:IsFaceupEx()
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then 
		Duel.Hint(HINT_CARD,0,id)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		if #g1>0 and Duel.Destroy(g1,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.akfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
			if #g2>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
	   	end
	end
end