local s, id = GetID()--碧游宫
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
   
	local e2=Effect.CreateEffect(c)
	e2:SetRange(LOCATION_FZONE) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.target)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)


	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_THUNDER))
	e4:SetValue(500)
	c:RegisterEffect(e4)
	--Def
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetValue(500)
	c:RegisterEffect(e5)
end

function s.target(e,c)
	return c:IsSetCard(0x954)
end

function s.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x954)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,0,nil)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	while tc do
	  if  tc:IsFaceup() and not tc:IsLevel(8) then
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_CHANGE_LEVEL)
		  e1:SetValue(8)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		  tc:RegisterEffect(e1)
		  tc=g:GetNext()
	  end
	end
end