--帷幄决者·暗阁魔女
function c74580816.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x745),1)
	c:EnableReviveLimit()
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74580816,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,74580816)
	e1:SetCondition(c74580816.seqcon)
	e1:SetTarget(c74580816.seqtg)
	e1:SetOperation(c74580816.seqop)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74580816,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,84580816)
	e2:SetTarget(c74580816.lctg)
	e2:SetOperation(c74580816.lcop)
	c:RegisterEffect(e2)
end
function c74580816.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c74580816.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c74580816.cfilter,1,nil,tp)
end
function c74580816.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c74580816.cfilter,nil,tp)
	if chkc then return e:GetHandler():IsLevelAbove(5) and chkc:IsLocation(LOCATION_MZONE) and c74580816.cfilter(chkc,tp,g) end
	if chk==0 then return Duel.IsExistingTarget(c74580816.cfilter,tp,LOCATION_MZONE,0,1,nil,tp,g) end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c74580816.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,g)
	end
end
function c74580816.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc,nseq)
end
function c74580816.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(5)
end
function c74580816.lctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c74580816.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c74580816.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c74580816.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c74580816.lcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and tc:GetLevel()>5 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-4)
		tc:RegisterEffect(e1)
		if tc:IsType(TYPE_RITUAL) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
