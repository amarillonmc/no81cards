--幽玄龙象※兑占盈亏
--21.07.27
local m=11451612
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	cm.hand_effect=e1
	--shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.shcon)
	e2:SetTarget(cm.shtg)
	e2:SetOperation(cm.shop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	return #g>0 and #g==g:FilterCount(Card.IsFacedown,nil)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3978) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g==0 then return end
	local tc=g:GetFirst()
	g:AddCard(c)
	Duel.ConfirmCards(1-tp,g)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		Duel.ShuffleSetCard(g)
		if Duel.SelectYesNo(tp,aux.Stringid(11451619,0)) then Duel.SwapSequence(c,tc) end
	end
	if not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,1,nil) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	--Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e2:SetLabelObject(e1)
	--Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetOperation(cm.adjustop)
	e3:SetLabelObject(e2)
	e3:SetOwnerPlayer(tp)
	--Duel.RegisterEffect(e3,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return sumpos&POS_FACEUP>0
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,1,nil) then
		local te=e:GetLabelObject()
		if te~=nil and aux.GetValueType(te)=="Effect" then
			local te2=te:GetLabelObject()
			if te2~=nil and aux.GetValueType(te2)=="Effect" then te2:Reset() end
			te:Reset()
		end
		e:Reset()
	end
end
function cm.shcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEDOWN) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.filter(c)
	return (c:IsPosition(POS_FACEDOWN_DEFENSE) or c:IsCanTurnSet()) and c:GetSequence()<=4
end
function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	local p,ph=Duel.GetTurnPlayer(),Duel.GetCurrentPhase()
	e:SetLabel(p,ph)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if p~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) then
		e:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,sg,1,0,0)
	end
end
function cm.filter2(c,e)
	return (c:IsPosition(POS_FACEDOWN_DEFENSE) or c:IsCanTurnSet()) and c:GetSequence()<=4 and not c:IsImmuneToEffect(e)
end
function cm.ctfilter(c,e)
	return (c:IsPosition(POS_FACEDOWN_DEFENSE) or c:IsCanTurnSet()) and c:IsControlerCanBeChanged() and not c:IsImmuneToEffect(e)
end
function cm.mzfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() and c:IsControler(tp) and c:GetSequence()<=4
end
function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,0,nil,e)
	if #g==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not (c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) then return end
	local dg=g:Filter(Card.IsFaceup,nil)
	if #dg>0 then
		for tc in aux.Next(dg) do
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			tc:ClearEffectRelation()
		end
	end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	Duel.ConfirmCards(1-tp,c)
	g:AddCard(c)
	local p,ph=e:GetLabel()
	local sg=Duel.GetMatchingGroup(cm.ctfilter,tp,0,LOCATION_MZONE,nil,e)
	if p~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		local rc=rg:GetFirst()
		if rc:IsFaceup() then
			Duel.ChangePosition(rc,POS_FACEDOWN_DEFENSE)
			rc:ClearEffectRelation()
		end
		if Duel.GetControl(rg,tp) then g:AddCard(rc) end
	end
	g=g:Filter(cm.mzfilter,nil,tp)
	Duel.ShuffleSetCard(g)
	if #g<2 then return end
	for i=1,10 do
		if not Duel.SelectYesNo(tp,aux.Stringid(11451619,1)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451619,2))
		local wg=g:Select(tp,2,2,nil)
		Duel.SwapSequence(wg:GetFirst(),wg:GetNext())
	end
end