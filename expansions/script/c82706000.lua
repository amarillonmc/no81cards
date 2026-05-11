--“与我签订契约吧”
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,82706005)
	
	aux.AddRitualProcGreater2(c,s.filter,LOCATION_HAND+LOCATION_GRAVE,s.mfilter)
	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SSET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.setcon)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsSetCard(0xbd7)
end
function s.mfilter(c)
	return c:IsSetCard(0xbd7)
end
function s.setfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbd7) and not c:IsCode(82706005)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() and aux.NecroValleyFilter()(c) then
		Duel.SSet(tp,c)
	end
end