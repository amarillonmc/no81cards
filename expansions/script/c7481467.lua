--王家长眠之谷的魂殿
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	--Remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	--return
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.rtcon)
	e4:SetOperation(s.rtop)
	c:RegisterEffect(e4)
	--
		--global effect
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetRange(0xff)
		ge1:SetCondition(s.regcon)
		ge1:SetOperation(s.regop)
		c:RegisterEffect(ge1)
		--global effect
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge2:SetRange(0xff)
		ge2:SetOperation(s.regop2)
		c:RegisterEffect(ge2)
	--[[if not s.global_effect then
		s.global_effect=true
		--tograve effect
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetCondition(s.regcon)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end]]
end
function s.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2e) and (Duel.IsChainSolving() or c:IsReason(REASON_COST))
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.tgfilter,1,nil)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("0")
	e:GetHandler():RegisterFlagEffect(id,0,0,1)
	--Duel.RegisterFlagEffect(tp,id,RESET_EVENT+EVENT_CHAIN_END,0,1)
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("1")
	e:GetHandler():ResetFlagEffect(id)
end
function s.handconfilter(c)
	return not c:IsSetCard(0x2e) and c:IsFaceup()
end
function s.handcon(e)
	return not Duel.IsExistingMatchingCard(s.handconfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.setfilter(c,tp)
	return c:IsSetCard(0x91) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsSSetable() or (((c:IsType(TYPE_CONTINUOUS) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or c:IsType(TYPE_FIELD)) and not c:IsForbidden() and c:CheckUniqueOnField(tp)))
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil,tp)
	local i=0
	while g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if not tc then return false end
		local selpos=0
		if tc:IsSSetable() then
			selpos=selpos|POS_FACEDOWN_ATTACK 
		end
		if (((tc:IsType(TYPE_CONTINUOUS) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or tc:IsType(TYPE_FIELD)) and not tc:IsForbidden() and tc:CheckUniqueOnField(tp)) then
			selpos=selpos|POS_FACEUP_ATTACK 
		end
		local pos=Duel.SelectPosition(tp,tc,selpos)
		if i<1 then i=i+1 Duel.BreakEffect() end
		if pos==POS_FACEUP_ATTACK then
			local field=tc:IsType(TYPE_FIELD)
			if field then
				local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
					Duel.BreakEffect()
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
		elseif pos==POS_FACEDOWN_ATTACK then
			Duel.SSet(tp,tc)
		end
		e:GetHandler():SetCardTarget(tc)
		g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil,tp)
	end
	local c=e:GetHandler()
	local tg=c:GetCardTarget()
	if not tg then return false end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_SZONE,0,nil,tg)
	if #g>0 then Duel.HintSelection(Group.FromCards(c)) end
	Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)
	for tc in aux.Next(g) do
		c:SetCardTarget(tc)
	end
end
function s.rmfilter(c,tg)
	return tg:IsContains(c) and c:IsAbleToRemove()
end
function s.rtfilter(c,tg)
	return tg:IsContains(c) and c:IsReason(REASON_TEMPORARY)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if --Duel.GetFlagEffect(tp,id)~=0 
	   c:GetFlagEffect(id)~=0 then
		--[[Duel.ResetFlagEffect(tp,id)
		local tg=c:GetCardTarget()
		if not tg then return false end
		local g=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_REMOVED,0,1,1,nil,tg)
		if #g>0 then 
			local tc=g:GetFirst()
			Duel.ReturnToField(tc)
			c:SetCardTarget(tc)
		end]]
	else
	--Debug.Message("2")
		local tg=c:GetCardTarget()
		if not tg then return false end
		local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_SZONE,0,nil,tg)
		if #g>0 then Duel.HintSelection(Group.FromCards(c)) end
		Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)
		for tc in aux.Next(g) do
			c:SetCardTarget(tc)
		end
	end
	--Duel.ResetFlagEffect(tp,id)
end
function s.rtcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2e)
end
function s.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.rtcfilter,1,nil)
end
function s.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Duel.ResetFlagEffect(tp,id)
	local tg=c:GetCardTarget()
	if not tg then return false end
	local g=Duel.SelectMatchingCard(tp,s.rtfilter,tp,LOCATION_REMOVED,0,1,1,nil,tg)
	if #g>0 then 
		Duel.HintSelection(Group.FromCards(c))
		local tc=g:GetFirst()
		local pos=tc:GetPosition()
		if tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,pos,true)
		else
			Duel.ReturnToField(tc)
		end
		c:SetCardTarget(tc)
	end
end
