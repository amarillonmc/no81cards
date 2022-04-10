--深层幻夜 恶魇
function c64800123.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,64800123+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c64800123.spcon)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64800123,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,64810123)
	e3:SetCost(c64800123.spcost)
	e3:SetTarget(c64800123.sptg)
	e3:SetOperation(c64800123.spop)
	c:RegisterEffect(e3)
end

--e1
function c64800123.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)==1
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

--e3
function c64800123.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c64800123.spfilter2(c,e,tp,lv)
	local lv2=c:GetLevel()
	return c:IsSetCard(0x341a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and lv+lv2==5
end
function c64800123.spfilter(c,e,tp)
	local lv=c:GetLevel()
	return lv<5 and c:IsSetCard(0x341a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c64800123.spfilter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,c,e,tp,lv)
end
function c64800123.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetMZoneCount(tp,e:GetHandler())>1
		and Duel.IsExistingMatchingCard(c64800123.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)) or Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	if not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function c64800123.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c64800123.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if tc then 
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c64800123.spfilter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,tc,e,tp,lv) 
		g1:Merge(g2)
		if g1:GetCount()==2 then
			Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end