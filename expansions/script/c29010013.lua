--方舟骑士-斯卡蒂·浊心
c29010013.named_with_Arknight=1
function c29010013.initial_effect(c)
	aux.AddCodeList(c,29010010,29010023)
	c:SetSPSummonOnce(29010013)
	--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c29010013.hspcon)
	e0:SetOperation(c29010013.hspop)
	c:RegisterEffect(e0)	
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c29010013.splimit)
	c:RegisterEffect(e1)
	--change card name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c29010013.cgcon)
	e2:SetOperation(c29010013.cgop)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c29010013.desreptg)
	e4:SetValue(c29010013.desrepval)
	e4:SetOperation(c29010013.desrepop)
	c:RegisterEffect(e4)
end
--spsummon proc
function c29010013.sprmfil(c) 
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER)  
end
function c29010013.sprmgck(g) 
	return g:IsExists(Card.IsCode,1,nil,29010010)  
end   
function c29010013.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c29010013.sprmfil,tp,LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and g:CheckSubGroup(c29010013.sprmgck,2) 
end
function c29010013.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(c29010013.sprmfil,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end
--spsummon condition
function c29010013.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
--change card name
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
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetValue(29010023)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
--Destroy replace
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