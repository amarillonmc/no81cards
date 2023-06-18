--清之苑
local m=82209103
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--summon limit  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetCode(EFFECT_CANNOT_SUMMON)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetTargetRange(1,0)  
	e2:SetTarget(cm.sumlimit)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
	--destroy  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,0))  
	e4:SetCategory(CATEGORY_TOHAND)  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_BATTLE_DESTROYED)  
	e4:SetRange(LOCATION_FZONE)  
	e4:SetCountLimit(1)  
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)  
	--damage
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,1))  
	e5:SetCategory(CATEGORY_DAMAGE)  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e5:SetCode(EVENT_TO_GRAVE)  
	e5:SetCountLimit(1,m)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)  
	e5:SetCondition(cm.damcon)  
	e5:SetTarget(cm.damtg)  
	e5:SetOperation(cm.damop)  
	c:RegisterEffect(e5)  
end
function cm.sumlimit(e,c)  
	return c:IsType(TYPE_EFFECT)  
end  
function cm.thfilter(c)
	return c:IsType(TYPE_NORMAL) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end  
function cm.confilter(c)
	return c:IsSetCard(0xc298) and c:IsFaceup()
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return rp==1-tp and c:IsReason(REASON_DESTROY)  
	and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp
	and c:IsPreviousLocation(LOCATION_FZONE) and c:IsPreviousPosition(POS_FACEUP)
	and Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,nil)
end  
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetTargetParam(4000)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)  
end  
function cm.damop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Damage(p,d,REASON_EFFECT)  
end  