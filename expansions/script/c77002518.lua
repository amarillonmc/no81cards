--太虚七剑 自在剑
function c77002518.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77002518,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c77002518.otcon)
	e1:SetOperation(c77002518.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)	
	--type 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2) 
	--tribute check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c77002518.valcheck)
	c:RegisterEffect(e1)
	--give atk effect only when summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetOperation(c77002518.facechk)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2) 
	--Destroy
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_DESTROY) 
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1) 
	e3:SetCost(c77002518.descost)
	e3:SetTarget(c77002518.destg) 
	e3:SetOperation(c77002518.desop) 
	c:RegisterEffect(e3)  
end
function c77002518.otfilter(c)
	return c:IsSetCard(0x3eef) 
end
function c77002518.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c77002518.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c77002518.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c77002518.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c77002518.valcheck(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local atk=0
	local def=0
	while tc do
		local catk=tc:GetAttack()
		atk=atk+(catk>=0 and catk or 0) 
		local cdef=tc:GetDefense()
		def=def+(cdef>=0 and cdef or 0)
	tc=g:GetNext() 
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk/2)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE)
		e1:SetValue(def/2)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
	end
end
function c77002518.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end
function c77002518.rlfil(c) 
	return c:IsReleasable() and (c:IsSetCard(0x3eef) or c:IsType(TYPE_NORMAL))
end 
function c77002518.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77002518.rlfil,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c77002518.rlfil,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil) 
	Duel.Release(g,REASON_COST)
end 
function c77002518.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end  
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,2,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c77002518.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then 
		Duel.Destroy(g,REASON_EFFECT)	   
	end 
end 

