--水型镜·倒影世界
local m=11630211
local cm=_G["c"..m]
function c11630211.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)   
end
cm.SetCard_xxj_Mirror=true
function cm.cfilter(c,tp)
	local zone=0
	local seq=c:GetSequence()
	if seq==5 then
		zone=zone|(1<<aux.MZoneSequence(seq)+2)
	elseif seq==6 then
		zone=zone|(1<<aux.MZoneSequence(seq)-2)
	elseif seq==0 then
		 zone=zone|(1<<(seq+4)) 
	elseif seq==1 then
		 zone=zone|(1<<(seq+2))
	elseif seq==2 then
		 zone=zone|(1<<(seq))
	elseif seq==3 then
		 zone=zone|(1<<(seq-2))
	elseif seq==4 then
		 zone=zone|(1<<(seq-4))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and c:IsType(TYPE_MONSTER)
end
function cm.condition(e,tp)
	local c=e:GetHandler()
	--if c==nil then return true end
	local tp=c:GetControler()
	local zone=cm.getzone(tp)
	return Duel.GetMatchingGroupCount(cm.cfilter,tp,0,LOCATION_MZONE,nil,tp)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,11630212,0,TYPES_TOKEN_MONSTER,-2,-2,1,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetChainLimit(cm.limit1)
end
function cm.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_MZONE,nil,tp)
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		if seq==5 or seq==6 then
			zone=zone|(1<<aux.MZoneSequence(seq))
		else
			if seq>0 then zone=zone|(1<<(seq-1)) end
			if seq<4 then zone=zone|(1<<(seq+1)) end
		end
	end
	return zone
end
function cm.limit1(e,ep,tp)
	return not (tp~=ep and e:IsActiveType(TYPE_MONSTER))
end
function cm.manifesterfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(1-tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local zone=0
	--local zone=cm.getzone(tp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if Duel.IsPlayerCanSpecialSummonMonster(tp,11630212,0,TYPES_TOKEN_MONSTER,-2,-2,1,RACE_AQUA,ATTRIBUTE_WATER) then
		local tc=g:GetFirst()
		while tc do
			local zone=0
			local seq=tc:GetSequence()
			if seq==5 then
				zone=zone|(1<<aux.MZoneSequence(seq)+2)
			elseif seq==6 then
				zone=zone|(1<<aux.MZoneSequence(seq)-2)
			elseif seq==0 then
				zone=zone|(1<<(seq+4))  
			elseif seq==1 then
				zone=zone|(1<<(seq+2))
			elseif seq==2 then
				zone=zone|(1<<(seq))
			elseif seq==3 then
				zone=zone|(1<<(seq-2))
			elseif seq==4 then
				zone=zone|(1<<(seq-4))
			end
			--zone=4-math.log(seq,2)
			--zone=zone|(1<<(seq))
			local token=Duel.CreateToken(tp,11630212)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP,zone)
			if tc:IsFaceup() then 
				local atk=tc:GetAttack()
				local def=tc:GetDefense()
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e5:SetCode(EFFECT_SET_ATTACK_FINAL)
				e5:SetValue(atk)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e5,true)
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_SINGLE)
				e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e6:SetCode(EFFECT_SET_BASE_DEFENSE_FINAL)
				e6:SetValue(def)
				e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				token:RegisterEffect(e6,true)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetLabelObject(token)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				e1:SetValue(cm.efilter)
				token:RegisterEffect(e1,true)  
				--attack limit
			   -- local e1=Effect.CreateEffect(c)
				--e1:SetType(EFFECT_TYPE_SINGLE)
				--e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
				--e1:SetLabelObject(token)
				--e1:SetValue(cm.atlimit)
				--e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				--token:RegisterEffect(e1,true) 
				--local e2=Effect.CreateEffect(c)
				--e2:SetType(EFFECT_TYPE_SINGLE)
				--e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
				--e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				--token:RegisterEffect(e2,true) 
				--token:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
				--local e2=Effect.CreateEffect(c)
				--e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				--e2:SetCode(EVENT_PHASE+PHASE_END)
				--e2:SetCountLimit(1)
				--e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				--e2:SetLabelObject(token)
				--e2:SetCondition(cm.descon)
				--e2:SetOperation(cm.desop)
				--Duel.RegisterEffect(e2,tp)
			end
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()	 
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(HALF_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.efilter(e,te)
	local seq=e:GetHandler():GetSequence()
	return te:IsActiveType(TYPE_MONSTER) and seq==e:GetHandler():GetSequence()
end
--function cm.atlimit(e,c)
  --  local lc=e:GetLabelObject()
	--return not lc:GetColumnGroup():IsContains(c)
--end
function cm.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0  then return 0
	else return val end
end
--function cm.descon(e,tp,eg,ep,ev,re,r,rp)
--	local tc=e:GetLabelObject()
--	if tc:GetFlagEffect(m)~=0 then
--		return true
--	else
--		e:Reset()
--		return false
--	end
--end
--function cm.desop(e,tp,eg,ep,ev,re,r,rp)
--	local tc=e:GetLabelObject()
--	Duel.Destroy(tc,REASON_EFFECT)
--end
