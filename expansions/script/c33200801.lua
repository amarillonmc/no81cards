--暗调师 灾亡魔
function c33200801.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c33200801.spcon0)
	e0:SetOperation(c33200801.spop0)
	c:RegisterEffect(e0)
	--dark turner
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200801,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c33200801.chtg)
	e2:SetOperation(c33200801.chop)
	c:RegisterEffect(e2)
end

--e0
function c33200801.spfilter0(c)
	return c:IsAbleToRemoveAsCost()
end
function c33200801.spcon0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c33200801.spfilter0,tp,LOCATION_GRAVE,LOCATION_GRAVE,8,nil)
end
function c33200801.spop0(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c33200801.spfilter0,tp,LOCATION_GRAVE,LOCATION_GRAVE,8,8,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end

--e2
function c33200801.filter(c,e,tp,lv1)
	local lv2=c:GetLevel()
	local lv3=lv1-lv2
	return lv3>0 and c:IsFaceup() and not c:IsType(TYPE_TUNER) and Duel.IsExistingMatchingCard(c33200801.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,lv3)
end
function c33200801.cfilter(c,e,lv3)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv3) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) 
end
function c33200801.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv1=e:GetHandler():GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33200801.filter(chkc,e,tp,lv1) end
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingTarget(c33200801.filter,tp,LOCATION_MZONE,0,1,nil,e,tp,lv1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33200801.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,lv1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33200801.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local lv1=c:GetLevel()
	local lv2=tc:GetLevel()
	if (lv1<=lv2 or Duel.GetMZoneCount(tp,e:GetHandler())<=0) then return end
	local lv3=lv1-lv2
	if Duel.SendtoGrave(tc,REASON_EFFECT) and Duel.SendtoGrave(c,REASON_EFFECT) and Duel.IsExistingMatchingCard(c33200801.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,lv3) then
		local sg=Duel.SelectMatchingCard(tp,c33200801.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,lv3)
		if Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33200801,0)) then 
			local dsg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(dsg)
			Duel.Destroy(dsg,REASON_EFFECT)
		end
	end
end
