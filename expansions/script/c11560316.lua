--一刀幽鬼·蜃景
function c11560316.initial_effect(c) 
	--synchro summon
	aux.AddSynchroProcedure(c,c11560316.mfilter,aux.NonTuner(c11560316.mfilter),1)
	c:EnableReviveLimit() 
	--redirect 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0) 
	--atk and des
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,11560316)
	e1:SetTarget(c11560316.adestg) 
	e1:SetOperation(c11560316.adesop) 
	c:RegisterEffect(e1) 
	--da and des
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetCountLimit(1,21560316) 
	e2:SetTarget(c11560316.ddtg) 
	e2:SetOperation(c11560316.ddop) 
	c:RegisterEffect(e2)
	if not c11560316.global_check then
		c11560316.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c11560316.rmckop)
		Duel.RegisterEffect(ge1,0) 
	end 
end
c11560316.SetCard_XdMcy=true   
function c11560316.mfilter(c) 
	return c.SetCard_XdMcy  
end 
function c11560316.rmckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst() 
	while tc do   
	local flag=Duel.GetFlagEffectLabel(tc:GetControler(),11560316)
	if flag==nil then 
	Duel.RegisterFlagEffect(tc:GetControler(),11560316,0,0,0,1) 
	else 
	Duel.SetFlagEffectLabel(tc:GetControler(),11560316,flag+1)   
	end 
	tc=eg:GetNext() 
	end 
end  
function c11560316.adestg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local flag=Duel.GetFlagEffectLabel(tp,11560316) 
	if chk==0 then return flag and flag>=10 end 
end 
function c11560316.adesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1600)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e2) 
		if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11560316,0)) then 
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT) 
		end
	end 
end 
function c11560316.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local flag=Duel.GetFlagEffectLabel(tp,11560316) 
	if chk==0 then return flag and flag>=10 end 
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1600)
end 
function c11560316.desfil(c) 
	return c:IsFaceup() and c:IsAttackBelow(3200) 
end 
function c11560316.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	Duel.Damage(p,d,REASON_EFFECT) 
	if Duel.IsExistingMatchingCard(c11560316.desfil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11560316,0)) then 
	local dg=Duel.SelectMatchingCard(tp,c11560316.desfil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT)
	end 
end 











