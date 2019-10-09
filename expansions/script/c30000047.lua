--终焉邪魂 感染者
function c30000047.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30000047,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,30000047)
	e1:SetCondition(c30000047.spcon1)
	e1:SetCost(c30000047.cost)
	e1:SetTarget(c30000047.rmtg)
	e1:SetOperation(c30000047.rmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c30000047.spcon2)
	c:RegisterEffect(e2)
	--set 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,30000048)
	e3:SetTarget(c30000047.drtg)
	e3:SetOperation(c30000047.drop)
	c:RegisterEffect(e3)
end

function c30000047.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,30000010)
end

function c30000047.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,30000010)
end
function c30000047.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() or Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 end
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 and Duel.SelectYesNo(tp,aux.Stringid(30000047,0)) then
		local mm=Group.CreateGroup()
	else
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	end
end

function c30000047.filter(c)
	return c:IsSetCard(0x920) and c:IsAbleToHand() and not c:IsCode(30000047)
end

function c30000047.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000047.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end


function c30000047.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c30000047.filter),tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c30000047.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c30000047.filter1(c,tp)
	return c:IsAbleToHand() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and not c:IsCode(30000047)
end

function c30000047.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 and Duel.SelectYesNo(tp,aux.Stringid(30000047,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c30000047.filter1),tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
end