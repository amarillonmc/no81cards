--祭礼护庭骑士 蕾奥娜·罗萨
function c3072.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x851),aux.NonTuner(Card.IsSetCard,0x851),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3072,0))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c3072.ctcost)
	e3:SetTarget(c3072.cttg)
	e3:SetOperation(c3072.ctop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3072,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c3072.spcost)
	e4:SetTarget(c3072.sptg)
	e4:SetOperation(c3072.spop)
	c:RegisterEffect(e4)
end 
function c3072.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c3072.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cchkc:GetControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c3072.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp,PHASE_END,1) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c3072.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c3072.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function c3072.spfilter(c,e,tp)
	return c:IsSetCard(0x851) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3072.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	Duel.ConfirmDecktop(tp,3)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(tp,c3072.spfilter,1,1,nil,e,tp)
		g:Sub(sg)
		if sg:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end 
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end 
end
