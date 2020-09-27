--神
function c72100125.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72100125,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c72100125.settg)
	e1:SetOperation(c72100125.setop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_SPSUMMON_PROC)  
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e2:SetCondition(c72100125.hspcon)  
	c:RegisterEffect(e2)
end
function c72100125.setfilter(c)
	return c:IsCode(41420027,40605147,84749824,92512625) and c:IsSSetable()
end
function c72100125.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72100125.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c72100125.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c72100125.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
-----
function c72100125.filter(c)  
	return c:IsType(TYPE_TRAP)  
end  
function c72100125.hspcon(e,c)  
	if c==nil then return true end  
	local tp=c:GetControler()  
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and not Duel.IsExistingMatchingCard(c72100125.filter,tp,LOCATION_GRAVE,0,1,nil)  
end  