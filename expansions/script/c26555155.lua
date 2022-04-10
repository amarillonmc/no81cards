--欧贝利斯克的使徒
function c26555155.initial_effect(c)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c26555155.splimit)
	c:RegisterEffect(e1)
	--cannot release
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetValue(c26555155.sumlimit)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26555155,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c26555155.thcost)
	e4:SetTarget(c26555155.thtg)
	e4:SetOperation(c26555155.thop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(26555155,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCost(c26555155.spcost)
	e5:SetTarget(c26555155.sptg)
	e5:SetOperation(c26555155.spop)
	c:RegisterEffect(e5)
end
function c26555155.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsCode(26555155)
end
function c26555155.sumlimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DIVINE)
end
function c26555155.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c26555155.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c26555155.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c26555155.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26555155.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c26555155.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		local c=e:GetHandler()
		local tc=tg:GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DECREASE_TRIBUTE)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,tc:GetCode()))
		e1:SetValue(0x1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,26555155+tc:GetCode(),RESET_PHASE+PHASE_END,0,1)
		if tc:IsCode(10000000,10000010,10000020,10000080) and Duel.GetFlagEffect(tp,26555155+tc:GetCode())==1 then
			--triple tribute(require 3 tributes, summon)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(26555155,3))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_LIMIT_SUMMON_PROC)
			e3:SetTargetRange(LOCATION_HAND,0)
			e3:SetCondition(c26555155.ttcon)
			e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,tc:GetCode()))
			e3:SetOperation(c26555155.ttop)
			e3:SetValue(SUMMON_TYPE_ADVANCE)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c26555155.ttfilter(c,tp)
	return c:IsCode(26555155) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function c26555155.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local tri=Duel.GetFlagEffect(tp,26555155+c:GetCode())
	if tri<3 then
		return minc<=3 and Duel.CheckTribute(c,3-tri)
	else
		return minc<=3 and Duel.GetMZoneCount(tp)>0
	end
end
function c26555155.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local tri=Duel.GetFlagEffect(tp,26555155+c:GetCode())
	if tri>=3 then return false end
	local g=Duel.SelectTribute(tp,c,3-tri,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c26555155.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_DIVINE) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c26555155.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26555155.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c26555155.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c26555155.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26555155.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
