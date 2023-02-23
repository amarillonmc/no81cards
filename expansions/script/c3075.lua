--祭礼暗庭就职
function c3075.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c3075.spcost)
	e1:SetTarget(c3075.sptg)
	e1:SetOperation(c3075.spop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCost(c3075.spcost2)
	e2:SetTarget(c3075.sptg2)
	e2:SetOperation(c3075.spop2)
	c:RegisterEffect(e2)
end
function c3075.cfilter1(c,tp)
	return c:IsSetCard(0x1012) and c:IsAbleToGraveAsCost()
end
function c3075.cfilter2(c)
	return c:IsSetCard(0x1012) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c3075.filter(c,e,tp)
	return c:IsSetCard(0x1012) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c3075.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c3075.cfilter1,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(c3075.cfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c3075.cfilter1,tp,LOCATION_HAND,0,1,1,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c3075.cfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c)
	--[[g1:Merge(g2)]]--
	Duel.SendtoGrave(g1,REASON_COST)
	Duel.Remove(g2,POS_FACEUP,REASON_COST)
end
function c3075.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c3075.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c3075.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3075.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c3075.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c3075.costfilter(c,e,tp,tid,ec)
	return c:IsSetCard(0x1012) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c3075.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,tid,ec)
end
function c3075.spfilter(c,e,tp,tid,ec)
	return c:IsSetCard(0x1012) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsPreviousLocation(LOCATION_ONFIELD) 
		and c:GetTurnID()==tid and c~=ec and c:IsCanBeEffectTarget(e)
end
function c3075.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c3075.spfilter(chkc,e,tp,tid,c) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c3075.costfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,tid,c) 
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c3075.costfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp,tid,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tg=Duel.SelectTarget(tp,c3075.spfilter,tp,LOCATION_GRAVE,0,1,1,g:GetFirst(),e,tp,tid,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function c3075.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end