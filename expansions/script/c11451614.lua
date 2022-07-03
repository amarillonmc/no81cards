--幽玄龙象※震辟洊雷
--21.09.21
local m=11451614
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
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.ptcon)
	e2:SetTarget(cm.pttg)
	e2:SetOperation(cm.ptop)
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
function cm.ptcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEDOWN) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.pttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #cg>0 end
	local p,ph=Duel.GetTurnPlayer(),Duel.GetCurrentPhase()
	e:SetLabel(p,ph)
	if p~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) then
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		e:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function cm.ptop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,nil)
	local p,ph=e:GetLabel()
	local ct=Duel.ChangePosition(cg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	if ct>0 and p~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end