--拟态武装 紫竹
function c67200662.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x667b),2)
	c:EnableReviveLimit()
	--extra link
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTarget(c67200662.mattg)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetValue(c67200662.matval)
	c:RegisterEffect(e0) 
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200662,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67200662.spcon)
	e1:SetTarget(c67200662.sptg)
	e1:SetOperation(c67200662.spop)
	c:RegisterEffect(e1)	
end
---
function c67200662.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,true
end
function c67200662.mattg(e,c)
	return c:IsFaceup() and c:IsLinkType(TYPE_MONSTER) and c:IsLevel(3)
end
--
function c67200662.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c67200662.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,67200663,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,4,RACE_PSYCHO,ATTRIBUTE_DARK)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c67200662.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,67200663,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,4,RACE_PSYCHO,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,67200663)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.SelectYesNo(tp,aux.Stringid(67200662,2)) then
		if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,67200663))
			e1:SetValue(c67200662.val)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c67200662.val(e,c)
	local ag=Duel.GetMatchingGroup(c67200662.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	local x=0
	local y=0
	local tc=ag:GetFirst()
	while tc do
		y=tc:GetLink()
		x=x+y
		tc=ag:GetNext()
	end
	return x*500
end
function c67200662.atkfilter(c)
	return c:IsSetCard(0x667b) and c:IsType(TYPE_LINK)
end

