--画中人
function c82568020.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(82568020,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c82568020.cost1)
	e1:SetTarget(c82568020.target1)
	e1:SetOperation(c82568020.activate1)
	e1:SetCountLimit(1,82568020)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(82568020,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c82568020.cost2)
	e2:SetTarget(c82568020.target1)
	e2:SetOperation(c82568020.activate2)
	e2:SetCountLimit(1,82568020)
	c:RegisterEffect(e2)
	--Activate3
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(82568020,2))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c82568020.cost3)
	e3:SetTarget(c82568020.target1)
	e3:SetOperation(c82568020.activate3)
	e3:SetCountLimit(1,82568020)
	c:RegisterEffect(e3)
	--Activate4
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e4:SetDescription(aux.Stringid(82568020,3))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c82568020.cost4)
	e4:SetTarget(c82568020.target1)
	e4:SetOperation(c82568020.activate4)
	e4:SetCountLimit(1,82568020)
	c:RegisterEffect(e4)
	--add code
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_CODE)
	e5:SetValue(82567785)
	c:RegisterEffect(e5)
end
function c82568020.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) and Duel.IsExistingMatchingCard(c82568020.rtfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568020.rtfilter1(c,e,tp)
	return c:IsLevelBelow(6) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false)
end
function c82568020.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c82568020.activate1(e,tp,eg,ep,ev,re,r,rp,ft,lv)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c82568020.rtfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(82568020,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c82568020.descon)
		e1:SetOperation(c82568020.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c82568020.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c82568020.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(82568020)~=0
end
function c82568020.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function c82568020.splimit(e,c)
	return c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_EXTRA)
end
function c82568020.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) and Duel.IsExistingMatchingCard(c82568020.rtfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82568020.rtfilter2(c,e,tp)
	return c:IsLevelBelow(8) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false)
end
function c82568020.activate2(e,tp,eg,ep,ev,re,r,rp,ft,lv)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c82568020.rtfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(82568020,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c82568020.descon)
		e1:SetOperation(c82568020.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c82568020.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c82568020.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsCanRemoveCounter(tp,1,0,0x5825,3,REASON_COST) and Duel.IsExistingMatchingCard(c82568020.rtfilter3,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.RemoveCounter(tp,1,0,0x5825,3,REASON_COST)
end
function c82568020.rtfilter3(c,e,tp)
	return c:IsLevelBelow(10) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false)
end
function c82568020.activate3(e,tp,eg,ep,ev,re,r,rp,ft,lv)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c82568020.rtfilter3,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(82568020,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c82568020.descon)
		e1:SetOperation(c82568020.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c82568020.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c82568020.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and Duel.IsCanRemoveCounter(tp,1,0,0x5825,4,REASON_COST) and Duel.IsExistingMatchingCard(c82568020.rtfilter4,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.RemoveCounter(tp,1,0,0x5825,4,REASON_COST)
end
function c82568020.rtfilter4(c,e,tp)
	return c:IsLevelBelow(12) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,TYPE_RITUAL,tp,true,false)
end
function c82568020.activate4(e,tp,eg,ep,ev,re,r,rp,ft,lv)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c82568020.rtfilter4,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(82568020,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c82568020.descon)
		e1:SetOperation(c82568020.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c82568020.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end