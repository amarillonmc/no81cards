local m=25000110
local cm=_G["c"..m]
cm.name="丧失记忆之城的交涉"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(cm.tdcon)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_TO_HAND)
		ge3:SetOperation(cm.seteg)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	cm.chain=true
end
function cm.seteg(e,tp,eg,ep,ev,re,r,rp)
	if cm.chain==true then
		local g=Group.CreateGroup()
		if cm[0] then g=cm[0] end
		g:Merge(eg)
		g:KeepAlive()
		cm[0]=g
	end
	if cm.chain==false then
		Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm.chain=false
	if not cm[0] then return end
	Duel.RaiseEvent(cm[0],EVENT_CUSTOM+m,re,r,rp,ep,ev)
	cm[0]=nil
end
function cm.thfilter1(c,tp)
	return c:GetType()==TYPE_SPELL and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.thfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.tdfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_DECK)
	local g=g1:Filter(Card.IsAbleToDeck,nil)
	local t1=false
	local t2=false
	local tc=g1:GetFirst()
	while tc do
		if tc:IsControler(tp) then t1=true else t2=true end
		tc=g1:GetNext()
	end
	local b1=t1 and Duel.IsPlayerCanDraw(tp,1)
	local b2=t2 and Duel.IsPlayerCanDraw(1-tp,1)
	local res=false
	if b1 or b2 then res=true end
	if t1 and t2 and (not b1 or not b2) then res=false end
	if chk==0 then return g:GetCount()>0 and res end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),nil,0)
	if t1 and not t2 then Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) elseif not t1 and t2 then Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1) else Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.tdfilter,nil,tp)
	if g:GetCount()>0 and Duel.SendtoDeck(g,nil,1,REASON_EFFECT)~=0 then
		local ex,g,gc,dp,dv=Duel.GetOperationInfo(0,CATEGORY_DRAW)
		if dp~=PLAYER_ALL then Duel.Draw(dp,1,REASON_EFFECT)
		else
			Duel.Draw(tp,1,REASON_EFFECT)
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end
