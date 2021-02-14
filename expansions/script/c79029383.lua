--炎·岁·术士干员-夕
function c79029383.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,99,c79029383.lcheck)
	c:EnableReviveLimit()   
	--no solve
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029383.nscon)
	e1:SetOperation(c79029383.nsop)
	c:RegisterEffect(e1)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c79029383.val)
	c:RegisterEffect(e3)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c79029383.efilter)
	c:RegisterEffect(e1)
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029383.discon)
	e2:SetOperation(c79029383.disop)
	c:RegisterEffect(e2)
end
function c79029383.lcheck(g)
	return g:IsExists(Card.IsExtraLinkState,1,nil)
end
function c79029383.nscon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():GetControler()==1-tp and re:IsActiveType(TYPE_SPELL)
end
function c79029383.nsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029383)
	Debug.Message("可别太过分。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029383,0))
	Duel.ChangeChainOperation(ev,c79029383.repop) 
end
function c79029383.repop(e,tp,eg,ep,ev,re,r,rp)
end
function c79029383.val(e,c)
	return c:GetLinkedGroupCount()*2000
end
function c79029383.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c79029383.discon(e)
	return e:GetHandler():GetSequence()>4
end
function c79029383.disop(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local zone=0
	if c:GetSequence()==6 then
	zone=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,1)+aux.SequenceToGlobal(1-tp,LOCATION_MZONE,3)+aux.SequenceToGlobal(1-tp,LOCATION_MZONE,4)
	else
	zone=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,0)+aux.SequenceToGlobal(1-tp,LOCATION_MZONE,1)+aux.SequenceToGlobal(1-tp,LOCATION_MZONE,3)
	end
	return zone
end











