--离子炮龙-暗型
function c12057601.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsLevelAbove,7),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c12057601.efilter)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(12057601,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12057601)
	e2:SetCondition(c12057601.eqcon)
	e2:SetTarget(c12057601.eqtg)
	e2:SetOperation(c12057601.eqop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(12057601,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22057601)
	e3:SetCondition(c12057601.tdcon)
	e3:SetTarget(c12057601.tdtg)
	e3:SetOperation(c12057601.tdop)
	c:RegisterEffect(e3)	
end
function c12057601.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c12057601.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,re:GetHandler(),1,1-tp,0)
end
function c12057601.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=re:GetHandler() 
	if tc:IsRelateToEffect(re) then 
	Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c12057601.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c12057601.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end
function c12057601.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x,p=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,x,REASON_EFFECT)
end




