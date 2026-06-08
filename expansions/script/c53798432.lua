local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,id-4)
	--pendulum effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--material check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.effcon)
	e2:SetTarget(s.distg)
	c:RegisterEffect(e2)
	--cannot activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(s.effcon)
	e3:SetValue(s.aclimit)
	c:RegisterEffect(e3)
end
function s.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_EXTRA,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_EXTRA,0,3,3,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	g:KeepAlive()
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(id+3,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	e:SetLabelObject(g)
end
function s.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),0,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tg)
		if c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			if Duel.Destroy(c,REASON_EFFECT)>0 then
				c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
				local og=e:GetLabelObject()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_SPSUMMON_SUCCESS)
				e1:SetLabel(fid)
				e1:SetLabelObject(og)
				e1:SetCondition(s.retcon)
				e1:SetOperation(s.retop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	return eg:IsContains(c) and c:IsSummonType(SUMMON_TYPE_RITUAL) and c:GetFlagEffect(id)>0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetLabelObject()
	local valid_og=Group.CreateGroup()
	if og then
		for tc in aux.Next(og) do
			if tc:IsLocation(LOCATION_REMOVED) and tc:GetFlagEffect(id+3)>0 then
				valid_og:AddCard(tc)
			end
		end
	end
	local rct=0
	if #valid_og>0 then
		Duel.SendtoDeck(valid_og,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local opg=Duel.GetOperatedGroup()
		rct=opg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	end
	if rct>0 then
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)
		if #g>=rct then
			local sg=g:RandomSelect(tp,rct)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
	if og then
		og:DeleteGroup()
	end
	e:Reset()
end
function s.valcheck(e,c)
	local mg=c:GetMaterial()
	local rank_sum=0
	local link_sum=0
	local tc=mg:GetFirst()
	while tc do
		rank_sum=rank_sum+math.max(tc:GetRank(),0)
		link_sum=link_sum+math.max(tc:GetLink(),0)
		tc=mg:GetNext()
	end
	c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,rank_sum)
	c:RegisterFlagEffect(id+2,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,link_sum)
end
function s.effcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.distg(e,c)
	local tc=e:GetHandler()
	if tc:GetFlagEffect(id+1)==0 then return false end
	local rank_sum=tc:GetFlagEffectLabel(id+1)
	local max_atk=rank_sum*400
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0) and c:IsAttackBelow(max_atk)
end
function s.aclimit(e,re,tp)
	local tc=e:GetHandler()
	if tc:GetFlagEffect(id+2)==0 then return false end
	local link_sum=tc:GetFlagEffectLabel(id+2)
	local min_def=link_sum*500
	local loc=re:GetActivateLocation()
	if loc~=LOCATION_GRAVE then return false end
	local rc=re:GetHandler()
	if rc:IsType(TYPE_MONSTER) and rc:IsDefenseAbove(min_def) then return false end
	return true
end