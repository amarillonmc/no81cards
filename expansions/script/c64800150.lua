--燃煤概念机 希罗
local s,id,o=GetID()
RMJ_02=RMJ_02 or {}
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	RMJ_02.des(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x541a))
	e1:SetValue(500)
	c:RegisterEffect(e1)
end


-------RegisterEffect-------
function RMJ_02.des(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(s.destg)
	e0:SetOperation(s.desop)
	c:RegisterEffect(e0)
end
function RMJ_02.des1(c,code)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,code)
	e0:SetTarget(s.destg)
	e0:SetOperation(s.desop)
	c:RegisterEffect(e0)
end
function RMJ_02.pen(c,code)
	--pendulum
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(64800150,3))
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_LEAVE_FIELD)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCountLimit(1,code+20000)
	e9:SetCondition(s.pencon)
	e9:SetTarget(s.pentg)
	e9:SetOperation(s.penop)
	c:RegisterEffect(e9)
end
function RMJ_02.word(c)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetCondition(s.txtcon)
	e10:SetOperation(s.txtop)
	c:RegisterEffect(e10)
end

-------Functions and Filters-------
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function s.txtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) 
end
function s.txtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetCode(),4))
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetCode(),5))
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetCode(),6))
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end


function RMJ_02.pf(c)
	return c:IsSetCard(0x541a) and c:IsType(TYPE_PENDULUM)
end
function RMJ_02.rmf(c)
	return c:IsSetCard(0x541a) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function RMJ_02.rmfe(c)
	return c:IsSetCard(0x541a) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToRemove()
end


