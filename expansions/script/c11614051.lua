--雪域生灵 雪豹
local s,id,o=GetID()
function s.initial_effect(c)
	--Enable Revive Limit
	c:EnableReviveLimit()
	--Link Summon
	aux.AddLinkProcedure(c,s.mfilter,2,99)
	--Indes/Untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.protfilter)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--Declare and Apply
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.declaretg)
	e3:SetOperation(s.declareop)
	c:RegisterEffect(e3)
end
function s.mfilter(c)
	return c:IsRace(RACE_BEAST+RACE_WINDBEAST)
end
function s.protfilter(e,c)
	return c:IsSetCard(0x5226) and c:IsLevel(3)
end
function s.declaretg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	--Declare 0-10
	local ac=Duel.AnnounceLevel(tp,0,10)
	Duel.SetTargetParam(ac)
end
function s.declareop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not tc or not tc:IsRelateToChain() then return end
	if ac==0 then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,0)
		s.apply_resolution(e,tp,tc,0)
	else
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetLabel(ac,ac)
		e1:SetLabelObject(tc)
		e1:SetOperation(s.countop)
		Duel.RegisterEffect(e1,tp)
		c:CreateEffectRelation(e1)
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
	if tc:IsType(TYPE_TRAPMONSTER) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
	Duel.AdjustInstantly()
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)  
	--Cache location for adjacent check
	local seq=tc:GetSequence()
	local loc=tc:GetLocation()
	local is_mzone=tc:IsLocation(LOCATION_MZONE)
	local is_szone=tc:IsLocation(LOCATION_SZONE)
	
	--Return to Deck
	if tc and tc:GetFlagEffect(id)>0 then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	if ac>=1 and seq<5 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local ag=Group.CreateGroup()
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		for ac in aux.Next(g) do
			local aseq=ac:GetSequence()
			local aloc=ac:GetLocation()
			if math.abs(aseq-seq)==1 and aseq<5 then
				if is_mzone and aloc==LOCATION_MZONE then ag:AddCard(ac) end
				if is_szone and aloc==LOCATION_SZONE then ag:AddCard(ac) end
			end
		end
		if #ag>0 then
			for nc in aux.Next(ag) do
				local ne1=Effect.CreateEffect(c)
				ne1:SetType(EFFECT_TYPE_SINGLE)
				ne1:SetCode(EFFECT_DISABLE)
				ne1:SetReset(RESET_EVENT+RESETS_STANDARD)
				nc:RegisterEffect(ne1)
				local ne2=Effect.CreateEffect(c)
				ne2:SetType(EFFECT_TYPE_SINGLE)
				ne2:SetCode(EFFECT_DISABLE_EFFECT)
				ne2:SetValue(RESET_TURN_SET)
				ne2:SetReset(RESET_EVENT+RESETS_STANDARD)
				nc:RegisterEffect(ne2)
			end
		end
	end
	--2+ ATK down
	if ac>=2 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		for ec in aux.Next(g) do
			local val=ac*200
			local de1=Effect.CreateEffect(c)
			de1:SetType(EFFECT_TYPE_SINGLE)
			de1:SetCode(EFFECT_UPDATE_ATTACK)
			de1:SetValue(-val)
			de1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(de1)
		end
	end
	--5+ Draw
	if ac>=5 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		local d=math.floor(ac/5)
		Duel.Draw(tp,d,REASON_EFFECT)
	end
	--10 Trap
	if ac==10 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetOperation(s.limop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.limfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE) 
		and (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousLocation(LOCATION_EXTRA))
end
function s.limop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.limfilter,nil,tp)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.SendtoGrave(g,REASON_EFFECT)
		e:Reset()
	end
end
