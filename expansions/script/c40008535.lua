--卡通精灵剑士
function c40008535.initial_effect(c)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c40008535.atklimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c40008535.dircon)
	c:RegisterEffect(e4)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c40008535.effcon)
	e5:SetOperation(c40008535.effop)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(c40008535.indes)
	c:RegisterEffect(e6)
end
function c40008535.indes(e,c)
	return c:GetAttack()>=1900
end
function c40008535.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40008535.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c40008535.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c40008535.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c40008535.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c40008535.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c40008535.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_RITUAL+REASON_FUSION+REASON_SYNCHRO+REASON_XYZ+REASON_LINK)~=0 and e:GetHandler():GetReasonCard():IsSetCard(0x62)
end
function c40008535.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e3=Effect.CreateEffect(rc)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetDescription(aux.Stringid(40008535,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	e3:SetCondition(c40008535.drcon)
	e3:SetTarget(c40008535.drtg)
	e3:SetOperation(c40008535.drop)
	rc:RegisterEffect(e3,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c40008535.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttacker()==e:GetHandler()
end
function c40008535.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x62)
end
function c40008535.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c40008535.drfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c40008535.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c40008535.drfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Draw(p,d,REASON_EFFECT)
end
