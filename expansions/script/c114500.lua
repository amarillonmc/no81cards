--里械仪者·天仪剑
local m = 114500
local cm = _G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--pos 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.poscon)
	e1:SetCost(cm.poscost)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
	return c:GetSummonLocation() & LOCATION_EXTRA ~= 0 and c:GetSummonPlayer() ~= tp 
end
function cm.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.resfilter(c,rc)
	return c:IsType(TYPE_FLIP) and Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,Group.FromCards(c,rc))
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then 
		if e:GetLabel() ~= 100 then
			return Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		else
			e:SetLabel(0)
			return c:IsReleasable() and Duel.CheckReleaseGroupEx(tp,cm.resfilter,1,c,c)
		end
	end
	if e:GetLabel() == 100 then
		local rg = Duel.SelectReleaseGroupEx(tp,cm.resfilter,1,1,c,c)
		rg:AddCard(c)   
		Duel.Release(rg,REASON_COST)  
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,PLAYER_ALL,LOCATION_MZONE)
end
function cm.posop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g = Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g > 0 then
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function cm.thfilter(c)
	return c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g > 0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
