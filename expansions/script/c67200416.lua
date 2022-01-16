--术结天缘 敕封之维涅亚
function c67200416.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c) 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200416,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200416)
	e1:SetTarget(c67200416.thtg)
	e1:SetOperation(c67200416.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200416,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e2:SetCost(c67200416.spcost)
	e2:SetTarget(c67200416.sptg)
	e2:SetOperation(c67200416.spop)
	c:RegisterEffect(e2)  
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200416,2))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(c67200416.rmtg)
	e3:SetOperation(c67200416.rmop)
	c:RegisterEffect(e3)
	--to deck bottom
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67200416,3))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetTarget(c67200416.dttg)
	e5:SetOperation(c67200416.dtop)
	c:RegisterEffect(e5)	
end
function c67200416.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_SZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_SZONE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c67200416.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--
function c67200416.rfilter(c)
	return c:IsFaceup()
end
function c67200416.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c67200416.rfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200416.rfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c67200416.rfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c67200416.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(67200416,RESET_EVENT+RESET_TURN_SET+RESET_OVERLAY+RESET_MSCHANGE,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(67200416,5))
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetLabel(fid)
		e3:SetLabelObject(tc)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetOperation(c67200416.damop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c67200416.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not eg:IsContains(tc) then return end
	if tc:GetFlagEffectLabel(67200416)~=e:GetLabel() then
		e:Reset()
		return
	end
	Duel.Hint(HINT_CARD,0,67200416)
	Duel.Damage(tc:GetPreviousControler(),tc:GetBaseAttack(),REASON_EFFECT)
	tc:ResetFlagEffect(67200416)
	e:Reset()
end
--
function c67200416.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,9,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,9,REASON_COST)
end
function c67200416.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return ((c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200416.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--

--
function c67200416.dttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x5671) end
end
function c67200416.dtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200416,4))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x5671)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end



