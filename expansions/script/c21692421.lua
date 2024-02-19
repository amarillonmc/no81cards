--剑约灵光 苍青之誓
function c21692421.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,function(c) return c:IsSetCard(0x555) end,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--remove 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,21692421)
	e1:SetCost(aux.bfgcost) 
	e1:SetCondition(c21692421.rmcon)
	e1:SetTarget(c21692421.rmtg)
	e1:SetOperation(c21692421.rmop)
	c:RegisterEffect(e1) 
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCost(c21692421.costchk)
	e2:SetOperation(c21692421.costop)
	c:RegisterEffect(e2)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_FLAG_EFFECT+21692421)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3)
	if not c21692421.global_check then
		c21692421.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c21692421.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
c21692421.SetCard_ZW_ShLight=true 
function c21692421.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	if r&REASON_COST>0 and rc:IsSetCard(0x555) and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then 
		Duel.RegisterFlagEffect(rp,21692421,RESET_PHASE+PHASE_END,0,1) 
	end 
end 
function c21692421.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,21692421)
	return Duel.CheckLPCost(tp,ct*500)
end
function c21692421.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,500)
end
function c21692421.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,21692421)>=3  
end 
function c21692421.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end 
function c21692421.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst() 
	if tc then 
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) 
	end  
end 




