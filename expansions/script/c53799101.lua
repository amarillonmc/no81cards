local m=53799101
local cm=_G["c"..m]
cm.name="奈芙提斯之化凰神"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DRAW_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.drcost)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_RELEASE)
	e2:SetOperation(cm.regop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetOperation(cm.regop2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetHintTiming(TIMING_DRAW_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,m+1)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x11f) or re:GetActivateLocation()~=LOCATION_GRAVE 
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.actlimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x11f) and re:GetActivateLocation()==LOCATION_GRAVE 
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g>0 then
		local dct=Duel.Destroy(g,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		local hct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if og:IsExists(Card.IsSetCard,2,nil,0x11f) and ct>0 then
			Duel.BreakEffect()
			local ect=0
			if hct+ct<dct then ect=ct
			else ect=dct-hct end
			Duel.Draw(tp,ect,REASON_EFFECT)
		end
	end
end
function cm.regop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_EFFECT) then
		c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function cm.desfilter(c)
	return c:IsSetCard(0x11f) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_DECK))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m+1)~=0 and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) end
end
function cm.fselect(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
		and g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)<=1
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:SelectSubGroup(tp,cm.fselect,false,1,3)
		local ct=Duel.Destroy(sg,REASON_EFFECT)
		local th=c:IsAbleToHand()
		local sp=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		if ct>0 and (th or sp) then
			local op=0
			if th and sp then op=Duel.SelectOption(tp,1190,1152)
			elseif th then op=0
			else op=1 end
			if op==0 then
				Duel.SendtoHand(c,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,c)
			else
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
			local fg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			if ct==3 and #fg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local tgg=fg:Select(tp,1,1,nil)
				Duel.SendtoGrave(tgg,REASON_EFFECT)
			end
		end
	end
end
