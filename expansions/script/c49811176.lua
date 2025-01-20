--神星クリフォート セフィラアポク
function c49811176.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49811176,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,49811176+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c49811176.hspcon)
	e1:SetValue(c49811176.hspval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49811176,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,49811176)
	e2:SetTarget(c49811176.drtg)
	e2:SetOperation(c49811176.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c49811176.drcon)
	e3:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e3)
end
function c49811176.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c49811176.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c49811176.cfilter,tp,LOCATION_MZONE,0,nil)	
	for tc in aux.Next(g) do
		local seq=tc:GetSequence()
		if seq==5 or seq==6 then
			zone=zone|(1<<aux.MZoneSequence(seq))
		else
			if seq>0 then zone=zone|(1<<(seq-1)) end
			if seq<4 then zone=zone|(1<<(seq+1)) end
		end
	end
	local g2=Duel.GetMatchingGroup(c49811176.cfilter,tp,LOCATION_SZONE,0,nil)
	for tc in aux.Next(g2) do
		local seq=tc:GetSequence()
		zone=zone|(1<<aux.MZoneSequence(seq))
	end
	return zone
end
function c49811176.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c49811176.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c49811176.hspval(e,c)
	local tp=c:GetControler()
	return 0,c49811176.getzone(tp)
end
function c49811176.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c49811176.thfilter(c)
	return c:IsSetCard(0xaa,0xc4) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c49811176.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811176.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c49811176.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c49811176.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	--cannot be used as material
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c49811176.matlimit)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c49811176.matfilter(c,tp)
	return c:IsSetCard(0xaa,0xc4) and c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp)
end
function c49811176.matlimit(e,c)
	local face=c:GetColumnGroup()
	return face:IsExists(c49811176.matfilter,1,nil,e:GetHandlerPlayer())
end

--
function c49811176.costfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsReleasable() and (c:IsSetCard(0xaa) or c:IsSetCard(0xc4))
end
function c49811176.ngcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811176.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c49811176.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c49811176.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c49811176.distg)
	e1:SetLabel(TYPE_LINK)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c49811176.distg(e,c)
	return c:IsType(e:GetLabel())
end
