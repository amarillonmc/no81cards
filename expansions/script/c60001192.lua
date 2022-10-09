--紫罗兰之恋
local m=60001192
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,60001179)
	--code
	aux.EnableChangeCode(c,60001179,LOCATION_MZONE)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(cm.mtop)
	c:RegisterEffect(e4)
end
function cm.tdfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and aux.IsCodeListed(c,60001179) and not c:IsCode(m) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		local sg=Duel.GetMatchingGroup(cm.stfilter,tp,LOCATION_DECK,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ct>0 and Duel.IsExistingMatchingCard(cm.demfilter,tp,LOCATION_MZONE,0,1,nil)
			and sg:GetClassCount(Card.GetCode)>=ct and ft>=ct
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local stg=sg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
			Duel.SSet(tp,stg)
		end
	end
end
function cm.demfilter(c)
	return c:IsCode(60001179) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.stfilter(c)
	return c:GetType()==TYPE_TRAP and not aux.IsCodeListed(c,60001179) and c:IsSSetable()
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Destroy(e:GetHandler(),REASON_COST)
end