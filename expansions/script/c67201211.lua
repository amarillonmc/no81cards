--狂暴轮回者-『？』
function c67201211.initial_effect(c)
	--link summon
	local e0=aux.AddLinkProcedure(c,c67201211.matfilter,2,4)
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_ONFIELD,0)
	e0:SetValue(c67201211.matval)
	c:RegisterEffect(e0) 
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,67201211)
	e1:SetOperation(c67201211.sumsuc)
	c:RegisterEffect(e1)	
end
function c67201211.matfilter(c)
	return c:IsLinkSetCard(0x567b) or (c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP))
end
function c67201211.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
function c67201211.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_LINK) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(c67201211.thcon2)
	e1:SetOperation(c67201211.thop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c67201211.thfilter(c)
	return c:IsSetCard(0x567b) and c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end
function c67201211.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c67201211.thfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c67201211.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c67201211.thfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.GetOperatedGroup()
			Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
		end
	end
end