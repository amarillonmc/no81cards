--防护型神威骑士
function c24501023.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(TIMING_DRAW_PHASE,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,24501023)
	e1:SetCondition(c24501023.spcon)
	e1:SetTarget(c24501023.sptg)
	e1:SetOperation(c24501023.spop)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24501023,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) --修改：将效果类型改为EFFECT_TYPE_QUICK_O
	e2:SetCode(EVENT_FREE_CHAIN) --修改：添加触发事件代码
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,24501024)
	e2:SetTarget(c24501023.sptg2)
	e2:SetOperation(c24501023.spop2)
	c:RegisterEffect(e2)
end
--1
function c24501023.spfilter(c)
	return c:IsSetCard(0x501) and not c:IsCode(24501023) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
end
function c24501023.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24501023.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c24501023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c24501023.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function c24501023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e)
		and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- Change position
		if Duel.IsExistingMatchingCard(c24501023.posfilter,tp,0,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(24501023,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local tg=Duel.SelectMatchingCard(tp,c24501023.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
			Duel.HintSelection(tg)
			Duel.ChangePosition(tg:GetFirst(),POS_FACEUP_DEFENSE)
		end
	end
end
--2
function c24501023.spfilter2(c,e,tp)
	return c:IsSetCard(0x501) and not c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c24501023.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c24501023.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c24501023.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c24501023.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c24501023.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end