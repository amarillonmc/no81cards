--绘色的永夏 羽未
function c9910972.initial_effect(c)
	--flag
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetOperation(c9910972.flag)
	c:RegisterEffect(e0)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5954),2,2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910972)
	e1:SetTarget(c9910972.thtg)
	e1:SetOperation(c9910972.thop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c9910972.flag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(9910963,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910963,3))
	end
end
function c9910972.rmfilter(c,tp)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c9910972.thfilter(c,lv)
	return c:IsSetCard(0x5954) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(lv) and c:IsAbleToHand()
end
function c9910972.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910972.rmfilter,tp,LOCATION_DECK,0,nil,tp)
	local ct=g:GetClassCount(Card.GetCode)
	local gct=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	if ct>gct then ct=gct end
	if chk==0 then return #g>0
		and Duel.IsExistingMatchingCard(c9910972.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,ct) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c9910972.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910972.rmfilter,tp,LOCATION_DECK,0,nil,tp)
	if #g==0 then return end
	local ct=g:GetClassCount(Card.GetCode)
	local gct=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)
	if ct>gct then ct=gct end
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9910972.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,ct)
	if #tg==0 then return end
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910972,0))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	aux.GCheckAdditional=aux.dncheck
	local rg=g:SelectSubGroup(tp,aux.TRUE,false,lv,lv)
	aux.GCheckAdditional=nil
	Duel.ConfirmCards(1-tp,rg)
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	local rct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
	if rct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=tg:FilterSelect(tp,Card.IsLevel,1,1,nil,rct):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		Duel.SetLP(tp,Duel.GetLP(tp)-rct*500)
	end
end
