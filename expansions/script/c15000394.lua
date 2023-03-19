local m=15000394
local cm=_G["c"..m]
cm.name="替身名-『白蛇』"
function cm.initial_effect(c)
	c:EnableCounterPermit(0xf31)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(cm.gtg)
	e2:SetOperation(cm.gop)
	c:RegisterEffect(e2)
end
function cm.notfilter1(c)
	return c:IsFaceup() and aux.NegateMonsterFilter(c) and not c:IsCode(15000394)
end
function cm.notfilter2(c)
	return c:IsFaceup() and not c:IsCode(15000394)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.notfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.notfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) and e:GetHandler():IsCanAddCounter(0xf31,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,cm.notfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local dis=0
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e)
		and not tc:IsImmuneToEffect(e) then
		if ((not tc:IsDisabled()) and (not tc:IsAttack(0))) then dis=1 end
		c:SetCardTarget(tc)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetCondition(cm.rcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetCondition(cm.rcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetCondition(cm.rcon)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e4=e2:Clone()
			e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e4)
		end
		Duel.BreakEffect()
		if tc:IsDisabled() and tc:IsAttack(0) and dis==1 and tc:IsType(TYPE_MONSTER) then
			local code=tc:GetCode()
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e5:SetCode(15000394)
			e5:SetRange(LOCATION_MZONE)
			e5:SetLabel(code)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e5)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_ADJUST)
			e6:SetRange(0xff)
			e6:SetCondition(cm.regcon)
			e6:SetOperation(cm.regop)
			e6:SetLabelObject(e5)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e6)
			c:AddCounter(0xf31,1)
		end
	end
end
function cm.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function cm.regcon(e)
	return e:GetHandler():IsLocation(LOCATION_SZONE) or e:GetHandler():GetCounter(0xf31)==0
end
function cm.regop(e)
	local ce=e:GetLabelObject()
	if ce then
		ce:Reset()
		e:Reset()
	end
end
function cm.gtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then
		return Duel.IsExistingTarget(cm.notfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) and c:IsCanRemoveCounter(tp,0xf31,1,REASON_EFFECT) and c:IsHasEffect(15000394)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.notfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
end
function cm.isinarray(t,val)
	for _,v in ipairs(t) do
		if v==val then return false end
	end
	return true
end
function cm.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsCanRemoveCounter(tp,0xf31,1,REASON_EFFECT) and c:IsHasEffect(15000394) and not tc:IsImmuneToEffect(e) then
		local codes={}
		if c:IsHasEffect(15000394) then
			for _,i in ipairs{c:IsHasEffect(15000394)} do
				local code=i:GetLabel()
				if code and cm.isinarray(codes,code) then table.insert(codes,code) end
			end
		end
		table.sort(codes)
		local afilter={codes[1],OPCODE_ISCODE}
		if #codes>1 then
			--or ... or c:IsCode(codes[i])
			for i=2,#codes do
				table.insert(afilter,codes[i])
				table.insert(afilter,OPCODE_ISCODE)
				table.insert(afilter,OPCODE_OR)
			end
		end
		table.insert(afilter,TYPE_MONSTER)
		table.insert(afilter,OPCODE_ISTYPE)
		table.insert(afilter,OPCODE_AND)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
		if c:IsHasEffect(15000394) then
			for _,i in ipairs{c:IsHasEffect(15000394)} do
				local code=i:GetLabel()
				if ac==code then
					i:Reset()
					break
				end
			end
		end
		if not c:RemoveCounter(tp,0xf31,1,REASON_EFFECT) then return end
		Duel.BreakEffect()
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ac)
		e1:SetCondition(cm.rcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local cid=tc:ReplaceEffect(ac,RESET_EVENT+RESETS_STANDARD)
		--local cid=tc:CopyEffect(ac,RESET_EVENT+RESETS_STANDARD,1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetLabelObject(e1)
		e3:SetLabel(cid)
		e3:SetCondition(cm.rstcon)
		e3:SetOperation(cm.rstop)
		Duel.RegisterEffect(e3,tp)
		if tc:IsType(TYPE_NORMAL) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_REMOVE_TYPE)
			e4:SetValue(TYPE_NORMAL)
			e4:SetCondition(cm.rcon)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4,true)
		end
		if not tc:IsType(TYPE_EFFECT) then
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_ADD_TYPE)
			e5:SetValue(TYPE_EFFECT)
			e5:SetCondition(cm.rcon)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e5,true)
		end
	end
end
function cm.rstcon(e)
	return not e:GetOwner():IsHasCardTarget(e:GetLabelObject():GetHandler())
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject():GetHandler()
	if not c then e:Reset() return end
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	if e1 then e1:Reset() end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if c:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(c:GetControler()) end
	e:Reset()
end