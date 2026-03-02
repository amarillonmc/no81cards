--雪域生灵 猞猁
local s,id,o=GetID()
function s.initial_effect(c)
	--Enable Revive Limit
	c:EnableReviveLimit()
	--Link Summon
	aux.AddLinkProcedure(c,nil,2,99,s.lcheck)
	--Set S/T
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--Negate and Apply
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsType,1,nil,TYPE_LINK,lc,sumtype,tp)
end
function s.setfilter(c)
	return c:IsSetCard(0x5226) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	--Declare 0-7
	local ac=Duel.AnnounceLevel(tp,0,7)
	Duel.SetTargetParam(ac)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not tc or not tc:IsRelateToChain() then return end
	if ac==0 then
		s.apply_resolution(e,tp,tc,0)
	else		
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetLabel(ac,ac)
		e1:SetLabelObject(tc)
		e1:SetOperation(s.countop)
		Duel.RegisterEffect(e1,tp)
		c:CreateEffectRelation(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,0)
	end
end
function s.countop(e,tp,eg,ep,ev,re,r,rp)
	local cur,orig=e:GetLabel()
	local tc=e:GetLabelObject()
	cur=cur-1
	e:SetLabel(cur,orig)
	if cur==0 then
		s.apply_resolution(e,tp,tc,orig)
		e:Reset()
	end
end
function s.apply_resolution(e,tp,tc,ac)
	local c=e:GetOwner()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_CARD,0,id)
	--Negate effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
	Duel.AdjustInstantly(tc)
	Duel.BreakEffect()
	--1+
	if ac>=1 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Recover(tp,ac*100,REASON_EFFECT)
	end
	--3+
	if ac>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		local ct=math.floor(ac/2)
		if ct>0 then
			local g=Duel.GetDecktopGroup(1-tp,ct)
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	--5+
	if ac>=5 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		local seq=tc:GetSequence()
		if tc:IsLocation(LOCATION_MZONE) then
			if seq>4 then return end --EMZ handled simply
		elseif tc:IsLocation(LOCATION_SZONE) then
			if seq>4 then return end
		else return end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		local ag=Group.CreateGroup()
		for oc in aux.Next(g) do
			local oseq=oc:GetSequence()
			local oloc=oc:GetLocation()
			if oloc==tc:GetLocation() and math.abs(oseq-seq)==1 then
				ag:AddCard(oc)
			end
		end
		if #ag>0 then
			for ac in aux.Next(ag) do
				local e3=e1:Clone()
				ac:RegisterEffect(e3)
				local e4=e2:Clone()
				ac:RegisterEffect(e4)
			end
		end
	end
	--7
	if ac==7 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local spg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		if #spg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=spg:Select(tp,1,2,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5226) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
