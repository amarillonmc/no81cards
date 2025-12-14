--团团圆圆 黑色团子
function c62501126.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,62501126)
	e1:SetTarget(c62501126.sptg)
	e1:SetOperation(c62501126.spop)
	c:RegisterEffect(e1)
	--tango remove
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetOperation(c62501126.regop)
	c:RegisterEffect(e0)
end
function c62501126.cfilter(c,e)
	return c:IsSetCard(0xea1) and c:IsFaceupEx() and c:GetTextAttack()>0 and c:IsCanOverlay() and c:IsCanBeEffectTarget(e)
end
function c62501126.gcheck(g,e,tp)
	local atk=g:GetSum(Card.GetTextAttack)
	return Duel.IsExistingMatchingCard(c62501126.spfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,g,e,tp,atk)
end
function c62501126.spfilter(c,e,tp,atk)
	return c:IsSetCard(0xea1) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttack(atk) and (c:IsLocation(LOCATION_REMOVED) and c:IsFaceup() and Duel.GetMZoneCount(tp)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c62501126.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c62501126.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	if chk==0 then return g:CheckSubGroup(c62501126.gcheck,1,#g,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,c62501126.gcheck,false,1,#g,e,tp)
	Duel.HintSelection(sg)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_REMOVED)
end
function c62501126.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g~=0 then
		local atk=g:GetSum(Card.GetTextAttack)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c62501126.spfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp,atk):GetFirst()
		if sc then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			Duel.Overlay(sc,g)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c62501126.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c62501126.splimit(e,c)
	return not (c:IsLevel(1) or c:IsRank(1) or c:IsLink(1))
end
function c62501126.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
