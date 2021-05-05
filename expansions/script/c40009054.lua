--狱炎之零点龙 德拉库玛
function c40009054.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),4)
	c:EnableReviveLimit()	
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009054,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c40009054.thcon)
	e2:SetCost(c40009054.cost)
	e2:SetTarget(c40009054.target)
	e2:SetOperation(c40009054.operation)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c40009054.sumsuc)
	c:RegisterEffect(e3)
end
function c40009054.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) then return end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c40009054.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c40009054.costfilter(c)
	return c:IsAbleToGraveAsCost()
end
function c40009054.costfilter1(c)
	return c:IsAbleToRemove()
end
function c40009054.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009054.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local rt=Duel.GetTargetCount(c40009054.costfilter1,tp,0,LOCATION_ONFIELD,POS_FACEDOWN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c40009054.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,rt,e:GetHandler())
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabel(cg:GetCount())
end
function c40009054.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c40009054.costfilter1,tp,0,LOCATION_ONFIELD,1,POS_FACEDOWN) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectTarget(tp,c40009054.costfilter1,tp,0,LOCATION_ONFIELD,ct,ct,POS_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,ct,0,0)
end
function c40009054.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
	end
end


