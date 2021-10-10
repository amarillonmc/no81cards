--雪境之盟
function c82567881.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,82567881),LOCATION_SZONE)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567881,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c82567881.condition)
	e4:SetOperation(c82567881.operation)
	c:RegisterEffect(e4)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567881,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c82567881.thcost)
	e2:SetCountLimit(1,82567881)
	e2:SetTarget(c82567881.thtg)
	e2:SetOperation(c82567881.thop)
	c:RegisterEffect(e2)
	 --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c82567881.sptg)
	e3:SetOperation(c82567881.spop)
	c:RegisterEffect(e3)
	--add setname
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetValue(0x825)
	c:RegisterEffect(e9)
end
function c82567881.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and (re:IsHasCategory(CATEGORY_ATKCHANGE) or re:IsHasCategory(CATEGORY_DEFCHANGE)) 
		and re:GetHandler()~=e:GetHandler() and e:GetHandler():GetFlagEffect(1)>0
end
function c82567881.operation(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x5825,1)
end
function c82567881.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x825) and c:IsAbleToHand() and c:IsFaceup()
end
function c82567881.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Card.IsCanRemoveCounter(c,tp,0x5825,2,REASON_COST) end
	Card.RemoveCounter(c,tp,0x5825,2,REASON_COST)
end
function c82567881.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567881.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c82567881.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82567881.thfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
function c82567881.filter(c,e,tp)
	return c:IsSetCard(0x5826) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82567881.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82567881.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c82567881.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567881.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
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
		e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e7:SetValue(1)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCode(EFFECT_UNRELEASABLE_SUM)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetValue(1)
		tc:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e5)
		 local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(82567881,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetCountLimit(1)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_CANNOT_DISABLE)
		e6:SetLabel(fid)
		e6:SetLabelObject(tc)
		e6:SetCondition(c82567881.tdcon)
		e6:SetOperation(c82567881.tdop)
		Duel.RegisterEffect(e6,tp)
end
function c82567881.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(82567881)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c82567881.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,2,REASON_EFFECT)
end