--血晶化过载-御影零夜
local s,id,o=GetID()
Duel.LoadScript("c33201050.lua")
function s.initial_effect(c)
	c:EnableCounterPermit(0x32b)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),8,3)
	c:EnableReviveLimit()   
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.spcon)
	e0:SetOperation(s.spop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCondition(s.ctcon)
	e1:SetOperation(s.ctop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--atk  
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE) 
	e2:SetCode(EFFECT_UPDATE_ATTACK) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x32b)>=5 end) 
	e2:SetValue(function(e,c)
	return e:GetHandler():GetCounter(0x32b)*100 end) 
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
	--counter
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.con)
	e5:SetOperation(s.op)
	c:RegisterEffect(e5)
end
s.VHisc_Vampire=true

--xyz
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(33201060) and c:GetCounter(0x32b)>=8
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=Duel.SelectMatchingCard(tp,s.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local mc=g:GetFirst()
	local ct=mc:GetCounter(0x32b)
	local mg=mc:GetOverlayGroup()
	if mg:GetCount()~=0 then
		Duel.Overlay(c,mg)
	end
	c:SetMaterial(g)
	Duel.Overlay(c,g)
	e:SetLabel(ct)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	return re==te
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=re:GetLabel()
	e:GetHandler():AddCounter(0x32b,ct)
	re:SetLabel(0)
end

--e4
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.IsChainNegatable(ev) and e:GetHandler():GetCounter(0x32b)>=10
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x32b,5,REASON_EFFECT) and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not (c:IsRelateToEffect(e) and c:IsCanRemoveCounter(tp,0x32b,5,REASON_EFFECT))
		or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	e:GetHandler():RemoveCounter(tp,0x32b,5,REASON_EFFECT)
	Duel.RaiseEvent(e:GetHandler(),EVENT_REMOVE_COUNTER+0x32b,e,REASON_EFFECT,tp,tp,ev)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--e5
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and e:GetHandler():GetCounter(0x32b)>=20 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(1-tp,500,REASON_EFFECT) then
		e:GetHandler():AddCounter(0x32b,1)
	end
end