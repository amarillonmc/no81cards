--I:P伪装舞会小夜
local s,id,o=GetID()
function c98920815.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c98920815.lkfilter,2,2)
	c:EnableReviveLimit()	
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,id)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c98920815.indcon)
	e2:SetOperation(c98920815.indop)
	c:RegisterEffect(e2)
end
function c98920815.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsControler,1,nil,1-c:GetControler()) then
		c:RegisterFlagEffect(98920815,RESET_EVENT+0x4fe0000,0,1)
	end
end
function c98920815.lkfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and not c:IsType(TYPE_LINK)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function s.exfilter(c)
	return c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:IsLinkAbove(2)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.GetMatchingGroup(c98920815.exfilter,tp,LOCATION_EXTRA,0,nil)
	local tc=g:GetFirst()
	while tc do
		--extra material
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(c98920815.matval)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c98920815.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function c98920815.exmatcheck(c,lc,tp)
	if not c:IsControler(1-tp) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do	 
		local f=te:GetValue()
		local related,valid=f(te,lc,nil,c,tp)
		if related and not te:GetHandler():IsCode(98920815) then return false end
	end
	return true	 
end
function c98920815.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(c98920815.exmatcheck,1,nil,lc,tp)
end
function c98920815.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function c98920815.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920815,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetValue(aux.imval1)
	rc:RegisterEffect(e1,true)
end