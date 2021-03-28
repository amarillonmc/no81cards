--桃绯论武
function c9910529.initial_effect(c)
	aux.AddCodeList(c,9910507,9910515,9910527)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910529.target)
	e1:SetOperation(c9910529.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910529)
	e2:SetTarget(c9910529.thtg)
	e2:SetOperation(c9910529.thop)
	c:RegisterEffect(e2)
end
function c9910529.atkfilter(c)
	return c:IsSetCard(0xa950) and c:IsFaceup() and c:GetAttack()>c:GetBaseAttack()
end
function c9910529.atkfilter2(c,e)
	return c:IsSetCard(0xa950) and c:IsFaceup() and c:GetAttack()>c:GetBaseAttack()
		and not c:IsImmuneToEffect(e) and not c:IsHasEffect(EFFECT_REVERSE_UPDATE)
end
function c9910529.atkdiff(c,diff)
	return c:GetAttack()>=c:GetBaseAttack()+diff
end
function c9910529.filter2(c,e,tp,atkg)
	if bit.band(c:GetType(),0x81)~=0x81 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	return atkg:IsExists(c9910529.atkdiff,1,nil,c:GetLevel()*100)
end
function c9910529.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0xa950)
		local atkg=Duel.GetMatchingGroup(c9910529.atkfilter,tp,LOCATION_MZONE,0,nil)
		local b1=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,nil,e,tp,mg,nil,Card.GetLevel,"Greater")
		local b2=Duel.IsExistingMatchingCard(c9910529.filter2,tp,LOCATION_HAND,0,1,nil,e,tp,atkg)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910529.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsSetCard,nil,0xa950)
	local atkg=Duel.GetMatchingGroup(c9910529.atkfilter2,tp,LOCATION_MZONE,0,nil,e)
	local g1=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,nil,e,tp,mg,nil,Card.GetLevel,"Greater")
	local g2=Duel.GetMatchingGroup(c9910529.filter2,tp,LOCATION_HAND,0,nil,e,tp,atkg)
	g:Merge(g1)
	g:Merge(g2)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if g1:IsContains(tc) and (not g2:IsContains(tc) or Duel.SelectOption(tp,aux.Stringid(9910529,0),aux.Stringid(9910529,1))==0) then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local atkg2=atkg:FilterSelect(tp,c9910529.atkdiff,1,1,nil,tc:GetLevel()*100)
		if atkg2:GetCount()==0 then return end
		local sc=atkg2:GetFirst()
		local diff=math.abs(sc:GetBaseAttack()-sc:GetAttack())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-diff)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		tc:SetMaterial(nil)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c9910529.cfilter(c)
	return c:IsFaceup() and c:IsCode(9910507,9910515,9910527)
end
function c9910529.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910529.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910529.cfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9910529.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c9910529.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) and c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		end
	end
end
