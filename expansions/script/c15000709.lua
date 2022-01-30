local m=15000709
local cm=_G["c"..m]
cm.name="盖理的远客·沙利叶&伊诺兹"
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(cm.retcon)
	e1:SetCost(cm.retcost)
	e1:SetTarget(cm.rettg)
	e1:SetOperation(cm.retop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.efcon)
	e2:SetTarget(cm.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function cm.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount() and g:IsExists(Card.IsLinkSetCard,1,nil,0x3f38)
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,15000709)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000709)} do
			if i==c:GetOriginalCodeRule() then return false end
		end
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	while tc do
		if Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,tc,tc:GetRace()) then return false end
		tc=g:GetNext()
	end
	return true
end
function cm.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.RegisterFlagEffect(tp,15000709,RESET_PHASE+PHASE_END,0,1,c:GetOriginalCodeRule())
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.regop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.swfilter(c)
	return c:IsSetCard(0x3f38) and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingTarget(cm.swfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.swfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local ag=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local ac=ag:GetFirst()
	while ac do
		if Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,ac,ac:GetRace()) then return end
		ac=ag:GetNext()
	end
	local tc=Duel.GetFirstTarget()
	local b1=tc:IsAbleToHand()
	local b2=tc:IsAbleToDeck()
	if not (b1 or b2) then return end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,2))
	else op=Duel.SelectOption(tp,aux.Stringid(m,3))+1 end
	if op==0 then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
			local tg=Duel.GetOperatedGroup()
			tg=tg:Filter(Card.IsLocation,nil,LOCATION_DECK)
			tg=tg:Filter(Card.IsControler,nil,tp)
			if tg:GetCount()~=0 then
				Duel.BreakEffect()
				Duel.ShuffleDeck(tp)
				Duel.Draw(tp,tg:GetCount(),REASON_EFFECT)
			end
		end
	end
	if op==1 then
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
			local tg=Duel.GetOperatedGroup()
			tg=tg:Filter(Card.IsLocation,nil,LOCATION_DECK)
			tg=tg:Filter(Card.IsControler,nil,tp)
			if tg:GetCount()~=0 then
				Duel.BreakEffect()
				Duel.ShuffleDeck(tp)
				Duel.Draw(tp,tg:GetCount(),REASON_EFFECT)
			end
		end
	end
end
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.eftg(e,c)
	return c:IsSetCard(0x3f38) and c:IsType(TYPE_MONSTER)
end