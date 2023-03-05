--曙龙祭司 诺缇瓦尔格
function c9910801.initial_effect(c)
	--to field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910801,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9910801.tfcon)
	e1:SetCost(c9910801.tfcost)
	e1:SetTarget(c9910801.tftg)
	e1:SetOperation(c9910801.tfop)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c9910801.rlcost)
	e2:SetOperation(c9910801.rlop)
	c:RegisterEffect(e2)
end
function c9910801.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c9910801.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c9910801.tffilter(c)
	return c:IsSetCard(0x6951) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9910801.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9910801.tffilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9910801.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<1 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9910801.tffilter,tp,LOCATION_DECK,0,1,ft,nil)
	if #g==0 then return end
	local ac=g:GetFirst()
	local bc=g:GetNext()
	if Duel.MoveToField(ac,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local res=bc and Duel.MoveToField(bc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		ac:RegisterEffect(e1)
		if res then
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			bc:RegisterEffect(e2)
		end
	end
end
function c9910801.tgfilter(c,tp)
	local rac=c:GetRace()
	local labels={Duel.GetFlagEffectLabel(tp,9910821)}
	local flag=0
	for i=1,#labels do flag=bit.bor(flag,labels[i]) end
	return bit.band(c:GetType(),0x81)==0x81 and c:IsRace(RACE_DRAGON+RACE_SEASERPENT+RACE_WYRM) and c:IsAbleToGraveAsCost()
		and bit.band(flag,rac)==0
end
function c9910801.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910801.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910801.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetRace())
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910801.rlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetCondition(c9910801.rlcon2)
	e1:SetOperation(c9910801.rlop2)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,9910821,0,0,1,e:GetLabel())
end
function c9910801.rlcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
		and Duel.IsExistingMatchingCard(Card.IsReleasable,1-tp,LOCATION_MZONE,0,1,nil,REASON_RULE)
end
function c9910801.rlop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910801)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,1-tp,LOCATION_MZONE,0,nil,REASON_RULE)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Release(sg,REASON_RULE)
	end
end
