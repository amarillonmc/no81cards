--幽玄龙象※巽随霄岚
--21.07.25
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	--e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	cm.hand_effect=cm.hand_effect or {}
	cm.hand_effect[c]=e1
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451416,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g==g:FilterCount(Card.IsFacedown,nil)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.filter(c,tp)
	return (c:IsPosition(POS_FACEDOWN_DEFENSE) or (c:IsCanTurnSet() and not c:IsStatus(STATUS_BATTLE_DESTROYED))) and (c:GetSequence()<=4 or Duel.GetLocationCount(tp,LOCATION_MZONE)>1)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil,tp)) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil,tp)
	if b1 then g:Merge(g1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	g=g:Select(tp,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	if not tc:IsOnField() then
		g:AddCard(c)
		Duel.ConfirmCards(1-tp,g)
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
			Duel.ShuffleSetCard(g)
			if Duel.SelectYesNo(tp,aux.Stringid(11451619,0)) then Duel.SwapSequence(c,tc) end
		end
	elseif tc:GetSequence()<=4 then
		if tc:IsFaceup() then Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
			Duel.ConfirmCards(1-tp,c)
			g:AddCard(c)
			Duel.ShuffleSetCard(g)
			if Duel.SelectYesNo(tp,aux.Stringid(11451619,0)) then Duel.SwapSequence(c,tc) end
		end
	else
		if tc:IsFaceup() then Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
			Duel.ConfirmCards(1-tp,c)
			g:AddCard(c)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(tc,nseq)
			Duel.ShuffleSetCard(g)
			if Duel.SelectYesNo(tp,aux.Stringid(11451619,0)) then Duel.SwapSequence(c,tc) end
		end
	end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g1>0 and #g2>0 end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg1=g1:Select(tp,1,1,nil)
		local dg2=g2:Select(tp,1,1,nil)
		dg1:Merge(dg2)
		if dg1:GetCount()==2 then
			Duel.HintSelection(dg1)
			Duel.Destroy(dg1,REASON_EFFECT)
		end
	end
	if c:IsRelateToEffect(e) and c:GetColumnGroupCount()==0 then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(m,2))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetOperation(cm.ceop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.ceop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if ep~=tp and #g1>0 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.reop)
		e:Reset()
	end
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg1=g1:Select(tp,1,1,nil)
		local dg2=g2:Select(tp,1,1,nil)
		dg1:Merge(dg2)
		if dg1:GetCount()==2 then
			Duel.HintSelection(dg1)
			Duel.Destroy(dg1,REASON_EFFECT)
		end
	end
end