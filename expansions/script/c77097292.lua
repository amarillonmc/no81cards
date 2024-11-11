--机械伊丽亲Ⅱ号机
function c77097292.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA) 
	e1:SetCondition(c77097292.espcon)
	e1:SetOperation(c77097292.espop)
	c:RegisterEffect(e1)
	--defense 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1)  
	e1:SetCost(c77097292.defcost)
	e1:SetTarget(c77097292.deftg) 
	e1:SetOperation(c77097292.defop) 
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2) 
	--code
	aux.EnableChangeCode(c,77097291,LOCATION_MZONE+LOCATION_GRAVE)
end
function c77097292.rlfil(c,e,tp) 
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRank(4) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsReleasable() and Duel.GetLocationCountFromEx(tp,tp,c,e:GetHandler())>0 
end 
function c77097292.espcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	return Duel.IsExistingMatchingCard(c77097292.rlfil,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function c77097292.espop(e,tp,eg,ep,ev,re,r,rp,c) 
	local g=Duel.SelectMatchingCard(tp,c77097292.rlfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c77097292.defcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end 
	Duel.PayLPCost(tp,500) 
end
function c77097292.deftg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and c:GetDefense()>0 end,tp,0,LOCATION_MZONE,1,nil) end 
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and c:GetDefense()>0 end,tp,0,LOCATION_MZONE,1,1,nil)
end 
function c77097292.defop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then   
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(tc:GetDefense()) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e1)	  
	end 
end 






