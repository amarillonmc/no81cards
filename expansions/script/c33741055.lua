--近心芽姬·新芽 库洛依
local s,id,o=GetID()
Duel.LoadScript("GearGal.lua")
function s.initial_effect(c)
	GearGal.AddNearGalEffects(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp) return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0x1449) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp end
function s.condition(e,tp,eg,ep,ev,re,r,rp) return eg:IsExists(s.cfilter,1,nil,tp) end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,e:GetHandler():GetLocation()) end
function s.setfilter(c) return c:IsSetCard(0x1449) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevel(4) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() end
function s.operation(e,tp)
	local c=e:GetHandler() if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD) local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst() if tc then GearGal.PlaceAsContinuousSpell(tc,tp) end
	end
	local e1=Effect.CreateEffect(c) e1:SetType(EFFECT_TYPE_FIELD) e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET) e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) e1:SetTargetRange(1,0) e1:SetTarget(s.splimit) e1:SetReset(RESET_PHASE+PHASE_END) Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c) return c:IsLocation(LOCATION_EXTRA) and not (c:IsSetCard(0x3449) or c:IsSetCard(0x7449)) end
