--森罗的护神 荧精
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,99)
	c:EnableReviveLimit()
	--tograve
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,id)
	e0:SetCost(s.tgcost)
	e0:SetTarget(s.tgtg)
	e0:SetOperation(s.tgop)
	c:RegisterEffect(e0)
	--check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.checkop)
	c:RegisterEffect(e1)
	--check2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.eftg)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	c:RegisterEffect(e2)
	--adjust
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(0xff)
	e3:SetOperation(s.adjustop)
	c:RegisterEffect(e3)
	--
	if not s.global_activate_check then
		s.global_activate_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_CHAINING)
		ge0:SetOperation(s.actcheckop)
		Duel.RegisterEffect(ge0,0)
	end
	--
	if not s.globle_check then
		s.globle_check=true
		--
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop2)
		Duel.RegisterEffect(ge1,0)
		--effect gain
		local ge2=Effect.CreateEffect(c)
		ge2:SetDescription(aux.Stringid(id,2))
		ge2:SetType(EFFECT_TYPE_QUICK_O)
		ge2:SetCode(EVENT_FREE_CHAIN)
		ge2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
		ge2:SetRange(LOCATION_GRAVE)
		ge2:SetCondition(s.cpcon)
		ge2:SetTarget(s.cptg)
		ge2:SetOperation(s.cpop)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge3:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
		ge3:SetTarget(s.eftg2)
		ge3:SetLabelObject(ge2)
		Duel.RegisterEffect(ge3,0)
	end
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.effect_check then
		s.effect_check=true
		--
		local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil)
		cregister=Card.RegisterEffect
		Sylvan_Effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect and effect:GetCode()==EVENT_TO_GRAVE and effect:IsHasType(EFFECT_TYPE_TRIGGER_O) then
				local eff=effect:Clone()
				Sylvan_Effect[card:GetCode()]=eff
			end
			return 
		end
		for tc in aux.Next(g) do
			Duel.CreateToken(0,tc:GetOriginalCode())
		end
		Card.RegisterEffect=cregister
	end
	e:Reset()
end
function s.filter(c)
	return c:IsSetCard(0x90) and c:IsType(TYPE_MONSTER)
end
function s.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and (c:IsXyzLevel(xyzc,9) or c:IsSetCard(0x90))
end
function s.sfilter(c)
	return c:IsAbleToGrave() and not c:IsSetCard(0x90)
end
function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDiscardDeck(tp,1) end
	local sg=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_DECK,0,nil)
	local rt=math.min(#sg,c:GetOverlayCount())
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDiscardDeck(tp,1) end
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,rt,0,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.sfilter,tp,LOCATION_DECK,0,nil)
	local g2=g:Clone()
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	for i=1,ct do
		if #g>0 then
			seq=-1
			local tc=g:GetFirst()
			local rtc=g:GetFirst()
			while tc do
				if tc:GetSequence()>seq then
					seq=tc:GetSequence()
					rtc=tc
				end
				tc=g:GetNext()
			end
			g:RemoveCard(rtc)
		end
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	Duel.DiscardDeck(tp,dcount-seq,REASON_EFFECT+REASON_REVEAL)
end
function s.actcheckop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetFlagEffect(id)~=0 then
		rc:RegisterFlagEffect(id-1,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_EFFECT) and tc:IsSetCard(0x90)
		and tc:GetPreviousLocation()==LOCATION_DECK and tc:IsReason(REASON_EFFECT) and tc:IsReason(REASON_REVEAL) then
			tc:RegisterFlagEffect(id+fid,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		tc=eg:GetNext()
	end
end
function s.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_EFFECT) and tc:IsSetCard(0x90)
		and tc:GetPreviousLocation()==LOCATION_DECK and tc:IsReason(REASON_EFFECT) and tc:IsReason(REASON_REVEAL) then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		tc=eg:GetNext()
	end
end
function s.eftg(e,c)
	local fid=e:GetHandler():GetFieldID()
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x90)
		and c:GetPreviousLocation()==LOCATION_DECK and c:IsReason(REASON_EFFECT) and c:IsReason(REASON_REVEAL) and c:GetFlagEffect(id+fid)~=0 
end
function s.eftg2(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x90)
		and c:GetPreviousLocation()==LOCATION_DECK and c:IsReason(REASON_EFFECT) and c:IsReason(REASON_REVEAL) and c:GetFlagEffect(id)~=0 and c:IsHasEffect(id)
end
function s.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id-1)==0 
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ce=Sylvan_Effect[c:GetOriginalCode()]
	local tg=ce:GetTarget()
	if chk==0 then
		return ce and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0))
	end
	local ce=Sylvan_Effect[c:GetOriginalCode()]
	e:SetProperty(ce:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	ce:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(ce)
	Duel.ClearOperationInfo(0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local ce=e:GetLabelObject()
	if not ce then return end
	e:SetLabelObject(ce:GetLabelObject())
	local op=ce:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
