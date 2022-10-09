--珊海环的领主 博鲁哈
function c67200525.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200525,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c67200525.eqtg)
	e1:SetOperation(c67200525.eqop)
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2) 
	--spsummon and to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200525,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,67200525)
	e3:SetCondition(c67200525.spcon)
	e3:SetTarget(c67200525.sptg)
	e3:SetOperation(c67200525.spop)
	c:RegisterEffect(e3)	
end
--
function c67200525.filter(c,ec)
	return c:IsCode(67200526) and c:CheckEquipTarget(ec)
end
function c67200525.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c67200525.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c67200525.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67200525.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	if g:GetCount()>0 then
		Duel.Equip(tp,g:GetFirst(),c)
	end
end
--
function c67200525.spfilter(c,e,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x675) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c67200525.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200525.spfilter,1,nil,e,tp)
end
function c67200525.spfilter1(c,e,tp)
	return not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c67200525.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>eg:GetCount() and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and not eg:IsExists(c67200525.spfilter1,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	local gg=Group.CreateGroup()
	gg:AddCard(c)
	gg:AddCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,gg,0,0)
end
function c67200525.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gg=Group.CreateGroup()
	gg:AddCard(c)
	gg:AddCard(eg)
	if c:IsRelateToEffect(e) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.SpecialSummon(gg,0,tp,tp,false,false,POS_FACEUP)
	end
end

