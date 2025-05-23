--绛胧烈刃·发射频谱
local cm,m=GetID()
function cm.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451711,4))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	--e1:SetCondition(cm.recon)
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
	--effect2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(cm.mrcon)
	e3:SetTarget(cm.mrtg)
	e3:SetOperation(cm.mrop)
	c:RegisterEffect(e3)
end
function cm.ccfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==tp
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)==0 --Duel.GetMatchingGroupCount(cm.ccfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil,tp)==0
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	local t={}
	local i=1
	for i=1,7 do t[i]=i+2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451011,2))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local rep=c:IsStatus(STATUS_EFFECT_REPLACED)
	if c:IsRelateToEffect(e) and Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT) then
		--if rep then c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3)) end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_MOVE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
		e2:SetCondition(cm.mvcon)
		e2:SetOperation(cm.mvop1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		e:UseCountLimit(tp,1)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451011,2))
		c:RegisterFlagEffect(11451717,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(11451717,ct-3))
		c:RegisterFlagEffect(11451718,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,9-ct,aux.Stringid(11451718,9-ct))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabel(c:GetFieldID())
		e1:SetLabelObject(c)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local flag=c:GetFlagEffectLabel(11451718)
	if not flag or e:GetLabel()~=c:GetFieldID() then
		e:Reset()
	elseif flag>=9 then
		c:ResetFlagEffect(11451718)
		Duel.ReturnToField(c)
		e:Reset()
	else
		flag=flag+1
		c:ResetFlagEffect(11451718)
		c:RegisterFlagEffect(11451718,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(11451718,flag))
	end
end
function cm.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and not c:IsReason(REASON_SUMMON) and c:GetFlagEffect(11451717)>0
end
function cm.mvop1(e,tp,eg,ep,ev,re,r,rp)
	local n=11451718
	local cn=_G["c"..n]
	local chk=false
	local c=e:GetHandler()
	local lab=c:GetFlagEffectLabel(11451717)
	while 1==1 do
		local off=1
		local ops={} 
		local opval={}
		if not chk and cm.mvop(e,tp,eg,ep,ev,re,r,rp,2,lab) then
			ops[off]=aux.Stringid(n,10)
			opval[off-1]=1
			off=off+1
		end
		for i=11451711,11451715 do
			local ci=_G["c"..i]
			if  ci and cn and cn[i] and Duel.GetFlagEffect(tp,0xffffff+i)==0 and ci.mvop and ci.mvop(e,tp,eg,ep,ev,re,r,rp,2,lab) then
				ops[off]=aux.Stringid(i,3)
				opval[off-1]=i-11451709
				off=off+1
			end
		end
		if off==1 then break end
		if opval[0]~=1 then
			ops[off]=aux.Stringid(n,11)
			opval[off-1]=7
		end
		--mobile adaption
		local ops2=ops
		local op=-1
		if off<=5 then
			op=Duel.SelectOption(tp,table.unpack(ops))
		else
			local page=0
			while op==-1 do
				if page==0 then
					ops2={table.unpack(ops,1,4)}
					table.insert(ops2,aux.Stringid(11451505,4))
					op=Duel.SelectOption(tp,table.unpack(ops2))
					if op==4 then op=-1 page=1 end
				else
					ops2={table.unpack(ops,5,off)}
					table.insert(ops2,1,aux.Stringid(11451505,3))
					op=Duel.SelectOption(tp,table.unpack(ops2))+3
					if op==3 then op=-1 page=0 end
				end
			end
		end
		if opval[op]==1 then
			cm.mvop(e,tp,eg,ep,ev,re,r,rp,0,lab)
			chk=true
		elseif opval[op]>=2 and opval[op]<=6 then
			local ci=_G["c"..opval[op]+11451709]
			ci.mvop(e,tp,eg,ep,ev,re,r,rp,1,lab)
		elseif opval[op]==7 then break end
	end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp,opt,lab)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		if opt==2 then return true end
		if opt==1 then Duel.RegisterFlagEffect(tp,0xffffff+m,RESET_PHASE+PHASE_END,0,1) end
		Duel.HintSelection(Group.FromCards(c))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE+RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(lab*500)
		c:RegisterEffect(e1)
	end
	if ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL then
		if Duel.GetFlagEffect(0,11451711)==0 then
			Debug.Message("伤害步骤内不能触发效果战斗。")
			Duel.RegisterFlagEffect(0,11451711,RESET_PHASE+PHASE_DAMAGE,0,1)
		end
		return false
	end
	if not c:IsAttackable() then return end
	local g=c:GetAttackableTarget()
	local b1=0
	local fid=e:GetLabel()
	if fid~=0 then b1=1 end
	if g and #g>0 then
		if opt==2 then return true end
		if Duel.SelectYesNo(tp,aux.Stringid(m,b1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				--[[local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)
				e2:SetValue(HALF_DAMAGE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
				c:RegisterEffect(e2)--]]
				Duel.CalculateDamage(c,tc)
			end
			if fid~=0 then Duel.RaiseEvent(c,11451718,e,fid,0,0,0) end
		end
	end
	--c:ResetFlagEffect(11451717)
end
function cm.mrcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT~=0
end
function cm.mrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_DECK,0,1,nil,RACE_PSYCHO) end
end
function cm.mrop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_DECK,0,nil,RACE_PSYCHO)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end