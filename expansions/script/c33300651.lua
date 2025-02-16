--幽域诞地机关 烈焰火轮
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CUSTOM+id)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCost(s.damcost)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
	aux.RegisterMergedDelayedEvent(c,id,EVENT_SPSUMMON_SUCCESS)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.settg)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)
end
function s.cfilter(c)
	return c:IsFaceupEx() and (bit.band(c:GetType(),0x20004)==0x20004 or c:IsSetCard(0xa569)) and c:IsAbleToGraveAsCost()
end
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tgfilter(c,tp,e)
	return c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(s.tgfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain():Filter(Card.IsType,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		local dam=Duel.SendtoGrave(g,REASON_EFFECT)
		if dam>0 then
			Duel.Damage(1-tp,dam*500,REASON_EFFECT)
		end
	end
end
function s.setfilter(c)
	return c:IsFaceupEx() and bit.band(c:GetType(),0x20004)==0x20004
		and c:IsAbleToDeck()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(tp) and s.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.setfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c) and e:GetHandler():IsSSetable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end