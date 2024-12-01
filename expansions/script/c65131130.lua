--秘计螺旋 回响
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(TYPE_SPELL)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.discost)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.disfilter(c,e,tp)
	return c:IsSetCard(0x836) and c:GetFlagEffect(id)>0 and c:IsAbleToHand()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.disfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.disfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.disfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end
function s.spfilter(c,e,tp)
	if c:GetLevel()<4 then return false end
	local ct=math.floor(c:GetLevel()/4)
	return c:IsSetCard(0x836) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=ct and Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,ct,nil) and (c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local ct=math.floor(tc:GetLevel()/4)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>=ct and Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,ct,nil) then
		local sg=Duel.SelectMatchingCard(tp,Card.IsSSetable,tp,LOCATION_HAND,0,ct,ct,nil)
		if Duel.SSet(tp,sg,tp,false)==ct then
			if tc:IsType(TYPE_RITUAL) then
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			else
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end