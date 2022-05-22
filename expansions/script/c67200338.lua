--辉峰庙门的炼机工
function c67200338.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c67200338.ffilter,3,true)
	aux.EnablePendulumAttribute(c,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_ONFIELD,0,Duel.Release,REASON_COST+REASON_MATERIAL) 
	--Draw
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,67200338)
	e0:SetCost(c67200338.setcost)
	e0:SetTarget(c67200338.drtg)
	e0:SetOperation(c67200338.drop)
	c:RegisterEffect(e0)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)   
	--pendulum 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200338,2))
	e4:SetCategory(CATEGORY_RELEASE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c67200338.pencon)
	e4:SetTarget(c67200338.pentg)
	e4:SetOperation(c67200338.penop)
	c:RegisterEffect(e4) 
end
--
function c67200338.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionType(TYPE_PENDULUM) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
--
function c67200338.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	if c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,c)
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c67200338.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c67200338.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--go to P zone
function c67200338.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c67200338.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c67200338.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end