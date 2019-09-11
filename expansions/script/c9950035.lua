--⑨
function c9950035.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c9950035.slcon)
	e2:SetValue(4)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e3)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950035,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9950035.sctg)
	e1:SetOperation(c9950035.scop)
	c:RegisterEffect(e1)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9950035,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c9950035.setcon)
	e4:SetTarget(c9950035.settg)
	e4:SetOperation(c9950035.setop)
	c:RegisterEffect(e4)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c9950035.spcon)
	e3:SetTarget(c9950035.sptg)
	e3:SetOperation(c9950035.spop)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950035.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950035.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950035,3))
end
function c9950035.slcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler(),0xba1,0xba2,0xba3)
end
function c9950035.scfilter(c,pc)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xba1,0xba2,0xba3) and not c:IsForbidden()
		and c:GetLeftScale()~=pc:GetLeftScale()
end
function c9950035.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950035.scfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c9950035.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9950035,1))
	local g=Duel.SelectMatchingCard(tp,c9950035.scfilter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(tc:GetLeftScale())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(tc:GetRightScale())
		c:RegisterEffect(e2)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950035,3))
end
function c9950035.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c9950035.cfilter(c)
	return c:IsSetCard(0xba1,0xba2,0xba3) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c9950035.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950035.cfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9950035.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9950035.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950035,3))
	end
end
function c9950035.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_PZONE)
end
function c9950035.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xba1,0xba2,0xba3)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950035.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c9950035.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950035.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9950035.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if Duel.GetLocationCountFromEx(tp)>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950035,3))
	end
end
