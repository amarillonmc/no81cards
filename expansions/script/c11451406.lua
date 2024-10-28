--traveler with infinite saga
--21.04.10
local cm,m=GetID()
function cm.initial_effect(c)
	--c:SetUniqueOnField(1,0,m)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	--e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(0x11e1)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.damcon)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(11451409)
	e5:SetCondition(aux.TRUE)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_ACTIVATING)
		ge2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
		ge2:SetOperation(cm.chkop)
		Duel.RegisterEffect(ge2,0)
	end
	if not PNFL_SP_ACTIVATE then
		PNFL_SP_ACTIVATE=true
		local _MoveToField=Duel.MoveToField
		function Duel.MoveToField(tc,...)
			local res=_MoveToField(tc,...)
			local te=tc:GetActivateEffect()
			if te then
				local fid=tc:GetFieldID()
				local cost=te:GetCost() or aux.TRUE
				local cost2=function(e,tp,eg,ep,ev,re,r,rp,chk)
								if chk==0 then return cost(e,tp,eg,ep,ev,re,r,rp,0) end
								cost(e,tp,eg,ep,ev,re,r,rp,1)
								if fid==tc:GetFieldID() then
									Duel.RaiseEvent(tc,11451409,te,0,tp,tp,Duel.GetCurrentChain())
								end
								e:SetCost(cost)
							end
				te:SetCost(cost2)
			end
			return res
		end
	end
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,r,rp,ep,ev)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)~=0 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	if c:IsAttackAbove(2000) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,13)) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanRemove(tp)
	end
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dct<=0 then return end
	local g=Group.CreateGroup()
	Duel.ConfirmDecktop(tp,1)
	g:Merge(Duel.GetDecktopGroup(tp,1))
	if dct>1 then
		for i=1,math.min(5,dct-1) do
			if Duel.SelectYesNo(tp,aux.Stringid(m,12)) then
				Duel.MoveSequence(Duel.GetDecktopGroup(tp,1):GetFirst(),1)
				Duel.ConfirmDecktop(tp,1)
				g:Merge(Duel.GetDecktopGroup(tp,1))
			else break end
		end
	end
	local sct=#g
	local rg=g:Filter(Card.IsSetCard,nil,0xa977)
	if #rg==0 then
		if c:IsRelateToEffect(e) then Duel.SendtoDeck(c,nil,2,REASON_EFFECT) end
	elseif rg:IsExists(Card.IsAbleToRemove,1,nil) then
		rg=rg:Filter(Card.IsAbleToRemove,nil)
		local ct=#rg
		for tc in aux.Next(rg) do Duel.MoveSequence(tc,0) end
		if ct>1 then
			Duel.SortDecktop(1-tp,tp,#rg)
		end
		local dct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		for i=1,ct-1 do
			local sg1=Duel.GetMatchingGroup(function(c) return c:GetSequence()==dct-i-1 end,tp,LOCATION_DECK,0,nil)
			Duel.MoveSequence(sg1:GetFirst(),0)
		end
		Duel.DisableShuffleCheck()
		local int=Duel.Remove(Duel.GetDecktopGroup(tp,ct),POS_FACEUP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if int>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(int*500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			--c:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local lab=#og
		local tc=(og:GetMinGroup(Card.GetSequence) or Group.CreateGroup()):GetFirst()
		while tc do
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,sct,aux.Stringid(m,sct-1))
			tc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(m,lab+5))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
			e1:SetLabel(tc:GetFieldID())
			e1:SetLabelObject(tc)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,tp)
			local e3=e1:Clone()
			e3:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
			Duel.RegisterEffect(e3,tp)
			local e4=e1:Clone()
			e4:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
			Duel.RegisterEffect(e4,tp)
			local e5=e1:Clone()
			e5:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
			Duel.RegisterEffect(e5,tp)
			local e6=e1:Clone()
			e6:SetCode(EVENT_PHASE_START+PHASE_MAIN2)
			Duel.RegisterEffect(e6,tp)
			local e7=e1:Clone()
			e7:SetCode(EVENT_PHASE_START+PHASE_END)
			Duel.RegisterEffect(e7,tp)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CUSTOM+m)
			e2:SetRange(LOCATION_REMOVED)
			e2:SetCondition(cm.con)
			e2:SetOperation(cm.op)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			lab=lab-1
			og:RemoveCard(tc)
			tc=(og:GetMinGroup(Card.GetSequence) or Group.CreateGroup()):GetFirst()
		end
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local flag=c:GetFlagEffectLabel(m)
	if not flag or e:GetLabel()~=c:GetFieldID() then
		e:Reset()
	elseif flag<=1 then
		c:ResetFlagEffect(m)
		e:Reset()
	else
		flag=flag-1
		c:ResetFlagEffect(m)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(m,flag-1))
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local og=Duel.GetMatchingGroup(function(c) return c:GetFlagEffectLabel(m+1) and c:GetFlagEffectLabel(m+1)==tc:GetFlagEffectLabel(m+1) end,tp,LOCATION_REMOVED,0,tc)
	return cm.filter(tc,tp) and tc:GetFlagEffect(m)==0 and not og:IsExists(function(c) local flagc,flagtc={c:IsHasEffect(EFFECT_FLAG_EFFECT+m+1)},{tc:IsHasEffect(EFFECT_FLAG_EFFECT+m+1)} return flagc[1]:GetDescription()<flagtc[1]:GetDescription() end,1,nil)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local sg=Duel.GetMatchingGroup(function(c) return c:GetFlagEffectLabel(m+1) and c:GetFlagEffectLabel(m+1)==tc:GetFlagEffectLabel(m+1) end,tp,LOCATION_MZONE,0,nil)
	if not Duel.SelectEffectYesNo(tp,tc) then return end
	if tc:IsType(TYPE_FIELD) then
		local te=tc:GetActivateEffect()
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.DisableShuffleCheck()
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	elseif tc:IsType(TYPE_CONTINUOUS) then
		local te=tc:GetActivateEffect()
		Duel.DisableShuffleCheck()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	else
		Duel.DisableShuffleCheck()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true)
		te:UseCountLimit(tp,1,true)
		local cost=te:GetCost()
		local target=te:GetTarget()
		local operation=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if not tc:IsType(TYPE_EQUIP) then tc:CancelToGrave(false) end
		tc:CreateEffectRelation(te)
		if cost then cost(te,tp,ceg,cep,cev,cre,cr,crp,1) end
		if target then target(te,tp,ceg,cep,cev,cre,cr,crp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			for fc in aux.Next(g) do
				fc:CreateEffectRelation(te)
			end
		end
		if operation then operation(te,tp,ceg,cep,cev,cre,cr,crp) end
		tc:ReleaseEffectRelation(te)
		if g then
			for fc in aux.Next(g) do
				fc:ReleaseEffectRelation(te)
			end
		end
	end
end
function cm.filter(c,tp)
	return c:IsSetCard(0xa977) and ((c:CheckActivateEffect(false,false,false)~=nil and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsType(TYPE_CONTINUOUS+TYPE_FIELD)) or (c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp)) or (c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local tgp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER)
		return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and (not tgp or tgp~=tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.MoveSequence(tc,0)
	Duel.ConfirmDecktop(tp,1)
	Duel.MoveSequence(tc,1)
	if not cm.filter(tc,tp) then
		--[[Duel.ShuffleDeck(tp)
		local ph=Duel.GetCurrentPhase()
		if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then ph=PHASE_BATTLE end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+ph)
		c:RegisterEffect(e2)--]]
		local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		local sg=tg:Select(tp,1,1,nil)
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end
	else
		if tc:IsType(TYPE_FIELD) then
			local te=tc:GetActivateEffect()
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.DisableShuffleCheck()
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		elseif tc:IsType(TYPE_CONTINUOUS) then
			local te=tc:GetActivateEffect()
			Duel.DisableShuffleCheck()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		else
			Duel.DisableShuffleCheck()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true)
			te:UseCountLimit(tp,1,true)
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			Duel.ClearTargetCard()
			if not tc:IsType(TYPE_EQUIP) then tc:CancelToGrave(false) end
			tc:CreateEffectRelation(te)
			if cost then cost(te,tp,ceg,cep,cev,cre,cr,crp,1) end
			if target then target(te,tp,ceg,cep,cev,cre,cr,crp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				for fc in aux.Next(g) do
					fc:CreateEffectRelation(te)
				end
			end
			if operation then operation(te,tp,ceg,cep,cev,cre,cr,crp) end
			tc:ReleaseEffectRelation(te)
			if g then
				for fc in aux.Next(g) do
					fc:ReleaseEffectRelation(te)
				end
			end
		end
	end
end