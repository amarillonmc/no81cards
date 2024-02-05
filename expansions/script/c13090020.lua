--泥销骨
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-1600)
	c:RegisterEffect(e1)
	 --equip 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)  
	--set 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.setcon)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(s.descon)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	if c==nil then return end
	return c:IsAttack(0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
		Duel.Destroy(c,REASON_EFFECT)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Equip(tp,c,tc)
		local aa
		local atk=tc:GetBaseAttack()
		if tc:IsType(TYPE_XYZ) then aa=tc:GetRank() 
		elseif tc:IsType(TYPE_LINK) then aa=tc:GetLink() 
		else aa=tc:GetLevel() end
		e:SetLabel(atk,aa)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(s.eqlimit)
		c:RegisterEffect(e1)
	  end
end
--equip 
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()==nil
end
function s.tgfilter(c,tp,g)
	return g:IsContains(c) and c:IsFaceup()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg 
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,tp,g) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,g) end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,g)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		--Equip limit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(s.eqlimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetLabelObject(tc)
		c:RegisterEffect(e2)
	else
		c:CancelToGrave(false)
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--set 
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_LOST_TARGET)
		and not e:GetHandler():GetPreviousEquipTarget():IsLocation(LOCATION_ONFIELD+LOCATION_OVERLAY)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetPreviousEquipTarget()
	if tc==nil then return end
	local atk=tc:GetBaseAttack()
	local ct=tc:GetLevel() 
	if tc:IsType(TYPE_XYZ) then ct=tc:GetRank() elseif tc:IsType(TYPE_LINK) then ct=tc:GetLink() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local rg1=Duel.GetDecktopGroup(1-tp,1)
	local rg2=Duel.GetDecktopGroup(1-tp,1)
	local b1=true
	local b2=rg1:FilterCount(Card.IsAbleToRemove,nil)>=1
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=1122
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=1102
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Damage(1-tp,200,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(96633955,0))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCode(EVENT_REMOVE)
			e1:SetOperation(s.regop)
			e1:SetLabel(tp)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(0,1)
			e2:SetValue(s.actlimit)
			e2:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e2,tp)
		Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT)
			--
			
	   
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:GetReasonPlayer()==e:GetLabel() then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2,0,1)
		end
	end
end
function s.actlimit(e,re,tp)
	return re:GetHandler():GetFlagEffect(id)>0
end