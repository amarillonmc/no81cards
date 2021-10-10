--方舟之骑士·巫恋
c29010019.named_with_Arknight=1
function c29010019.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29010019)	
	e1:SetTarget(c29010019.sptg)
	e1:SetOperation(c29010019.spop)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c29010019.adtg)
	e2:SetValue(-1500)
	c:RegisterEffect(e2)
	--double 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c29010019.damcon)
	e3:SetOperation(c29010019.damop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c29010019.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c29010019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29010020,0,0x4011,0,0,5,RACE_SPELLCASTER,ATTRIBUTE_DARK) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c29010019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,29010020,0,0x4011,0,0,5,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,29010020)
	Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
	--cannot be battle target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetValue(aux.imval1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(c)
	e3:SetCondition(c29010019.decon)
	e3:SetOperation(c29010019.deop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e3)
	--
	local e4=e3:Clone()
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c29010019.decon1)
	token:RegisterEffect(e4)
	Duel.SpecialSummonComplete()
end
function c29010019.decon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetLabelObject())
end
function c29010019.decon1(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function c29010019.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_EFFECT)
end 
function c29010019.ckfil(c,seq) 
	return math.abs(seq-c:GetSequence())==1 or ((c:GetSequence()==5 and seq==3) or (c:GetSequence()==6 and seq==1))
end
function c29010019.adtg(e,c)
	local tp=e:GetHandlerPlayer()
	local g1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,nil,29010020)
	local g2=Group.CreateGroup()
	local tc=g1:GetFirst()
	while tc do
	local seq=tc:GetSequence()
	local g3=Duel.GetMatchingGroup(c29010019.ckfil,tp,0,LOCATION_MZONE,nil,seq)
	g2:Merge(g3)	
	tc=g1:GetNext()
	end
	return g2:IsContains(c)
end
function c29010019.eftg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c29010019.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==c:GetOwner() and c:IsRelateToBattle() and (c:IsAttackBelow(c:GetBaseAttack()) or c:IsDefenseBelow(c:GetBaseDefense()))
end
function c29010019.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end




