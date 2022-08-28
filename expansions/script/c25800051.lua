--海伦娜
function c25800051.initial_effect(c)
		--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800051,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c25800051.destg)
	e1:SetOperation(c25800051.desop)
	c:RegisterEffect(e1)

	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25800051,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,25800038)
	e3:SetTarget(c25800051.sptg2)
	e3:SetOperation(c25800051.spop2)
	c:RegisterEffect(e3)
end
function c25800051.check(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x211)
end
function c25800051.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil
		and (c25800051.check(Duel.GetAttacker(),tp) or c25800051.check(Duel.GetAttackTarget(),tp)) end
	if c25800051.check(Duel.GetAttacker(),tp) then
		Duel.SetTargetCard(Duel.GetAttackTarget())
	else
		Duel.SetTargetCard(Duel.GetAttacker())
	end
end
function c25800051.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
------2
function c25800051.spfilter2(c,e,tp)
	return c:IsSetCard(0x211) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c25800051.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c25800051.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c25800051.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c25800051.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
