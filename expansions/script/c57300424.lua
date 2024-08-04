--pvz bt z Z科技护盾机器人
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BATTLED)
	e0:SetCondition(s.damcon)
	e0:SetOperation(s.damop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(s.tglimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.desreptg)
	e3:SetOperation(s.desrepop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(s.adjustop)
	c:RegisterEffect(e4)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	return Duel.GetAttacker()==c
		and ((c:IsPosition(POS_ATTACK) and bc and bc:IsSetCard(0xc520) and bc:IsPosition(POS_ATTACK))
		or bc==nil and Duel.GetFlagEffect(0,id)==0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	local aatk=0
	if c:IsPosition(POS_ATTACK) then
		aatk=c:GetAttack()*-1
	end
	local batk=0
	if bc and bc:IsSetCard(0xc520) and bc:IsPosition(POS_ATTACK) then
		batk=bc:GetAttack()*-1
	end
	if bc and bc:IsSetCard(0xc520) and bc:IsPosition(POS_ATTACK) and not (c:GetFlagEffect(57300424)~=0) then
		local e1=Effect.CreateEffect(bc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(batk)
		c:RegisterEffect(e1)
	end
	if bc and c:IsPosition(POS_ATTACK) and not (bc:GetFlagEffect(57300424)~=0) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(aatk)
		bc:RegisterEffect(e1)
	end
	if bc==nil and c:GetAttack()>0 and Duel.GetFlagEffect(0,id)~=0 then
		local dam=math.ceil(c:GetAttack()/1000)
		if dam>0 then
			local rt=0
			for i=1,dam do
				if Duel.GetDecktopGroup(1-tp,i):GetCount()==i then rt=rt+1 end
			end
			local tg=Duel.GetDecktopGroup(1-tp,rt)
			if #tg==0 then return end
			Duel.DisableShuffleCheck()
			if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)>0 and Duel.GetMatchingGroupCount(nil,tp,0,LOCATION_DECK,nil)==0 then
				Duel.Win(tp,WIN_REASON_EXODIA)
			end
		end
	end
end
function s.indtg(e,c)
	local tc=e:GetHandler()
	return (c==tc  and tc:GetBattleTarget():IsSetCard(0xc520) or c==tc:GetBattleTarget() and tc:IsSetCard(0xc520))
end
function s.tglimit(e,c)
	local tc=e:GetHandler()
	return (c==tc  and tc:GetBattleTarget():IsSetCard(0xc520) or c==tc:GetBattleTarget() and tc:IsSetCard(0xc520))
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and not c:GetDefense()==0 end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else return false end
end
function s.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function s.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return seq<5 and math.abs(seq-s)==1 and c:IsControler(tp)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local g=Duel.GetMatchingGroup(s.desfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,seq,c:GetControler())
	if g:GetCount()~=0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		Duel.Readjust()
	end
end