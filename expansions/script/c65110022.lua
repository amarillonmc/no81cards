--轮回的变数
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65110000)
	--cannot activte
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.con)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.chcost)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return rc:IsCode(65110020)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)==0
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,1)
	e1:SetValue(aux.TRUE)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetFieldGroup(tp,0xfe,0xfe)
	for tc in aux.Next(g) do
		if tc.initial_effect then
			_Creg=Card.RegisterEffect
			local effect_table={}
			function Card.RegisterEffect(c,e)
				table.insert(effect_table,e)
			end
			tc.initial_effect(tc)
			Card.RegisterEffect=_Creg
			for i,te in ipairs(effect_table) do
				if te:GetType()==EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_ACTIONS+EFFECT_TYPE_FIELD then
					if tc:IsType(TYPE_TRAP) then
						te:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						te:SetReset(RESET_PHASE+PHASE_END)
						te:SetCountLimit(2)
						te:SetCost(aux.TRUE)
						te:SetTarget(aux.TRUE)
						te:SetRange(LOCATION_HAND)
						te:SetOperation(s.fop)
						tc:RegisterEffect(te)
					else
						te:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
						te:SetReset(RESET_PHASE+PHASE_END)
						te:SetCountLimit(2)
						te:SetCost(aux.TRUE)
						te:SetTarget(aux.TRUE)
						te:SetRange(LOCATION_HAND)
						te:SetOperation(s.fop)
						tc:RegisterEffect(te)
					end
				end
				if te:GetType()==EFFECT_TYPE_IGNITION+EFFECT_TYPE_ACTIONS+EFFECT_TYPE_FIELD then
					te:SetType(EFFECT_TYPE_IGNITION+EFFECT_TYPE_CONTINUOUS)
					te:SetReset(RESET_PHASE+PHASE_END)
					te:SetCountLimit(2)
					te:SetCost(aux.TRUE)
					te:SetTarget(aux.TRUE)
					te:SetOperation(s.fop)
					tc:RegisterEffect(te)
				end
				if te:GetType()==EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIONS+EFFECT_TYPE_FIELD then
					te:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					te:SetReset(RESET_PHASE+PHASE_END)
					te:SetCountLimit(2)
					te:SetCost(aux.TRUE)
					te:SetTarget(aux.TRUE)
					te:SetOperation(s.fop)
					tc:RegisterEffect(te)
				end
			end
		end
	end
end
function s.fop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	error("Action is not allowed here.",0)
end
function s.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeckAsCost,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==g:GetCount() end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cc=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and cc and cc:GetCode()==65110000 and cc:GetOverlayGroup():GetClassCount(Card.GetCode)>=9 then
		local og=cc:GetOverlayGroup()
		local mg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc and mg:GetCount()<9 do
			if not mg:IsExists(Card.IsCode,1,nil,tc:GetCode()) then
				mg:AddCard(tc)
			end
			tc=og:GetNext()
		end
		local mc=mg:GetFirst()
		Duel.MoveToField(mc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,false,1)
		mc=mg:GetNext()
		for i=65110101,65110110 do
			cc:SetCardData(1,i)
		end
		Duel.MoveToField(mc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,false,16)
		mc=mg:GetNext()
		for i=65110111,65110120 do
			cc:SetCardData(1,i)
		end
		Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP_ATTACK,false,1)
		mc=mg:GetNext()
		for i=65110121,65110130 do
			cc:SetCardData(1,i)
		end
		Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP_ATTACK,false,16)
		mc=mg:GetNext()
		for i=65110131,65110140 do
			cc:SetCardData(1,i)
		end
		Duel.MoveToField(mc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,false,2)
		mc=mg:GetNext()
		for i=65110141,65110150 do
			cc:SetCardData(1,i)
		end
		Duel.MoveToField(mc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,false,8)
		mc=mg:GetNext()
		for i=65110151,65110160 do
			cc:SetCardData(1,i)
		end
		Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP_ATTACK,false,2)
		mc=mg:GetNext()
		for i=65110161,65110170 do
			cc:SetCardData(1,i)
		end
		Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP_ATTACK,false,8)
		mc=mg:GetNext()
		for i=65110171,65110178 do
			cc:SetCardData(1,i)
		end
		Duel.MoveToField(mc,tp,tp,LOCATION_SZONE,POS_FACEUP_ATTACK,false,4)
		cc:SetEntityCode(65110100,true)
		cc:ReplaceEffect(65110100,0,0)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(65110100,2))
		--add code
		local e0=Effect.CreateEffect(cc)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e0:SetCode(EFFECT_ADD_CODE)
		e0:SetValue(65110000)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		cc:RegisterEffect(e0)
		--to deck
		local e1=Effect.CreateEffect(cc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(s.tdop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		cc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_LEAVE_FIELD_P)
		cc:RegisterEffect(e2)
		Duel.SpecialSummon(cc,0,tp,tp,false,false,POS_FACEUP)	 
		mg:AddCard(c)
		Duel.Overlay(cc,mg)
	end   
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(0,id)==0 then
		Duel.RegisterFlagEffect(0,id,0,0,0)
		c:SetEntityCode(65110000,true)
		c:ReplaceEffect(65110000,0,0)
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ResetFlagEffect(0,id)
	end
end