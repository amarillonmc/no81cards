--星海航线 混元天尊
function c11560707.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3) 
	c:EnableReviveLimit() 
	--actlimit  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAINING) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(0xff) 
	e0:SetOperation(c11560707.actop) 
	c:RegisterEffect(e0)   
	-- 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(EFFECT_ADD_ATTRIBUTE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(0xff) 
	e0:SetValue(ATTRIBUTE_LIGHT) 
	c:RegisterEffect(e0)   
	--to deck 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COIN+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11560707) 
	e1:SetTarget(c11560707.tdtg) 
	e1:SetOperation(c11560707.tdop) 
	c:RegisterEffect(e1)  
	--copy 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,21560707+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(c11560707.cptg) 
	e2:SetOperation(c11560707.cpop)  
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,31560707+EFFECT_COUNT_CODE_DUEL)
	e3:SetTarget(c11560707.reptg)
	c:RegisterEffect(e3) 
	--0  
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval) 
	e4:SetCondition(function(e) 
	return e:GetHandler():GetOverlayCount()==0 end)
	c:RegisterEffect(e4) 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(1)
	e4:SetCondition(function(e) 
	return e:GetHandler():GetOverlayCount()==0 end)
	c:RegisterEffect(e4) 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE) 
	e4:SetCode(EFFECT_UPDATE_ATTACK) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetValue(function(e) 
	return e:GetHandler():GetBaseAttack()/2 end) 
	e4:SetCondition(function(e) 
	return e:GetHandler():GetOverlayCount()==0 end)
	c:RegisterEffect(e4) 
	--1 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c11560707.rccon)
	e4:SetTarget(c11560707.rctg)
	e4:SetOperation(c11560707.rcop)
	c:RegisterEffect(e4)
end 
c11560707.toss_coin=true
c11560707.SetCard_SR_Saier=true
function c11560707.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler() then
		Duel.SetChainLimit(c11560707.chainlm)
	end
end
function c11560707.chainlm(e,rp,tp)
	return tp==rp 
end
function c11560707.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end 
function c11560707.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local x=Duel.TossCoin(tp,1) 
	if x==1 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) then 
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
	end 
end 
function c11560707.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end 
function c11560707.cpop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		local code=c:GetOriginalCodeRule()
		local cid=0
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if not c:IsType(TYPE_TRAPMONSTER) then
			cid=tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		end 
	end 
end 
function c11560707.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	local x=c:GetOverlayCount()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) 
		and c:CheckRemoveOverlayCard(tp,x,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,x,x,REASON_EFFECT) 
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil) 
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
		return true
	else return false end
end
function c11560707.rccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetOverlayCount()>0 
end 
function c11560707.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(ev/2) 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev/2) 
end
function c11560707.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT) 
end 








