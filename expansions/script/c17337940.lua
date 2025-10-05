--·Re：从零开始的异世界生活·
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337440)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.chcon)
	e1:SetTarget(s.acttg)
	e1:SetOperation(s.actop)
	c:RegisterEffect(e1)
	--
	local e2=e1:Clone()
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(s.atkcon)
	c:RegisterEffect(e2)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(s.rtg)
	e3:SetOperation(s.repop)
	e3:SetValue(s.rval)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3f50)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return g:GetClassCount(Card.GetCode)>=10
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return g:GetClassCount(Card.GetCode)>=10 and Duel.GetAttacker():GetControler()~=tp
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsStatus),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,nil,STATUS_BATTLE_DESTROYED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.exgfilter(c,e,tp)
	return c:IsCode(17337440) and  c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.thfilter(c)
	return c:IsSetCard(0x3f50) and c:IsAbleToHand()
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsStatus),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,aux.ExceptThisCard(e),STATUS_BATTLE_DESTROYED)
	if aux.NecroValleyNegateCheck(g) then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	local tg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK)
	if tg:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
	if tg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	local b1=Duel.IsExistingMatchingCard(s.exgfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	if #tg>0 and b1 and b2 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		local exg=Duel.GetMatchingGroup(s.exgfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=exg:Select(tp,1,1,nil):GetFirst()
		if sc and Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
			sc:CompleteProcedure()
			local thg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=thg:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x5f50) and c:IsLocation(0x04) and c:IsFaceup() and (c:GetDestination()==0x01 or c:GetDestination()==0x02 or c:GetDestination()==0x10 or c:GetDestination(0x20) or c:GetDestination(0x40))
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and eg:IsExists(s.repfilter,1,nil,tp) and c:IsAbleToRemove() end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0)) then
		return true
	else return false end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function s.rval(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0x5f50) and c:IsLocation(0x04) and c:IsFaceup()
end