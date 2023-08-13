--混沌的轮回 循环
local m=30000220
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.act)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	if cm.ctcounter==nil then
		cm.ctcounter=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetOperation(cm.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
--all
function cm.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local ct1,ct2,pl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2,CHAININFO_TRIGGERING_CONTROLER)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and (ct1==30000220 or ct2==30000220) then
		cm[pl]=cm[pl]+1
	end
end
function cm.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local ct1,ct2,pl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_CODE2,CHAININFO_TRIGGERING_CONTROLER)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and (ct1==30000220 or ct2==30000220) then
		cm[pl]=cm[pl]-1
	end
end
--Effect 1
function cm.tf(c)
	local chk=c:IsType(TYPE_MONSTER)
	if c:IsLocation(LOCATION_PZONE) then
		chk=c:GetOriginalType()&TYPE_MONSTER~=0
	end
	local b1=c:IsFaceupEx()
	local b2=c:IsAbleToDeck()
	local b3=c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
	return  b1 and b2 and b3 and chk
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tf,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK) and Duel.IsPlayerCanDraw(tp,cm[tp]+2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,cm[tp]+2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function cm.act(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(cm[tp]) 
	local g=Duel.GetMatchingGroup(cm.tf,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_PZONE,0,nil)
	if not g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK)
	local hg=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #hg>0 then Duel.ConfirmCards(1-tp,hg) end
	Duel.HintSelection(tg-hg)
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)==0 then return false end
	local og=Duel.GetOperatedGroup()
	local gt=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if gt==0 then return false end
	Duel.Draw(tp,cm[tp]+2,REASON_EFFECT)
end
--Effect 2
function cm.df(c,e)
	local b1=c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
	local b2=c:IsFaceupEx()
	local b3=c:IsAbleToDeck()
	return b1 and b2 and b3 and c:IsCanBeEffectTarget(e)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ec=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.df(chkc,e) end
	local g=Duel.GetMatchingGroup(cm.df,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if chk==0 then return ec:IsAbleToDeck() and #g>=2 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,2,2,nil)
	Duel.SetTargetCard(sg)
	local tg=sg:Clone()
	tg:AddCard(ec)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #tg>0 and ec:IsRelateToEffect(e) then 
		local ttg=tg:Clone()
		ttg:AddCard(ec)
		Duel.SendtoDeck(ttg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end