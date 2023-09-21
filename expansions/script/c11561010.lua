--安的巨大英灵
function c11561010.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c11561010.ffilter,2,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD,0,Duel.Remove,POS_FACEUP,REASON_COST):SetCountLimit(1,11561010+EFFECT_COUNT_CODE_OATH) 
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(function(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st) end) 
	c:RegisterEffect(e1)
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(c11561010.descon) 
	e1:SetOperation(c11561010.desop) 
	c:RegisterEffect(e1) 
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(function(e,c)
	return c~=e:GetHandler() end) 
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(function(e,c)
	return c~=e:GetHandler() end) 
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)  
	e3:SetCondition(function(e) 
	return e:GetHandler():IsFaceup() end)
	e3:SetOperation(c11561010.xdesop)  
	c:RegisterEffect(e3)  
end
function c11561010.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_SPELLCASTER) 
	and (not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(Card.IsLevel,1,c,c:GetLevel())
			and not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())))
end 
function c11561010.desfil(c,atk) 
	return c:IsFaceup() and c:GetAttack()<atk  
end 
function c11561010.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11561010.desfil,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())  
end 
function c11561010.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(c11561010.desfil,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) then 
		Duel.Hint(HINT_CARD,0,11561010)
		local dg=Duel.SelectMatchingCard(tp,c11561010.desfil,tp,0,LOCATION_MZONE,1,1,nil,e:GetHandler():GetAttack()) 
		if Duel.Destroy(dg,REASON_EFFECT)~=0 then   
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1) 
		end  
	end 
end 
function c11561010.xdesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	Duel.Hint(HINT_CARD,0,11561010) 
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT) 
end 

