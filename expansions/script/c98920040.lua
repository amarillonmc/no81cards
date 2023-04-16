--救祓少女·伊雷菲娅
function c98920040.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c98920040.mfilter,4,2)
	c:EnableReviveLimit()
 --indes effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(c98920040.indval)
	c:RegisterEffect(e4)
--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920040,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920040)
	e1:SetCost(c98920040.cost)
	e1:SetTarget(c98920040.sptg)
	e1:SetOperation(c98920040.spop)
	c:RegisterEffect(e1)
--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98920040+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c98920040.cost1)
	e2:SetCondition(c98920040.spcon2)
	e2:SetTarget(c98920040.sptg1)
	e2:SetOperation(c98920040.spop1)
	c:RegisterEffect(e2)
end
function c98920040.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c98920040.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp)))
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c98920040.mfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c98920040.indval(e,te,rp)
	return te:IsActivated() and te:GetHandler():IsSummonLocation(LOCATION_GRAVE)
end
function c98920040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920040.sspfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920040.sspfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c98920040.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingTarget(c98920040.sspfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c98920040.sspfilter1,tp,0,LOCATION_GRAVE,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c98920040.sspfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c98920040.sspfilter1,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,g1,2,0,0)
end
function c98920040.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
		tg:Sub(tg:Filter(Card.IsControler,nil,tp))
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)==0 then
		tg:Sub(tg:Filter(Card.IsControler,nil,1-tp))
	end
	if #tg>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if #tg>0 then
		local fid=e:GetHandler():GetFieldID()
		local tc=tg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		while tc do		 
			Duel.SpecialSummonStep(tc,0,tp,tc:GetOwner(),false,false,POS_FACEUP)
			tc:RegisterFlagEffect(98920040,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc=tg:GetNext()
		end
		Duel.SpecialSummonComplete()
		tg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tg)
		e1:SetCondition(c98920040.rmcon)
		e1:SetOperation(c98920040.rmop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c98920040.rmfilter(c,fid)
	return c:GetFlagEffectLabel(98920040)==fid
end
function c98920040.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c98920040.rmfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c98920040.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c98920040.rmfilter,nil,e:GetLabel())
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
end
function c98920040.spfilter1(c,e,tp)
	return c:IsCode(79858629) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c98920040.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function c98920040.spfilter2(c,e,tp)
	return c:IsCode(5352328) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920040.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920040.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c98920040.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c98920040.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c98920040.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end