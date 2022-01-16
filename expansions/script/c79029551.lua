--肆星壳·狼魂
function c79029551.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xbb),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),2,99,true)  
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029551.atkcon)
	e1:SetTarget(c79029551.atktg)
	e1:SetOperation(c79029551.atkop)  
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c79029551.efilter)
	e2:SetCondition(c79029551.imcon)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCost(c79029551.tgcost)
	e3:SetOperation(c79029551.tgop)
	c:RegisterEffect(e3)
end
function c79029551.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029551.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c79029551.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local m=c:GetMaterialCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(m*500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)  
end
function c79029551.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029551.fil(c)
	return c:IsType(TYPE_FUSION)
end
function c79029551.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetMaterial():IsExists(c79029551.fil,1,nil)
end
function c79029551.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.SetTargetCard(tc)
	local flag=0
	if tc:IsType(TYPE_MONSTER) then flag=bit.bor(flag,TYPE_MONSTER) end
	if tc:IsType(TYPE_SPELL) then flag=bit.bor(flag,TYPE_SPELL) end
	if tc:IsType(TYPE_TRAP) then flag=bit.bor(flag,TYPE_TRAP) end
	e:SetLabel(flag)
end
function c79029551.tgop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	c:RegisterFlagEffect(79029551,RESET_PHASE+PHASE_END,0,1)
	if Duel.SendtoGrave(tc,REASON_EFFECT) then
	local flag=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetTargetRange(0,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetTarget(c79029551.distg)
	e1:SetCondition(c79029551.discon)
	e1:SetLabel(flag)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
end
function c79029551.distg(e,c)
	return c:IsType(e:GetLabel())
end
function c79029551.discon(e)
	return e:GetHandler():GetFlagEffect(79029551)~=0
end

