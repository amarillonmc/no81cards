local m=33590045
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(m)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_PZONE)
	--e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(cm.pspcon)
    e1:SetOperation(cm.countop)
	c:RegisterEffect(e1)
	--if not cm.global_check then
		--cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetRange(0x7F)
		ge1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		ge1:SetCondition(cm.checkcon)
		ge1:SetOperation(cm.checkop)
		c:RegisterEffect(ge1)
    --end
    	--no damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.ndcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCondition(cm.indcon)
	c:RegisterEffect(e2)
	--reflect battle damage
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_EQUIP)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,m) then return end
	return Duel.IsExistingMatchingCard(cm.pspfilter2,tp,0x7F,0,1,nil)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.pspfilter2,tp,0x7F,0,nil)
    if g:GetCount()<1 then return end
    local tc=g:GetFirst()
    while tc do
    	if Duel.IsPlayerAffectedByEffect(tp,m) then return end 
	    local mt=getmetatable(tc)
	    if loc==0x02 then loc=nil end
	    mt.psummonable_location=loc
	    tc:ResetFlagEffect(m)
	    tc=g:GetNext()
	end
end
function cm.pspfilter(c)
    return c:IsType(TYPE_RITUAL) and c:GetFlagEffect(m)==0 and not c:IsHasEffect(EFFECT_SPSUMMON_CONDITION)
end
function cm.pspfilter2(c)
    return c:IsType(TYPE_RITUAL) and c:GetFlagEffect(m)~=0 and not Duel.IsPlayerAffectedByEffect(c:GetControler(),m)
end
function cm.pspcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.pspfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerAffectedByEffect(tp,m)
end
function cm.countop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.pspfilter,tp,LOCATION_HAND,0,nil)
    if g:GetCount()<1 or not Duel.IsPlayerAffectedByEffect(tp,m) then return end
    local tc=g:GetFirst()
    while tc do
    	if tc:IsStatus(STATUS_COPYING_EFFECT) or not Duel.IsPlayerAffectedByEffect(tp,m) then return end
	    tc:EnableReviveLimit()
	    local mt=getmetatable(tc)
	    if loc==nil then loc=0x02 end
	    mt.psummonable_location=loc
	    local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	    --e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	    e1:SetOperation(Auxiliary.PSSCompleteProcedure)
	    tc:RegisterEffect(e1)
        tc:RegisterFlagEffect(m,0,0,1)
        tc=g:GetNext()
    end
end
function cm.ndcon(e)
	return e:GetHandler():GetEquipCount()==0
end
function cm.indcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function cm.thfilter(c)
	return c:IsSetCard(0x18d) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
