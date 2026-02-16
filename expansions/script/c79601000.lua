--幽冥暗杀者 佐罗德
local s,id,o=GetID()
function s.initial_effect(c)
	--Search and Set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Treat as Level 6
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.xyzlv)
	c:RegisterEffect(e3)
	--Grant Direct Attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(s.efcon)
	c:RegisterEffect(e4)
end
function s.setfilter(c)
	return c:IsSetCard(0xd70) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local pg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		if pg:GetCount()>0 and pg:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_DARK)==pg:GetCount() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			tc:RegisterEffect(e2)
		end
	end
end
function s.xyzlv(e,c,rc)
	return c:GetLevel()+0x60000
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0xd70)
end
