--赤月巧壳 贝露
function c67200561.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destory
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200561,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200561)
	e1:SetCost(c67200561.descon)
	e1:SetTarget(c67200561.destg)
	e1:SetOperation(c67200561.desop)
	c:RegisterEffect(e1)
	--set p 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200561,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,67200562)
	e3:SetCondition(c67200561.pencon)
	e3:SetTarget(c67200561.pentg)
	e3:SetOperation(c67200561.penop)
	c:RegisterEffect(e3)   
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,67200563)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c67200561.spcon)
	e4:SetTarget(c67200561.sptg)
	e4:SetOperation(c67200561.spop)
	c:RegisterEffect(e4)	
end
function c67200561.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x676) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsSummonPlayer(tp)
end
function c67200561.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200561.cfilter,1,nil,tp)
end
function c67200561.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_LINK)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,ct+1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c67200561.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local ec=eg:GetFirst()
		if Duel.Draw(tp,ec:GetLink()+1,REASON_EFFECT)==0 then return end
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,ec:GetLink(),ec:GetLink(),nil)
		if ec:GetLink()>0 then
			if g:GetCount()>0 then
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end
--
function c67200561.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA)
end
function c67200561.penfilter(c)
	return c:IsSetCard(0x676) and c:IsType(TYPE_PENDULUM) and not c:IsCode(67200561) and not c:IsForbidden()
end
function c67200561.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200561.penfilter,tp,LOCATION_DECK,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c67200561.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c67200561.penfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--
function c67200561.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c67200561.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200561.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
