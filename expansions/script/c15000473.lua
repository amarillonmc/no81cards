local m=15000473
local cm=_G["c"..m]
cm.name="星拟龙·零时之默迦尔 LV10"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000472)
	c:EnableReviveLimit()
	--cannot special Summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end
cm.lvdn={15000472}
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.filter(c,lv)
	return (c:IsSetCard(0x3f34) or c:IsSetCard(0x41)) and c:GetLevel()<lv and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetLevel()):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.tdfilter(c)
	return c:IsSetCard(0x3f34) and c:IsAbleToDeck()
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		local x=Duel.Destroy(eg,REASON_EFFECT)
		if x==0 then return end
		Duel.BreakEffect()
		local fg=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE,0,nil)
		local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x3f34)
		local x=g:GetClassCount(Card.GetCode)
		if x>=3 and fg:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local qg=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,99,nil)
			if Duel.SendtoDeck(qg,nil,2,REASON_EFFECT)~=0 then
				local tc=eg:GetFirst()
				while tc do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
					e1:SetTarget(cm.dis2tg)
					e1:SetLabelObject(tc)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_CHAIN_SOLVING)
					e2:SetCondition(cm.dis2con)
					e2:SetOperation(cm.dis2op)
					e2:SetLabelObject(tc)
					e2:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e2,tp)
					tc=eg:GetNext()
				end
			end
		end
	end
end
function cm.dis2tg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.dis2con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function cm.dis2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end