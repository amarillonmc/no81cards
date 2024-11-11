--ヴァイロン・フレーム
local s,id,o=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--cannot active
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.limval)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.etg)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(s.eop)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
	return c:IsSetCard(0x30) and c:IsAbleToHand() and not c:IsCode(49811355)
end
function s.rdfilter(c)
	return c:IsSetCard(0x30) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rdfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg1=g1:Select(tp,1,1,nil)
		if tg1:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tg1)
		end
		Duel.SendtoDeck(tg1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) 
	end
end
function s.acfilter(c,rlevel)
	return c:IsSetCard(0x30) and c:GetEquipCount()>0 and c:GetLevel()&rlevel>0
end
function s.limval(e,re,rp)
	local tp=e:GetHandlerPlayer()
	local rc=re:GetHandler()
	local rlevel=rc:GetLevel()
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.acfilter,tp,LOCATION_MZONE,0,1,nil,rlevel)
end
--function s.costfilter(c,tp)
--	return c:IsSetCard(0x30) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost() and c:IsFaceupEx() and Duel.IsExistingTarget(s.efilter,tp,LOCATION_GRAVE,0,1,c)
--end
--function s.ecost(e,tp,eg,ep,ev,re,r,rp,chk)
--	local c=e:GetHandler()
--	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,1,nil,tp) and e:GetHandler():IsAbleToDeckAsCost() end
--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
--	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
--	g:AddCard(c)
--	Duel.SendtoDeck(g,nil,0,REASON_COST)
--end
function s.efilter(c,tp)
	return c:IsSetCard(0x30) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and Duel.IsExistingMatchingCard(s.esfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:IsFaceupEx()
end
function s.esfilter(c)
	return c:IsFaceup()
end
function s.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.efilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) 
	end
end
function s.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.efilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sc=Duel.SelectMatchingCard(tp,s.esfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc):GetFirst()
	if not sc then return end
	Duel.Equip(tp,tc,sc,true)
	--Add Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetLabelObject(sc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(s.eqlimit)
	tc:RegisterEffect(e1)
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end