--终焉邪魂 入魔邪龙 卡利特
function c30000033.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c30000033.spcon)
	e2:SetOperation(c30000033.spop)
	c:RegisterEffect(e2)
	--Set 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(30000033,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c30000033.cost)
	e3:SetCondition(c30000033.spcon1)
	e3:SetTarget(c30000033.target)
	e3:SetOperation(c30000033.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c30000033.spcon2)
	c:RegisterEffect(e4)
	--wudi
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(30000033,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c30000033.spcon1)
	e5:SetCost(c30000033.cost2)
	e5:SetOperation(c30000033.operation2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetCondition(c30000033.spcon2)
	c:RegisterEffect(e6)
	--Activate
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_REMOVE)
	e7:SetCountLimit(1,30000033)
	e7:SetCondition(c30000033.con0)
	e7:SetTarget(c30000033.target0)
	e7:SetOperation(c30000033.activate)
	c:RegisterEffect(e7)
end
function c30000033.con0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c30000033.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) and Duel.IsPlayerCanRemove(tp) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 then e:SetLabel(1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,2)
end
function c30000033.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==3 and Duel.IsPlayerCanRemove(p) then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local reg=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,tp,LOCATION_HAND,0,2,2,nil)
		Duel.Remove(reg,POS_FACEUP,REASON_EFFECT)
		if e:GetLabel()==1 and Duel.IsPlayerCanDraw(p,tp,1) and Duel.SelectYesNo(p,aux.Stringid(30000033,3)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

function c30000033.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() or Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 end
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 and Duel.SelectYesNo(tp,aux.Stringid(30000033,2)) then
		local mm=Group.CreateGroup()
	else
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	end
end
function c30000033.operation2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetValue(c30000033.effectfilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,30000033,RESET_PHASE+PHASE_END,0,1)
end
function c30000033.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandlerPlayer()==e:GetHandlerPlayer()
end
function c30000033.spcfil(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToRemoveAsCost()
end

function c30000033.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local count=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_GRAVE,0,c)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	return count==0 and rg:GetCount()>4 and rg:IsExists(c30000033.spcfil,1,nil,tp)
end

function c30000033.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,5,5,c)
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		local g1=Duel.SelectMatchingCard(tp,c30000033.spcfil,tp,LOCATION_MZONE,0,1,1,nil,tp)
		g1:AddCard(c)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,4,4,g1)
		g1:RemoveCard(c)
		g1:Merge(g2)
		sg:Merge(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end

function c30000033.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,30000010)
end
function c30000033.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,30000010)
end

function c30000033.filter2(c)
	return  c:IsAbleToRemoveAsCost() 
end

function c30000033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000033.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c30000033.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c30000033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end

function c30000033.thfilter(c)
	return c:IsDefenseBelow(2200) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand() 
end

function c30000033.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30000033.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end