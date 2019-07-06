--动物朋友 后台准备
function c33700094.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c33700094.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c33700094.reptg)
	e2:SetValue(c33700094.repval)
	c:RegisterEffect(e2)
	--self
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700094,1))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c33700094.sgcon)
    e3:SetOperation(c33700094.sgop)
    c:RegisterEffect(e3)
end
function c33700094.operation(e,tp,eg,ep,ev,re,r,rp)
  e:GetHandler():RegisterFlagEffect(33700094,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c33700094.repfilter(c,tp)
	return c:IsSetCard(0x442) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsReason(REASON_BATTLE+REASON_EFFECT)
   and Duel.IsExistingMatchingCard(c33700094.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c33700094.tgfilter(c,code)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:GetCode()~=code
end
function c33700094.tgfilter2(c,tg)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not tg:IsExists(c33700094.tgfilter3,1,nil,c)
end
function c33700094.tgfilter3(c,g)
	return c:GetCode()==g:GetCode()
end
function c33700094.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c33700094.repfilter,1,nil,tp) end
   local tg=eg:Filter(c33700094.tgfilter,nil)
   if Duel.SelectYesNo(tp,aux.Stringid(33700094,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c33700094.tgfilter2,tp,LOCATION_DECK,0,tg:GetCount(),tg:GetCount(),nil,tg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		return true
	else return false end
end
function c33700094.repval(e,c)
	return c33700094.repfilter(c,e:GetHandlerPlayer())
end
function c33700094.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(33700094)~=0 
end
function c33700094.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end