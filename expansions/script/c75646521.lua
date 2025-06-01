--拟似黑洞
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsFaceup() and not c:IsSetCard(0x62c2)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end

function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local dis=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0xe000e0)--(0|0x60)<<16
	e:SetLabel(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function s.ssfilter(c)
	return c:GetFlagEffect(id+2)==0
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local seq1=0
	local p=1-tp
	if e:GetLabel()>65535 then 
		seq1=math.log(bit.rshift(e:GetLabel(),16),2)
		p=tp
	else 
		seq1=math.log(e:GetLabel(),2)
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,p,0,LOCATION_MZONE,nil)
	for i=0,#g do
		local tc=g:GetFirst()
		while tc do
			local seq2=tc:GetSequence()
			if seq2==5 then seq2=1 
				elseif seq2==6 then seq2=3
			end
			local t=math.abs(seq1-seq2)
			if tc:GetFlagEffect(id)==0 then tc:RegisterFlagEffect(id,0,0,0,t) end
			tc=g:GetNext()
		end
	end
	for ii=0,#g do
		local tg=g:Filter(s.ssfilter,nil):GetMinGroup(Card.GetFlagEffectLabel,id)
		if tg then
			local ttc=tg:GetFirst()
			while ttc do
				ttc:RegisterFlagEffect(id+2,0,0,0)
				local seq2=ttc:GetSequence()
				if seq2==5 then seq2=1 
					elseif seq2==6 then seq2=3
				end 
				local t=math.abs(seq1-ttc:GetSequence())
				for i=0,t+1 do
					if ttc:GetFlagEffect(id+1)==0 then
							local seq22=ttc:GetSequence()
							if seq22<5 and (seq22==seq1+i) or (seq22==seq1-i) then ttc:RegisterFlagEffect(id+1,0,0,0) 
							elseif seq1<seq2 and Duel.CheckLocation(1-p,LOCATION_MZONE,seq1+i) and seq1+i<5 then 
							Duel.MoveSequence(ttc,seq1+i)
							ttc:RegisterFlagEffect(id+1,0,0,0)
							elseif seq1>seq2 and Duel.CheckLocation(1-p,LOCATION_MZONE,seq1-i) and seq1-i>-1
							then Duel.MoveSequence(ttc,seq1-i)
							ttc:RegisterFlagEffect(id+1,0,0,0)
						end
						if ttc:GetFlagEffect(id+1)==0 and Duel.CheckLocation(1-p,LOCATION_MZONE,seq1+i) and seq1+i<5 then 
							Duel.MoveSequence(ttc,seq1+i)
							ttc:RegisterFlagEffect(id+1,0,0,0)
							elseif ttc:GetFlagEffect(id+1)==0 and Duel.CheckLocation(1-p,LOCATION_MZONE,seq1-i) and seq1-i>-1
							then Duel.MoveSequence(ttc,seq1-i)
							ttc:RegisterFlagEffect(id+1,0,0,0)
						end
					end
				end 
				ttc:ResetFlagEffect(id+1)
				ttc=tg:GetNext()
			end
		end
	end
	local sc=g:GetFirst()
	while sc do
		sc:ResetFlagEffect(id)
		sc:ResetFlagEffect(id+2)
		sc=g:GetNext()
	end
end
