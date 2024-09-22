--双影杀手-布梦者
function c9910442.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910442.discon)
	e1:SetOperation(c9910442.disop)
	c:RegisterEffect(e1)
	--be target
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c9910442.thcon)
	e2:SetTarget(c9910442.thtg)
	e2:SetOperation(c9910442.thop)
	c:RegisterEffect(e2)
	local ng=Group.CreateGroup()
	ng:KeepAlive()
	e2:SetLabelObject(ng)
	e1:SetLabelObject(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e3)
end
function c9910442.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function c9910442.disfilter(c,typ)
	return aux.NegateAnyFilter(c) and c:GetOriginalType()&typ~=0
end
function c9910442.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910442)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if not tc1 then return end
	local tc2=Duel.GetDecktopGroup(tp,1):GetFirst()
	if not tc2 then return end
	local tc3=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if not tc3 then return end
	local g=Group.FromCards(tc1,tc2,tc3)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local rg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	if #rg==0 then return end
	local sg=Group.CreateGroup()
	for tc in aux.Next(rg) do
		tc:RegisterFlagEffect(9910442,RESET_EVENT+RESETS_STANDARD,0,0)
		e:GetLabelObject():SetLabel(1)
		e:GetLabelObject():GetLabelObject():AddCard(tc)
		local typ=bit.band(tc:GetOriginalType(),0x7)
		local tg=Duel.GetMatchingGroup(c9910442.disfilter,tp,0,LOCATION_ONFIELD,sg,typ)
		if #tg>0 then
			tg:AddCard(tc)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910142,0))
			local sc=tg:Select(tp,1,1,nil):GetFirst()
			if not rg:IsContains(sc) then sg:AddCard(sc) end
		end
	end
	if #sg==0 then return end
	Duel.HintSelection(sg)
	for nc in aux.Next(sg) do
		Duel.NegateRelatedChain(nc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		nc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		nc:RegisterEffect(e2)
		if nc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e3)
		end
	end
end
function c9910442.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler())
end
function c9910442.thfilter(c)
	return c:GetFlagEffect(9910442)~=0 and c:IsAbleToHand()
end
function c9910442.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject():Filter(c9910442.thfilter,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9910442.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c9910442.thfilter,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:Select(1-tp,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
