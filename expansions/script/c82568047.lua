--潮汐血脉苏生
function c82568047.initial_effect(c)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c82568047.con)
	c:RegisterEffect(e2)
	--revive
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(82568047,0))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,82568047)
	e4:SetCost(c82568047.thcost)
	e4:SetTarget(c82568047.thtg)
	e4:SetOperation(c82568047.thop)
	c:RegisterEffect(e4)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,82568147)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c82568047.sptg)
	e3:SetOperation(c82568047.spop)
	c:RegisterEffect(e3)
end
function c82568047.akafilter(c,e,tp)
	return c:IsSetCard(0x9825) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82568047.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82568047.akafilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c82568047.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82568047.akafilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	if ct==0 then return end
	local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		 local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e7:SetValue(1)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		 local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(82568047,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetCountLimit(1)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_CANNOT_DISABLE)
		e6:SetLabel(fid)
		e6:SetLabelObject(tc)
		e6:SetCondition(c82568047.tdcon)
		e6:SetOperation(c82568047.tdop)
		Duel.RegisterEffect(e6,tp)
end
function c82568047.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(82568047)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c82568047.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
end
function c82568047.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568047.filter(c,e,tp)
	return  c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c82568047.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c82568047.filter(chkc,e,tp) end
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c82568047.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c82568047.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c82568047.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c82568047.wfilter(c)
	return  c:IsSetCard(0x825) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c82568047.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c82568047.wfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
