--近心芽姬·日照再编
local s,id,o=GetID()
Duel.LoadScript("GearGal.lua")
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.mfilter(c) return c:IsFaceup() and c:IsSetCard(0x1449) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() end
function s.sfilter(c,e,tp) return c:IsSetCard(0x1449) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
function s.ngfilter(c) return c:IsFaceup() and c:IsSetCard(0x7449) end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,0,1,nil)
	local b=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
	if chk==0 then return a or b end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function s.move_mzone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD) local tc=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst() return tc and GearGal.PlaceAsContinuousSpell(tc,tp)
end
function s.move_szone(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) local tc=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp):GetFirst() return tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
end
function s.activate(e,tp)
	local a=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_MZONE,0,1,nil)
	local b=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
	local both=a and b and Duel.IsExistingMatchingCard(s.ngfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(GearGal.SpellZoneGearGalFilter,tp,LOCATION_SZONE,0,1,nil)
	local moved=false
	if both then local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2)) if op==0 then moved=s.move_mzone(tp) elseif op==1 then moved=s.move_szone(e,tp) else moved=s.move_mzone(tp) if moved then moved=s.move_szone(e,tp) or moved end end
	elseif a and b then local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1)) if op==0 then moved=s.move_mzone(tp) else moved=s.move_szone(e,tp) end
	elseif a then moved=s.move_mzone(tp) else moved=s.move_szone(e,tp) end
	if moved and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst() if tc then GearGal.NegateUntilEndPhase(tc,e:GetHandler()) end end
end
