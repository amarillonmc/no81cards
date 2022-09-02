--绘舞华·绯梦之樱术使 RK1
--21.06.22
local m=11451578
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,11451581)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetValue(11451480)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.rkup={11451579}
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	for tc in aux.Next(eg) do
		local te=tc:GetReasonEffect()
		if te and (te:GetHandler():IsSetCard(0x97f) or te:GetValue()==11451480) and tc:IsReason(REASON_EFFECT) then return end
		if tc:GetReasonPlayer()==0 and tc:GetOwner()==0 then
			g1:AddCard(tc)
		elseif tc:GetReasonPlayer()==1 and tc:GetOwner()==1 then
			g2:AddCard(tc)
		end
	end
	if #g1>0 then Duel.RaiseEvent(g1,EVENT_CUSTOM+m,re,r,rp,0,0) end
	if #g2>0 then Duel.RaiseEvent(g2,EVENT_CUSTOM+m,re,r,rp,1,0) end
end
function cm.thfilter(c,e,tp)
	return c:GetOriginalType()&0x1~=0 and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	--local tg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):GetMinGroup(Card.GetSequence):Filter(Card.IsCanOverlay,nil)
	local tg=eg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(Card.IsCanOverlay,nil)
	local b1=e:GetHandler():IsType(TYPE_XYZ) and #tg>0 and Duel.IsPlayerCanDiscardDeck(tp,1)
	local b2=e:GetHandler():GetOverlayGroup():IsExists(cm.thfilter,1,nil,e,1-tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,3))+2
	end
	if op==1 then
		e:SetCategory(CATEGORY_DECKDES)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tg,#tg,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	else
		e:SetCategory(0)
	end
	e:SetLabel(op)
end
function cm.matfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		--local tg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):GetMinGroup(Card.GetSequence):Filter(cm.matfilter,nil,e)
		local tg=eg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(cm.matfilter,nil,e)
		if #tg==0 or not c:IsRelateToEffect(e) then return end
		Duel.Overlay(c,tg)
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
	elseif e:GetLabel()==2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
		if not c:IsRelateToEffect(e) then return end
		local g=e:GetHandler():GetOverlayGroup():FilterSelect(1-tp,cm.thfilter,1,1,nil,e,1-tp)
		local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		local tc=g:GetFirst()
		if tc then
			if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,1-tp,false,false) or ft<=0 or Duel.SelectOption(1-tp,1190,1152)==0) then
				Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
				Duel.ConfirmCards(tp,tc)
			else
				Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
			end
		end
	end
end
function cm.filter3(c,tp)
	return c:IsCode(11451581) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=3
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter3),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	Duel.ResetFlagEffect(tp,15248873)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter3),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end