--彷徨于深层幻夜的旅者
function c64800124.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64800124,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,64800124)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c64800124.target)
	e1:SetOperation(c64800124.operation)
	c:RegisterEffect(e1)
	--synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64800124,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,64810124)
	e3:SetTarget(c64800124.sytg)
	e3:SetOperation(c64800124.syop)
	c:RegisterEffect(e3)
end


--e1
function c64800124.spfilter(c)
	return c:IsSetCard(0x341a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c64800124.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
		or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	if not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c64800124.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hc=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if hc:GetCount()>=2 then 
		Duel.DiscardHand(tp,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD)
	end
	if hc:GetCount()==1 then 
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
	if hc:GetCount()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c64800124.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c64800124.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then 
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

--e2
function c64800124.sytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c64800124.syop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TUNER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(TYPE_TUNER)
			tc:RegisterEffect(e1)
	else
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(TYPE_TUNER)
			tc:RegisterEffect(e2)
	end
end