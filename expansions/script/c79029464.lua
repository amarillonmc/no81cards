--Mon3tr
function c79029464.initial_effect(c)
	c:SetUniqueOnField(1,0,79029464)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029464.m3con)
	e2:SetOperation(c79029464.m3op)
	c:RegisterEffect(e2)
	--ad to deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029464.adcon)
	e3:SetOperation(c79029464.adop)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(c79029464.fuslimit)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e8)
	local e9=e5:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e9) 
	local e10=e5:Clone()
	e10:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e10) 
end
function c79029464.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
function c79029464.adcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,79029463)
end
function c79029464.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end
function c79029464.m3con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(79029463) and rp==tp and Duel.GetFlagEffect(tp,79029464)==0
end
function c79029464.m3op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b2=false
	for i=1,ev do
	local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) and Duel.GetCurrentChain()>=2 then
	b2=true
	end
	end
	local op=0
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then 
	Duel.RegisterFlagEffect(tp,79029464,RESET_PHASE+PHASE_END,0,1)
	b1=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	b3=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil)
	if b1 and b2 and b3 then 
	op=Duel.SelectOption(tp,aux.Stringid(79029464,0),aux.Stringid(79029464,1),aux.Stringid(79029464,2))
	elseif b1 and b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(79029464,0),aux.Stringid(79029464,1))
	elseif b1 and b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029464,0),aux.Stringid(79029464,2))
	if op==1 then 
	op=op+1
	end
	elseif b2 and b3 then 
	op=Duel.SelectOption(tp,aux.Stringid(79029464,1),aux.Stringid(79029464,2))+1
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79029464,0))
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(79029464,1))+1
	elseif b3 then
	op=Duel.SelectOption(tp,aux.Stringid(79029464,2))+2  
	end
	if op==0 then
	sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	elseif op==1 then
	Debug.Message(1)
	local dg=Group.CreateGroup()
	for i=1,ev do
	local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if tgp~=tp and (te:IsActiveType(TYPE_MONSTER) or te:IsHasType(EFFECT_TYPE_ACTIVATE)) then  
	Duel.NegateActivation(i)
	end
	end
	elseif op==2 then
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
	end
	end 
end













