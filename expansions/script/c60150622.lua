--天夜 重生
function c60150622.initial_effect(c)
	c:SetUniqueOnField(1,0,60150622)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60150622.ffilter,aux.FilterBoolFunction(c60150622.ffilter2),false)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c60150622.splimit)
	c:RegisterEffect(e2)
	
	--battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150622,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1)
	e4:SetTarget(c60150622.sptg)
	e4:SetOperation(c60150622.spop)
	c:RegisterEffect(e4)
	--sum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(60150622,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,60150622)
	e6:SetCondition(c60150622.descon)
	e6:SetTarget(c60150622.destg)
	e6:SetOperation(c60150622.desop)
	c:RegisterEffect(e6)
end
function c60150622.ffilter(c)
	return c:IsSetCard(0x5b21) and c:IsType(TYPE_MONSTER)
end
function c60150622.ffilter2(c)
	return (c:IsSetCard(0x3b21) and c:IsAttribute(ATTRIBUTE_WATER)) or c:IsHasEffect(60150643)
end
function c60150622.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150622.filter(c,e,tp)
	return (c:IsSetCard(0x3b21) or c:IsSetCard(0x9b21)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c60150622.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60150622.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150622.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c60150622.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c60150622.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c60150622.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c60150622.cfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150622.gfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150622.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150622.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c60150622.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local g2=g:Filter(c60150622.gfilter,nil)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150618,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150618,1))
			local sg=g2:Select(tp,1,1,nil)
			local tc2=sg:GetFirst()
			while tc2 do
				if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
				tc2=sg:GetNext()
			end
			Duel.SendtoExtraP(sg,nil,REASON_COST)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150642,2))
			local sg=g:Select(tp,1,1,nil)
			local tc2=sg:GetFirst()
			while tc2 do
				if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
				tc2=sg:GetNext()
			end
			Duel.SendtoDeck(sg,nil,2,REASON_COST)
		end
	end
end
function c60150622.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150622.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,true,true) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_DEFENSE)
end