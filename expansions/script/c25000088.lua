--雪之圆舞曲
local m=25000088
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.handcon)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function cm.handcon(e)
	return Duel.GetTurnPlayer()==tp and Duel.GetCustomActivityCount(m,1-e:GetHandlerPlayer(),ACTIVITY_CHAIN)~=0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetDecktopGroup(tp,8)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and dg:GetCount()==8 and Duel.IsPlayerCanDraw(tp,3) end
	local ect=Duel.GetChainInfo(ev,CHAININFO_CHAIN_COUNT)
	if Duel.GetFlagEffect(tp,m)==0 then
		Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1,ect)
		Duel.RegisterFlagEffect(1-tp,m,RESET_CHAIN,0,1,ect)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c or not aux.TRUE(c:CancelToGrave()) or Duel.SendtoDeck(c,nil,2,REASON_EFFECT)<=0 or not c:IsLocation(LOCATION_DECK) then return end
	Duel.ShuffleDeck(tp)
	Duel.ConfirmDecktop(tp,8)
	local g=Duel.GetDecktopGroup(tp,8)
	if #g<=0 then return end
	local ct=g:FilterCount(Card.IsCode,nil,m)
	Duel.BreakEffect()
	if ct==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
	elseif ct==2 then
		Duel.Draw(tp,3,REASON_EFFECT)
	elseif ct==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g3,nil,REASON_EFFECT)
	end
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(m)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local lab=Duel.GetFlagEffectLabel(tp,m)
	if not lab then return end
	local ect=Duel.GetChainInfo(ev,CHAININFO_CHAIN_COUNT)
	if ect>lab then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.rep_op)
	end
end
function cm.rep_op(e,tp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(tp,1,REASON_EFFECT)
end
