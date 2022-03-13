local m=189100
local cm=_G["c"..m]
cm.name="灰烬机兵最终完成兵器-菲普鲁特斯"
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xca6),10,2,nil,nil,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.thfilter(c)
	return c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local g1=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	local b2=#g1>0 and #g2>0
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and (b1 or b2) end
	local ct=0
	if b1 then ct=c:RemoveOverlayCard(tp,1,c:GetOverlayCount(),REASON_COST) elseif b2 then ct=c:RemoveOverlayCard(tp,1,math.min(#g1,#g2,c:GetOverlayCount()),REASON_COST) end
	local op=0
	if ct>math.min(#g1,#g2) then op=Duel.SelectOption(tp,aux.Stringid(m,0)) else if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1)) elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,0)) else op=Duel.SelectOption(tp,aux.Stringid(m,1))+1 end end
	e:SetLabel(ct,op)
	if op==0 then
		e:SetDescription(aux.Stringid(m,2))
		e:SetCategory(CATEGORY_DESTROY)
		local g3=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)
		local g4=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g3,1,tp,LOCATION_REMOVED)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g4,1,0,0)
	else
		e:SetDescription(aux.Stringid(m,3))
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ct,op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,ct,nil)
		if #rg>0 and Duel.SendtoGrave(rg,REASON_EFFECT+REASON_RETURN)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
			if #dg>0 then
				Duel.HintSelection(dg)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,ct,ct,nil)
		if #hg>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,hg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local bg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,ct,ct,nil)
			if #bg>0 then Duel.Destroy(bg,REASON_EFFECT) end
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
	return c:GetOverlayCount()>0 and c:IsPreviousLocation(LOCATION_MZONE) and ((c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp) or c:IsReason(REASON_EFFECT+REASON_DESTROY))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=e:GetLabelObject():Filter(function(c,e,tp)return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)end,nil,e,tp)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(function(c,e,tp)return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)end,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or #g==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,ft,ft,nil)
	if #sg>0 then Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
end
