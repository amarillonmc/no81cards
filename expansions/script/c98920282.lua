--黑蝎-奇袭的卡夫卡
function c98920282.initial_effect(c)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920282,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetTarget(c98920282.sptgd)
	e3:SetOperation(c98920282.spopd)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
--handes
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98920282,0))
	e6:SetCategory(CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCondition(c98920282.condition)
	e6:SetTarget(c98920282.target)
	e6:SetOperation(c98920282.operation)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCategory(CATEGORY_CONTROL+CATEGORY_TOGRAVE)
	e7:SetDescription(aux.Stringid(98920282,1))
	e7:SetTarget(c98920282.tgtg)
	e7:SetOperation(c98920282.tgop)
	c:RegisterEffect(e7)
end
function c98920282.spfilter(c,e,tp)
	return (c:IsSetCard(0x1a) or c:IsCode(76922029)) and not c:IsCode(98920282) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920282.sptgd(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920282.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920282.spopd(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920282.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local sc=g:GetFirst()
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
	end
end
function c98920282.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c98920282.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(ep,LOCATION_HAND,0)>0 end
end
function c98920282.operation(e,tp,eg,ep,ev,re,r,rp)
   local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
   Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(98920282,1))
   local sg=hg:Select(1-tp,1,1,nil)
   Duel.SendtoHand(sg,tp,REASON_EFFECT)
end
function c98920282.tgfilter(c)
	return c:IsSetCard(0x1a) and c:IsAbleToGrave()
end
function c98920282.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920282.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c98920282.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98920282.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920282.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		  local sg=Duel.SelectMatchingCard(tp,c98920282.dfilter,tp,0,LOCATION_MZONE,1,1,nil)
		  Duel.BreakEffect()
		  Duel.HintSelection(sg)
		  Duel.GetControl(sg,tp,PHASE_END,1)
	end
end
function c98920282.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsControlerCanBeChanged()
end