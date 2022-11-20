--西洋棋 兵卒
function c4455800.initial_effect(c)
	--direct atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)  
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCondition(c4455800.thcon)
	e2:SetTarget(c4455800.thtg) 
	e2:SetOperation(c4455800.thop) 
	c:RegisterEffect(e2) 
end
c4455800.SetCard_YLchess=true 
function c4455800.ckfil(c,tp) 
	return c:IsPreviousControler(tp) and c.SetCard_YLchess and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))  
end 
function c4455800.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c4455800.ckfil,1,nil,tp)  
end   
function c4455800.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end 
function c4455800.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 














