--鸣雷灵光 赦罪殊雷
function c21692422.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,function(c) return c:IsSetCard(0x555) end,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--des
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(21692422,1))
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DISCARD)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(3) 
	e1:SetCondition(c21692422.descon)
	e1:SetTarget(c21692422.destg)
	e1:SetOperation(c21692422.desop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(21692422,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c21692422.discon) 
	e2:SetTarget(c21692422.distg)
	e2:SetOperation(c21692422.disop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c21692422.reptg)
	c:RegisterEffect(e3)
end
c21692422.SetCard_ZW_ShLight=true 
function c21692422.dckfil(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_HAND)  
end 
function c21692422.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21692422.dckfil,1,nil,tp)  
end 
function c21692422.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end 
function c21692422.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then 
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT) 
	end 
end  
function c21692422.tckfil(c,tp) 
	return c:IsOnField() and c:IsControler(tp)  
end 
function c21692422.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c21692422.tckfil,1,nil,tp) and Duel.IsChainNegatable(ev)
end 
function c21692422.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0) 
end
function c21692422.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev) 
end
function c21692422.rpfil(c) 
	return c:IsAbleToRemove() and c:IsSetCard(0x555) and c:IsType(TYPE_MONSTER) 
end 
function c21692422.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and Duel.IsExistingMatchingCard(c21692422.rpfil,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local rg=Duel.SelectMatchingCard(tp,c21692422.rpfil,tp,LOCATION_GRAVE,0,1,1,nil) 
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end

