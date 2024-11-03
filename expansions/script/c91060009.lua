--白银之城的喵茶杯
local m=91060009
local cm=c91060009
function c91060009.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.stcost)
	e1:SetTarget(cm.sttg)
	e1:SetOperation(cm.stop)
	c:RegisterEffect(e1)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.drcon)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
end
function cm.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.stfilter(c)
	return c:IsSetCard(0x17e) and c:IsAbleToGrave()
end
function cm.stfilter1(c)
	return c:IsSetCard(0x17e) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,nil)end
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.stfilter,tp,LOCATION_REMOVED+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.stfilter1),tp,LOCATION_GRAVE,0,1,nil) then 
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.stfilter1),tp,LOCATION_GRAVE,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SSet(tp,g2:GetFirst())
	end
	end end end
end
function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re and rp==tp and re:IsActiveType(TYPE_TRAP) and re:GetHandler():GetOriginalType()==TYPE_TRAP
		and eg:IsExists(cm.cfilter,1,nil)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spfilter2(c,e,tp)
	return c:IsCode(33407125)   and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.spfilter3(c,e,tp)
	return c:IsSetCard(0x17e) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)		
		if #sg>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if tc then Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) end				
		end
	end
end
end
end