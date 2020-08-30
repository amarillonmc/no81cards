--D4C
function c79035004.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c79035004.tg)
	e1:SetCost(c79035004.cost)
	e1:SetOperation(c79035004.op)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
end
function c79035004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()~=tp end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	end
end
function c79035004.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_MZONE) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	e:SetLabelObject(g) 
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c79035004.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local a=Duel.CreateToken(tp,79035005)
	Duel.SpecialSummonStep(a,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(tc:GetBaseAttack()) 
	a:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(tc:GetBaseDefense())
	a:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetValue(tc:GetOriginalCode())
	a:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e4:SetValue(tc:GetOriginalAttribute())
	a:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_RACE)
	e5:SetValue(tc:GetOriginalRace())
	a:RegisterEffect(e5)
	if tc:IsType(TYPE_XYZ) or tc:IsType(TYPE_LINK) then
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetValue(1)
	a:RegisterEffect(e6)
	else
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetValue(tc:GetOriginalLevel())
	a:RegisterEffect(e6)
	end
	--Destroy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_ONFIELD)
	e7:SetOperation(c79035004.deop)
	a:RegisterEffect(e7)
	a:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD,1)
	Duel.SpecialSummonComplete()
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TODECK)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetLabel(a:GetCode())
	e2:SetLabelObject(a)
	e2:SetTarget(c79035004.datg)
	e2:SetOperation(c79035004.daop)
	c:RegisterEffect(e2)	
end
function c79035004.deop(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetCode()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetCode())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_RULE)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c79035004.xfil(c,x) 
	return c:IsCode(x)
end
function c79035004.datg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=e:GetLabel()
	local x=e:GetLabelObject()
	if chk==0 then return eg:IsContains(x) and Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATION_MZONE,1,nil,a) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
end
function c79035004.daop(e,tp,eg,ep,ev,re,r,rp)
	local a=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_MZONE,nil,a)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_RULE)
	local atk=g:GetSum(Card.GetAttack)
	local def=g:GetSum(Card.GetDefense)
	Duel.Damage(1-tp,atk+def,REASON_EFFECT)
end






























