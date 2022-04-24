--暗调师 死亡潜艇
function c33200802.initial_effect(c)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1,33200802+EFFECT_COUNT_CODE_DUEL)
	e0:SetCondition(c33200802.spcon0)
	c:RegisterEffect(e0)
	--dark turner
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200802,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c33200802.chtg)
	e2:SetOperation(c33200802.chop)
	c:RegisterEffect(e2)
end

--e0
function c33200802.spfilter(c)
	return c:IsFaceup() and not (c:IsAttribute(ATTRIBUTE_DARK) or c:IsRace(RACE_MACHINE))
end
function c33200802.spcon0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c33200802.spfilter,tp,LOCATION_MZONE,0,1,nil)
end

--e2
function c33200802.filter(c,e,tp,lv1)
	local lv2=c:GetLevel()
	local lv3=lv1-lv2
	return lv3>0 and c:IsFaceup() and not c:IsType(TYPE_TUNER) and Duel.IsExistingMatchingCard(c33200802.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,lv3)
end
function c33200802.cfilter(c,e,lv3)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv3) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) 
end
function c33200802.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv1=e:GetHandler():GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33200802.filter(chkc,e,tp,lv1) end
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingTarget(c33200802.filter,tp,LOCATION_MZONE,0,1,nil,e,tp,lv1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33200802.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,lv1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33200802.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local lv1=c:GetLevel()
	local lv2=tc:GetLevel()
	if (lv1<=lv2 or Duel.GetMZoneCount(tp,e:GetHandler())<=0) then return end
	local lv3=lv1-lv2
	if Duel.SendtoGrave(tc,REASON_EFFECT) and Duel.SendtoGrave(c,REASON_EFFECT) and Duel.IsExistingMatchingCard(c33200802.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,lv3) then
		local sg=Duel.SelectMatchingCard(tp,c33200802.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,lv3)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end
