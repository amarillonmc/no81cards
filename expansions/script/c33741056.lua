--近心芽姬·日冠庭
local s,id,o=GetID()
Duel.LoadScript("GearGal.lua")
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id+200)
	e3:SetCondition(s.reccon)
	e3:SetTarget(s.rectg)
	e3:SetOperation(s.recop)
	c:RegisterEffect(e3)
end
function s.thfilter(c) return c:IsSetCard(0x7449) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) end
function s.setfilter(c,att) return c:IsSetCard(0x1449) and c:IsType(TYPE_MONSTER) and c:IsLevel(4) and c:IsAttribute(att) and not c:IsForbidden() end
function s.activate(e,tp)
	if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst() if not tc or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 then return end Duel.ConfirmCards(1-tp,tc)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tc:GetAttribute()) or not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.ConfirmCards(1-tp,tc) Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD) local sc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc:GetAttribute()):GetFirst()
	if not sc then return end local fromdeck=sc:IsLocation(LOCATION_DECK)
	if GearGal.PlaceAsContinuousSpell(sc,tp) and fromdeck then
		local e1=Effect.CreateEffect(e:GetHandler()) e1:SetType(EFFECT_TYPE_SINGLE) e1:SetCode(EFFECT_DISABLE) e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END) sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler()) e2:SetType(EFFECT_TYPE_SINGLE) e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END) sc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler()) e3:SetType(EFFECT_TYPE_FIELD) e3:SetCode(EFFECT_CHANGE_DAMAGE) e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET) e3:SetTargetRange(0,1) e3:SetValue(s.damval) e3:SetReset(RESET_PHASE+PHASE_END) Duel.RegisterEffect(e3,tp)
	end
end
function s.damval(e,re,val,r,rp,rc) if bit.band(r,REASON_EFFECT)~=0 then return 0 end return val end
function s.spcon(e,tp) return Duel.GetTurnPlayer()~=tp and Duel.IsMainPhase() end
function s.spfilter(c,e,tp) return c:IsSetCard(0x1449) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON) local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp) Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_SZONE)
end
function s.matlimit(e,sc) return not (sc:IsSetCard(0x3449) or sc:IsSetCard(0x7449)) end
function s.spop(e,tp)
	local tc=Duel.GetFirstTarget() if not tc or not tc:IsRelateToEffect(e) or Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	for _,code in ipairs({EFFECT_CANNOT_BE_FUSION_MATERIAL,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,EFFECT_CANNOT_BE_XYZ_MATERIAL,EFFECT_CANNOT_BE_LINK_MATERIAL}) do local ex=Effect.CreateEffect(e:GetHandler()) ex:SetType(EFFECT_TYPE_SINGLE) ex:SetCode(code) ex:SetValue(s.matlimit) ex:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END) tc:RegisterEffect(ex) end
end
function s.evfilter(c) return (c:IsLocation(LOCATION_SZONE) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()) or (c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_SZONE) and c:IsSummonType(SUMMON_TYPE_SPECIAL)) end
function s.reccon(e,tp,eg) return eg:IsExists(s.evfilter,1,nil) end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return true end Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800) end
function s.recop(e,tp) Duel.Recover(tp,800,REASON_EFFECT) end
