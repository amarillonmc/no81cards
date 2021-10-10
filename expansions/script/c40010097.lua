--超越了悠久的少女们
local m=40010097
local cm=_G["c"..m]
function cm.initial_effect(c)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.handcon)
	c:RegisterEffect(e3) 
	--copy spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetHintTiming(TIMING_MAIN_END)
	e1:SetCost(cm.cpcost)
	e1:SetTarget(cm.cptg)
	e1:SetOperation(cm.cpop)
	c:RegisterEffect(e1)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)  
	--normal monster
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EFFECT_ADD_TYPE)
	e5:SetCondition(cm.nmcon)
	e5:SetValue(TYPE_NORMAL+TYPE_MONSTER)
	c:RegisterEffect(e1)
	
end
function cm.handfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x4f1d) and c:IsType(TYPE_SYNCHRO))
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.handfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) or Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function cm.nmcon(e)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.cpfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4f1d) and c:IsAbleToGraveAsCost()
end
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.filter2(c)
	return c:GetType(TYPE_COUNTER) and c:IsSetCard(0x4f1d) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.cpfilter1,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.cpfilter1,tp,LOCATION_HAND,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g2:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g1,REASON_COST)
	Duel.SendtoGrave(g2,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
end






function cm.tdfilter(c)
	return c:IsSetCard(0x4f1d) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==0 then return end
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

