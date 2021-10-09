--光之国·超限赛罗
function c9951203.initial_effect(c)
	  --xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x9bd1),9,3)
	c:EnableReviveLimit()
 --remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951203,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9951203.remcon)
	e1:SetTarget(c9951203.remtg)
	e1:SetOperation(c9951203.remop)
	c:RegisterEffect(e1)
--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951203,4))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9951203)
	e1:SetCost(c9951203.cost)
	e1:SetTarget(c9951203.target)
	e1:SetOperation(c9951203.operation)
	c:RegisterEffect(e1)
 --material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9951203,5))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9951203.mttg)
	e4:SetOperation(c9951203.mtop)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951203.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951203.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951203,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951203,7))
end
function c9951203.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9951203.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9951203.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(9951203,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(9951203,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(9951203,3))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:RandomSelect(tp,1)
		sg:Merge(sg3)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c9951203.costfilter(c)
	return c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c9951203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951203.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local rt=Duel.GetTargetCount(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,c9951203.costfilter,tp,LOCATION_HAND,0,1,rt,nil)
	Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
	e:SetLabel(cg:GetCount())
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9951203.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tg=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,ct,0,0)
end
function c9951203.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then 
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951203,6))
end
function c9951203.mtfilter(c,e)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x9bd1) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function c9951203.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c9951203.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
end
function c9951203.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c9951203.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951203,6))
end