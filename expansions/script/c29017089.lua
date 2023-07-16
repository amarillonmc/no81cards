--战术协同
function c29017089.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29017089,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,29017089)
	e2:SetCondition(c29017089.thcon)
	e2:SetTarget(c29017089.thtg)
	e2:SetOperation(c29017089.thop)
	c:RegisterEffect(e2)
	--Draw
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(29017089,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCountLimit(1,29017090)
	e3:SetTarget(c29017089.drtg)
	e3:SetOperation(c29017089.drop)
	c:RegisterEffect(e3)
	--to grave
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(29017089,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetCountLimit(1,29017091)
	e4:SetTarget(c29017089.tgtg)
	e4:SetOperation(c29017089.tgop)
	c:RegisterEffect(e4)
end
function c29017089.tgfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
end
function c29017089.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,_,exc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c29017089.tgfilter,tp,LOCATION_DECK,0,1,exc) and c:GetFlagEffect(29017089)==0 end
	c:RegisterFlagEffect(29017089,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c29017089.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c29017089.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c29017089.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and c:GetFlagEffect(29017089)==0 end
	c:RegisterFlagEffect(29017089,RESET_CHAIN,0,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c29017089.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c29017089.thfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function c29017089.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c29017089.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and c:GetFlagEffect(29017089)==0 end
	c:RegisterFlagEffect(29017089,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c29017089.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29017089.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29017089.cfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29017089.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29017089.cfilter,1,nil) and rp==tp
end