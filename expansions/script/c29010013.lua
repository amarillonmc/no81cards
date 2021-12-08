--斯卡蒂·浊心
function c29010013.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcCodeFunRep(c,29010010,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),1,99,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c29010013.splimit)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(29010010)
	c:RegisterEffect(e2) 
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c29010013.cgcon)
	e3:SetOperation(c29010013.cgop)
	c:RegisterEffect(e3)
	--Atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e4:SetValue(1000)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c29010013.desreptg)
	e5:SetValue(c29010013.desrepval)
	e5:SetOperation(c29010013.desrepop)
	c:RegisterEffect(e5)
	--cannot be fusion material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c29010013.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c29010013.ckfil(c)
	return c:IsOnField() and c:IsType(TYPE_MONSTER)
		and not (c:IsAttribute(ATTRIBUTE_WATER) and c:IsCode(29010023))
end
function c29010013.cgcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c29010013.ckfil,1,nil)
end
function c29010013.cgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,29010013)
	local g=eg:Filter(c29010013.ckfil,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_WATER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(29010013,0))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_CODE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetValue(29010023)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c29010013.repfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
		and not c:IsReason(REASON_RULE) and Duel.CheckLPCost(c:GetControler(),800)
end
function c29010013.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c29010013.repfilter,nil)
	if chk==0 then return g:GetCount()>0 end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function c29010013.desrepval(e,c)
	return c29010013.repfilter(c)
end
function c29010013.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,29010013)
	local g=e:GetLabelObject()
	if g:IsExists(Card.IsControler,1,nil,tp) then Duel.PayLPCost(tp,800) end
	if g:IsExists(Card.IsControler,1,nil,1-tp) then Duel.PayLPCost(1-tp,800) end
	g:DeleteGroup()
end
