--幻叙咏者 汐音
local s,id,o=GetID()
function s.initial_effect(c)
	--Link Summon
	aux.AddLinkProcedure(c,nil,2,3)
	c:EnableReviveLimit()
	--Place in S/T
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.placecon)
	e1:SetOperation(s.placeop)
	c:RegisterEffect(e1)	
end
function s.placecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function s.placeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x838))
		e2:SetValue(1000)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)
		
		--Check Materials
		local mg=c:GetMaterial()
		if c:IsSummonType(SUMMON_TYPE_LINK) and mg:FilterCount(Card.IsSetCard,nil,0x838)>=2 then
			local ge1=Effect.CreateEffect(c)
			ge1:SetType(EFFECT_TYPE_FIELD)
			ge1:SetCode(EFFECT_UPDATE_ATTACK)
			ge1:SetRange(LOCATION_SZONE)
			ge1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			ge1:SetTarget(s.colfilter)
			ge1:SetValue(1000)
			local ge2=ge1:Clone()
			ge2:SetCode(EFFECT_UPDATE_DEFENSE)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
			e4:SetRange(LOCATION_SZONE)
			e4:SetTargetRange(LOCATION_SZONE,0)
			e4:SetTarget(s.eftg)
			e4:SetLabelObject(ge1)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
			local e5=e4:Clone()
			e5:SetLabelObject(ge2)
			c:RegisterEffect(e5)
		end
	end
end
function s.eftg(e,c)
	local seq=e:GetHandler():GetSequence()
	local cseq=c:GetSequence()
	return math.abs(seq-cseq)==1 and c:IsFaceup() and (c:GetType()&TYPE_CONTINUOUS>0 or c:GetType()&TYPE_TRAP>0)
end
function s.colfilter(e,c)
	return c:IsSetCard(0x838) and e:GetHandler():GetColumnGroup():IsContains(c)
end