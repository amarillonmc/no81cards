--方舟骑士·歼灭者 迷迭香
function c82567867.initial_effect(c)
	--fusion
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(c82567867.fusionfilter1),aux.FilterBoolFunction(c82567867.fusionfilter2),1,true,true)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567867,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c82567867.tgcon0)
	e1:SetCountLimit(1,82567867)
	e1:SetCost(c82567867.tgcost)
	e1:SetTarget(c82567867.tgtg)
	e1:SetOperation(c82567867.tgop)
	c:RegisterEffect(e1)
	--to grave 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567867,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,82567867)
	e2:SetCondition(c82567867.tgcon)
	e2:SetCost(c82567867.tgcost)
	e2:SetTarget(c82567867.tgtg)
	e2:SetOperation(c82567867.tgop)
	c:RegisterEffect(e2)
	--sort decktop
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetDescription(aux.Stringid(82567867,1))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c82567867.cost)
	e3:SetCountLimit(1,82567967)
	e3:SetTarget(c82567867.target)
	e3:SetOperation(c82567867.operation)
	c:RegisterEffect(e3)
end
function c82567867.fusionfilter1(c)
	return c:IsFusionSetCard(0x825) and c:IsLevelAbove(5) and c:IsLocation(LOCATION_MZONE)
end 
function c82567867.fusionfilter2(c)
	return c:IsRace(RACE_PSYCHO)
end 
function c82567867.FRIENDfilter(c)
	return  (c:IsRace(RACE_SPELLCASTER) or c:IsRace(RACE_PSYCHO)) and c:IsFaceup()
end
function c82567867.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82567867.FRIENDfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c82567867.tgcon0(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c82567867.FRIENDfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c82567867.costfilter(c)
	return  c:IsAbleToRemoveAsCost()
end
function c82567867.tgfilter(c)
	return  c:IsAbleToGrave()
end
function c82567867.fselect(g,chk1,chk2)
	local sum=g:GetCount()
	if chk2 then
		return sum==1 or sum==2
	elseif chk1 then
		return sum==1
	end
	return false
end
function c82567867.gcheck(maxatk)
	return  function(g)
				return g:GetCount()<=maxatk
			end
end
function c82567867.atkchangerfilter(c)
	return  c:IsType(TYPE_MONSTER) and c:GetLevel()>0
end
function c82567867.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	local chk1=Duel.IsExistingTarget(c82567867.tgfilter,tp,0,LOCATION_ONFIELD,1,nil)
	local chk2=Duel.IsExistingTarget(c82567867.tgfilter,tp,0,LOCATION_ONFIELD,2,nil)
	local maxatk=1
	if chk2 then maxatk=2 end
	local g=Duel.GetMatchingGroup(c82567867.costfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	if chk==0 then
		if not chk1 then return false end
		aux.GCheckAdditional=c82567867.gcheck(maxatk)
		local res=g:CheckSubGroup(c82567867.fselect,1,#g,chk1,chk2)
		aux.GCheckAdditional=nil
		return res
	end
	aux.GCheckAdditional=c82567867.gcheck(maxatk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c82567867.fselect,false,1,#g,chk1,chk2)
	aux.GCheckAdditional=nil
	if sg:GetCount()==2 then
		e:SetLabel(100,2)
	else
		e:SetLabel(100,1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c82567867.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c82567867.tgfilter(chkc) end
	local check,ct=e:GetLabel()
	if chk==0 then
		e:SetLabel(0,0)
		if check~=100 then return false end
		return Duel.IsExistingTarget(c82567867.tgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	e:SetLabel(0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c82567867.tgfilter,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,LOCATION_ONFIELD)
end
function c82567867.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	if g:IsExists(c82567867.atkchangerfilter,1,nil) and e:GetHandler():IsRelateToEffect(e) then
		local lv=g:GetSum(Card.GetLevel)
		local val=lv*200
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	end
	end
end
function c82567867.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82567867.tdfilter(c)
	return  c:IsAbleToDeck()
end
function c82567867.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 and Duel.GetMatchingGroupCount(c82567867.tdfilter,tp,LOCATION_GRAVE,0,nil)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,LOCATION_GRAVE)
end
function c82567867.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>=2
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2
	if not b1 or not g1 then return end
	local td=Duel.GetMatchingGroup(c82567867.tdfilter,tp,LOCATION_GRAVE,0,nil)
	local tdf=td:RandomSelect(tp,2)
	if Duel.SendtoDeck(tdf,nil,0,REASON_EFFECT)~=0 then
	Duel.ConfirmCards(1-tp,tdf)
	Duel.SortDecktop(tp,tp,4)
end
end