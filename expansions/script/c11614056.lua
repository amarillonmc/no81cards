--雪域生灵 雪山主
local s,id,o=GetID()
function s.initial_effect(c)
	--Link Summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	aux.AddLinkProcedure(c,nil,2,99,s.matfilter)
	--Extra Material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(0,LOCATION_MZONE)
	e0:SetTarget(s.mattg)
	e0:SetValue(s.matval)
	c:RegisterEffect(e0)
	--Send and SP Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Banish and Apply
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	--Return Effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_MOVE)
	e3:SetCondition(s.retcon)
	e3:SetTarget(s.rettg)
	e3:SetOperation(s.retop)
	c:RegisterEffect(e3)
end
function s.matfilter(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x5226)
end
function s.mattg(e,c)
	return c:GetFlagEffect(id)>0
end
function s.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,true
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.sendfilter(c)
	return c:IsSetCard(0x5226) and c:IsFaceup() and c:IsAbleToGrave()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5226) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sendfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 --Will free up zones
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.sendfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.sendfilter,tp,LOCATION_MZONE,0,c)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ct<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local count=sg:GetCount()
			if count>ct then count=ct end
			local spg=sg:Select(tp,1,count,nil)
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and c:IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	local ac=Duel.AnnounceLevel(tp,4,20)
	Duel.SetTargetParam(ac)
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY)~=0 and c:GetOriginalCode()==id then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetLabel(ac,ac)
		e1:SetLabelObject(c)
		e1:SetOperation(s.countop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,0)
	--Return Effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_MOVE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetLabel(ac)
	e3:SetLabelObject(tc)
	e3:SetCondition(s.retcon)
	e3:SetOperation(s.retop2)
	c:RegisterEffect(e3)
end
function s.countop(e,tp,eg,ep,ev,re,r,rp)
	local cur,orig=e:GetLabel()
	local c=e:GetLabelObject()
	cur=cur-1
	e:SetLabel(cur,orig)
	if cur==0 then
		Duel.ReturnToField(c)
		e:Reset()
	end
end
function s.retop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	local ac=e:GetLabel()
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffect(id)>0 and tc:IsFaceup() then
		local val=ac*300
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	local ct2=math.floor(ac/2)
	if ct2>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		for ec in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-300)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
		end
	end
	--Every 5
	local ct5=math.floor(ac/5)
	if ct5>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_SZONE,nil)
		if #g>0 then
			local sg=g:Select(tp,1,ct5,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
	--Every 10
	local ct10=math.floor(ac/10)
	if ct10>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(tp,g)
		local sg=g:Select(tp,1,ct10,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	--20
	if ac==20 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.ConfirmCards(tp,g)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end
function s.retfilter(c)
	return c:IsFaceup() and (c:IsAttack(0) or c:IsDefense(0)) and c:IsAbleToRemove()
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.retfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.retfilter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
