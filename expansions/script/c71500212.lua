--命运预见『魔术师』
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--Card Pool: Please replace with actual IDs of "Destiny Foresight" Spells/Traps
s.pool={71500200,71500202,71500204,71500206,71500208,71500210,71500212}
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Generate Pool
	local pool={}
	for i=1,#s.pool do
		table.insert(pool,s.pool[i])
	end
	
	local selected_codes={}
	
	--Select 3 random cards
	for i=1,3 do
		if #pool==0 then break end
		local idx=Duel.GetRandomNumber(1,#pool)
		table.insert(selected_codes,pool[idx])
		table.remove(pool,idx)
	end
	if #selected_codes==0 then return end
	local codes=selected_codes
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	
	--Create and Add to hand
	local tc=Duel.CreateToken(tp,ac)
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		
		--Trap Act in Hand
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetTarget(s.traptg)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		
		--Restriction
		--Monitor activation
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetLabel(ac)
		e2:SetOperation(s.checkop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		
		--Lock
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetTargetRange(1,0)
		e3:SetValue(s.aclimit)
		e3:SetLabel(ac)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		
		--Check if announced card is this card (Edge case)
		if ac==id then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function s.traptg(e,c)
	return c:IsSetCard(0x781) and c:IsType(TYPE_TRAP)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(e:GetLabel()) and rp==tp then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.aclimit(e,re,tp)
	local ac=e:GetLabel()
	--If announced card already activated, restriction removed
	if Duel.GetFlagEffect(tp,id)>0 then return false end
	--Can activate the announced card
	if re:GetHandler():IsCode(ac) then return false end
	return true
end
