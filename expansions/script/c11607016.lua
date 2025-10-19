--无色的璀璨原钻
function c11607016.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c11607016.ffilter,2,127,true)
    -- 加速同调
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11607016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(c11607016.spcon)
	e1:SetTarget(c11607016.sptg)
	e1:SetOperation(c11607016.spop)
	c:RegisterEffect(e1)
	-- 作为装备
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11607016,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,11607025)
	e2:SetTarget(c11607016.eqtg)
	e2:SetOperation(c11607016.eqop)
	c:RegisterEffect(e2)
end
--fusion material
function c11607016.ffilter(c,fc)
	return c:IsFusionSetCard(0x6225)
end
-- 1
function c11607016.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsMainPhase()
end
function c11607016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11607016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
-- 2
function c11607016.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsCode(11607018) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,11607018) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,11607018)
end
function c11607016.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		if Duel.Equip(tp,c,tc) then
		    local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_EQUIP_LIMIT)
		    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		    e1:SetValue(c11607016.eqlimit)
		    e1:SetLabelObject(tc)
		    c:RegisterEffect(e1)
		    local e2=Effect.CreateEffect(c)
		    e2:SetType(EFFECT_TYPE_EQUIP)
		    e2:SetCode(EFFECT_EXTRA_ATTACK)
		    e2:SetValue(1)
		    c:RegisterEffect(e2)
		    aux.SetUnionState(c)
        end
	end
end
function c11607016.eqlimit(e,c)
	return c==e:GetLabelObject()
end
