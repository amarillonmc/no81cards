--主宰之怒 霸主
local s,id,o=GetID()
function s.initial_effect(c)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_MSET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(s.setcon1)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(s.setcon2)
	c:RegisterEffect(e4)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.postg1)
	e2:SetOperation(s.posop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.postg2)
	e3:SetOperation(s.posop2)
	c:RegisterEffect(e3)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_MSET)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(s.Target1)
	e5:SetOperation(s.activate1)
	c:RegisterEffect(e5)
end

function s.cfilter(c)
	return c:IsSetCard(0x9a31) and c:IsFaceup()
end
function s.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	if not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) then return end
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE)
end

function s.postg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function s.posop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function s.postg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsFacedown() and c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function s.posop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFacedown() then
		Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	end
end 

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x9a31) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
end
function s.Target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	end
end