--光型镜·万镜宝鉴
local m=11630220
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0) 
	 --activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(cm.filter)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.descon)
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DRAW)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
cm.SetCard_xxj_Mirror=true
function cm.filter(e,c)
	return c.SetCard_xxj_Mirror
end
function cm.actfilter(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(11630218)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()~=tp
end
--
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function cm.thfilter(c)
	return c.SetCard_xxj_Mirror and  c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:GetCount()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return  g:GetClassCount(Card.GetCode)>=ct and Duel.GetFlagEffect(tp,m)==0 end --and Duel.GetFlagEffect(tp,m)==0
	--Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	--if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0)) then return false end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0)) then return end
	local c=e:GetHandler()
	local ct=eg:GetCount()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if g:GetCount()<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,ct,ct,nil)
	local tdct=Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	--Duel.SortDecktop(tp,tp,ct)
	--for i=1,ct do
		--local mg=Duel.GetDecktopGroup(p,1)
		--Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
	--end
	local tg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if tdct<=0 or tg:GetClassCount(Card.GetCode)<tdct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=tg:SelectSubGroup(tp,aux.dncheck,false,tdct,tdct)
	local tc=hg:GetFirst()
	while tc do
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)   
		local code=tc:GetCode()
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_CANNOT_TO_HAND)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetTargetRange(1,0)
		e0:SetTarget(cm.thlimit)
		e0:SetLabel(code)
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
		tc=hg:GetNext()
	end
end

function cm.thlimit(e,c,tp,re)
	return c:IsCode(e:GetLabel()) and re and re:GetHandler():IsCode(m)
end
