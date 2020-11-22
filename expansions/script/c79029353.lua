--卡西米尔·重装干员-临光·耀骑士
function c79029353.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa900),aux.NonTuner(nil),1)
	c:EnableReviveLimit()	 
	--extra matrial
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c79029353.emtg)
	e1:SetOperation(c79029353.emop)
	c:RegisterEffect(e1)
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(0,LOCATION_MZONE)
	e0:SetValue(c79029353.matval)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED)
	e3:SetTarget(c79029353.mattg)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1200)
	e3:SetCondition(c79029353.effcon)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabel(2)
	e2:SetCondition(c79029353.effcon)
	e2:SetTarget(c79029353.destg)
	e2:SetOperation(c79029353.desop)
	c:RegisterEffect(e2)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c79029353.efilter)
	e5:SetCondition(c79029353.effcon)
	e5:SetLabel(3)
	c:RegisterEffect(e5)
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetCondition(c79029353.effcon)
	e6:SetLabel(4)
	c:RegisterEffect(e6)
	--direct attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetCondition(c79029353.effcon)
	e6:SetLabel(5)
	c:RegisterEffect(e6)
	--match kill
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_MATCH_KILL)
	e4:SetCondition(c79029353.effcon)
	e4:SetLabel(6)
	c:RegisterEffect(e4)
end
function c79029353.mattg(e,c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_LINK)
end
function c79029353.mfil(c)
	return c:GetFlagEffect(79029353)~=0
end
function c79029353.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(c79029353.mfil,mg:GetCount(),nil)
end
function c79029353.efffil(c,e)
	return c:GetLinkedGroup():IsContains(e:GetHandler()) and c:IsSetCard(0xa900)
end 
function c79029353.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c79029353.efffil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e)>=e:GetLabel()
end
function c79029353.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c79029353.emtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetMaterialCount()
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and x~=0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,x,nil) 
	Duel.SetTargetCard(g)
end
function c79029353.emop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc do
	tc:RegisterFlagEffect(79029353,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(79029353,0))
	tc=g:GetNext()
	end
end
function c79029353.filter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c79029353.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029353.filter,tp,0,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c79029353.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c79029353.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c79029353.filter,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e),c:GetAttack())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end








