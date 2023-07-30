--魔 骸 霸 王
local m=22348290
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22348290)
	e1:SetCondition(c22348290.spcon)
	e1:SetTarget(c22348290.sptg)
	e1:SetOperation(c22348290.spop)
	c:RegisterEffect(e1)
	--dd
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22348290.ddtg)
	e2:SetOperation(c22348290.ddop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348290,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c22348290.dscon)
	e3:SetTarget(c22348290.dstg)
	e3:SetOperation(c22348290.dsop)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c22348290.descon2)
	e4:SetOperation(c22348290.desop2)
	c:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(c22348290.checkop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetOperation(c22348290.desop)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	if not c22348290.global_c then
		c22348290.global_c=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_DESTROYED)
		ge:SetOperation(c22348290.checkop1)
		Duel.RegisterEffect(ge,0)
	end
	
end
function c22348290.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		 if tc:IsSetCard(0x70a6) and not tc:IsCode(22348290) then
			 Duel.RegisterFlagEffect(0,22348290,RESET_PHASE+PHASE_END,0,1)
			 Duel.RegisterFlagEffect(1,22348290,RESET_PHASE+PHASE_END,0,1)
		 end
		tc=eg:GetNext()
	end
end
function c22348290.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c22348290.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local g=e:GetHandler():GetCardTarget()
	local tg=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c22348290.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetCardTarget()
	local gc=Group.__band(eg,tg)
	return gc:GetCount()>0
end
function c22348290.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c22348290.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,22348290)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c22348290.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348290.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ccc=Duel.GetFlagEffect(tp,22348290)
	local ct=math.floor(ccc/3)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) and ct>0 and Duel.SelectYesNo(tp,aux.Stringid(22348290,2))then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			Duel.BreakEffect()
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
	end
end
function c22348290.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
end
function c22348290.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,c)
	local tc=g:GetFirst()
	while c:IsRelateToEffect(e) and tc do
		c:SetCardTarget(tc)
		tc=g:GetNext()
	end
end

function c22348290.dscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and not (c:IsReason(REASON_EFFECT) and rp==tp and re:IsActivated())
end
function c22348290.filter(c)
	return c:IsSetCard(0x70a6) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c22348290.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348290.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function c22348290.spfilter(c,e,tp)
	return c:IsSetCard(0x70a6) and not c:IsCode(22348290) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348290.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348290.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then Duel.ConfirmCards(1-tp,g)
		local tg=Duel.GetMatchingGroup(c22348290.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
			if #tg>0
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
			and Duel.SelectYesNo(tp,aux.Stringid(22348290,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			Duel.BreakEffect()
			local sg=tg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) end
		end
	end
end


