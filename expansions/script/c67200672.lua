--拟态武装 静澜
function c67200672.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c67200672.mfilter,c67200672.xyzcheck,3,3,c67200672.ovfilter,aux.Stringid(67200672,0),c67200672.xyzop)
	c:EnableReviveLimit() 
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c67200672.atkval)
	c:RegisterEffect(e3) 
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c67200672.atk)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	--cannot activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	--e6:SetCondition(c67200672.actcon)
	e6:SetValue(c67200672.aclimit)
	c:RegisterEffect(e6)   
end
--
function c67200672.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsSetCard(0x667b) 
end
function c67200672.xyzcheck(g)
	return g:GetClassCount(c67200672.getlvrklk)==1
end
function c67200672.getlvrklk(c)
	if c:IsLevelAbove(0) then return c:GetLevel() end
	if c:IsLinkAbove(0) then return c:GetLink() end
	--return c:GetLink()
end
function c67200672.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x667b) and c:IsType(TYPE_XYZ) and not c:IsCode(67200672)
end
function c67200672.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c67200672.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup()
	local ag=Group.Filter(g,Card.IsType,nil,TYPE_MONSTER)
	local x=0
	local y=0
	local tc=ag:GetFirst()
	while tc do
		y=tc:GetLink()
		x=x+y
		tc=ag:GetNext()
	end
	return x*1200
end
--
function c67200672.atk(e,c)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
function c67200672.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetColumnGroup():IsContains(tc)
end