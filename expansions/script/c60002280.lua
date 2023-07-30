--饥饿之王·嘉德路
function c60002280.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--to e1
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c60002280.ddtg)
	e1:SetOperation(c60002280.ddop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to e3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c60002280.incon)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e4)
	--to e5
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE) 
	e5:SetCondition(c60002280.rccon)
	e5:SetTarget(c60002280.rctg)
	e5:SetOperation(c60002280.rcop)
	c:RegisterEffect(e5)

end
--exto e1
function c60002280.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE) 
end  
function c60002280.ddop(e,tp,eg,ep,ev,re,r,rp)  
   local c=e:GetHandler()
   local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,c,e,tp):GetFirst()
	if tc:GetCounter(0x624)==0 then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif tc:GetCounter(0x624)~=0 then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			c:AddCounter(0x624,1)
			Duel.Draw(tp,2,REASON_EFFECT)
			Duel.RegisterFlagEffect(tp,60002148,RESET_PHASE+PHASE_END,0,1000)
		end
	end
end 
--exto e3
function c60002280.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end

--exto e5
function c60002280.rccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE) and c:GetCounter(0x624)>=1
end 
function c60002280.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	local atk=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c60002280.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local atk=e:GetHandler():GetAttack()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,atk,REASON_EFFECT)
end