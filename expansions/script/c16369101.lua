--终焉数码兽 究极骑士奥米加兽
function c16369101.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,50218139,50218140,true,true)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16369101)
	e1:SetTarget(c16369101.target)
	e1:SetOperation(c16369101.operation)
	c:RegisterEffect(e1)
	--chaining
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c16369101.chcon)
	e2:SetTarget(c16369101.chtg)
	e2:SetOperation(c16369101.chop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(c16369101.thtg)
	e3:SetOperation(c16369101.thop)
	c:RegisterEffect(e3)
end
function c16369101.pfilter(c,tp)
	return c:IsCode(16369111,16369113) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c16369101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c16369101.pfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c16369101.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16369101.pfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function c16369101.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsCode(16369111,16369113)
end
function c16369101.chfilter1(c,e,tp)
	return c:IsSetCard(0xcb1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,nil)>0
end
function c16369101.chfilter2(c)
	return c:IsSetCard(0xcb1) and c:IsType(0x6) and c:IsAbleToHand()
end
function c16369101.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c16369101.chfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,16369101)==0
	local b2=Duel.IsExistingMatchingCard(c16369101.chfilter2,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,16369102)==0
	if chk==0 then return b1 or b2 end
end
function c16369101.chop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c16369101.chfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetFlagEffect(tp,16369101)==0
	local b2=Duel.IsExistingMatchingCard(c16369101.chfilter2,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,16369102)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(16369101,1),aux.Stringid(16369101,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(16369101,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(16369101,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c16369101.chfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,16369101,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c16369101.chfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		Duel.RegisterFlagEffect(tp,16369102,RESET_PHASE+PHASE_END,0,1)
	end
end
function c16369101.thfilter(c)
	return c:IsCode(16369115) and c:IsAbleToHand()
end
function c16369101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c16369101.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16369101.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end