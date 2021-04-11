--电晶星的紫快晶
function c72410100.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c72410100.mfilter,1)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,72410100)
	e1:SetCondition(c72410100.tkcon)
	e1:SetTarget(c72410100.tktg)
	e1:SetOperation(c72410100.tkop)
	c:RegisterEffect(e1)
end
function c72410100.mfilter(c)
	return c:IsLinkType(TYPE_LINK) and c:GetLink()>=2
end
function c72410100.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetLinkedGroup():FilterCount(Card.IsRace,nil,RACE_CYBERSE)~=0
end
function c72410100.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroupCount()
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()~=1 then return false end
	if chk==0 then return mg:IsExists(Card.IsType,1,nil,TYPE_LINK) and lg~=0 end
	e:SetLabel(mg:GetFirst():GetLink())
end
function c72410100.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local lg=e:GetHandler():GetLinkedGroup()
	local tg=Group.GetFirst(lg)
	while tg do
	if tg:GetFlagEffect(72410102)==0 and ct>=2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(72410100,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e1) 
		tg:RegisterFlagEffect(72410102,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(72410100,0))
	end
	if tg:GetFlagEffect(72410104)==0 and ct>=3 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(72410100,1))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e2) 
		tg:RegisterFlagEffect(72410104,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(72410100,1))
	end
	if tg:GetFlagEffect(72410106)==0 and ct>=4 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(72410100,2))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(aux.tgoval)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e3) 
		tg:RegisterFlagEffect(72410106,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(72410100,2))
	end
		if not tg:IsType(TYPE_EFFECT) then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ADD_TYPE)
		e4:SetValue(TYPE_EFFECT)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tg:RegisterEffect(e4)
		end
	tg=lg:GetNext()
	end
end

