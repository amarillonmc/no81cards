--自然大兜虫
function c9981089.initial_effect(c)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981089,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,99810890)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c9981089.lvcost)
	e2:SetOperation(c9981089.lvop)
	c:RegisterEffect(e2)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981089,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9981089)
	e2:SetCondition(c9981089.spcon)
	e2:SetTarget(c9981089.sptg)
	e2:SetOperation(c9981089.spop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981089.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981089.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981089,0))
end
function c9981089.costfilter(c,lv)
	return not c:IsLevel(lv) and c:IsLevelAbove(1) and c:IsSetCard(0x2a) and c:IsAbleToGraveAsCost()
end
function c9981089.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(c9981089.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9981089.costfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,lv)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c9981089.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981089,0))
end
function c9981089.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x2a)
end
function c9981089.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>0 and not g:IsExists(c9981089.cfilter,1,nil)
end
function c9981089.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9981089.spop(e,tp,eg,ep,ev,re,r,rp)
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