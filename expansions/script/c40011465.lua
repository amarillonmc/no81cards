--蒸汽淑女 美楞
function c40011465.initial_effect(c)
	--draw 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,40011465) 
	e1:SetCondition(c40011465.drcon) 
	e1:SetCost(c40011465.drcost) 
	e1:SetTarget(c40011465.drtg)
	e1:SetOperation(c40011465.drop)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,40011465+1) 
	e2:SetCondition(c40011465.thcon)
	e2:SetTarget(c40011465.thtg)
	e2:SetOperation(c40011465.thop)
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)   
	e2:SetCondition(c40011465.xthcon)
	e2:SetOperation(c40011465.xthop)
	c:RegisterEffect(e2)
end
function c40011465.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0   
end 
function c40011465.rmfil(c) 
	return c:IsSetCard(0xaf1a) and c:IsAbleToRemoveAsCost()
end 
function c40011465.drcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c40011465.rmfil,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local rg=Duel.SelectMatchingCard(tp,c40011465.rmfil,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	rg:AddCard(e:GetHandler()) 
	Duel.Remove(rg,POS_FACEUP,REASON_COST) 
end
function c40011465.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c40011465.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c40011465.xthcon(e,tp,eg,ep,ev,re,r,rp)
	if re==nil then return false end  
	local rc=re:GetHandler()
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and rc and rc:IsSetCard(0xaf1a) 
end 
function c40011465.xthop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	c:RegisterFlagEffect(40011465,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) 
end 
function c40011465.thcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetFlagEffect(40011465)~=0  
end 
function c40011465.thfil(c)
	return c:IsSetCard(0xaf1a) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsAbleToHand()
end
function c40011465.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c40011465.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40011465.thfil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c40011465.thfil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c40011465.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

