--近心芽姬·群落 日轮
local s,id,o=GetID()
Duel.LoadScript("GearGal.lua")
function s.initial_effect(c)
	aux.AddLinkProcedure(c,s.matfilter,2,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+200)
	e3:SetCondition(s.retcon)
	e3:SetTarget(s.rettg)
	e3:SetOperation(s.retop)
	c:RegisterEffect(e3)
end
function s.matfilter(c) return c:IsLinkSetCard(0x7449) or c:IsLinkSetCard(0x1449) end
function s.thcon(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end
function s.stfilter(c) return c:IsSetCard(0x7449) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() end
function s.setfilter(c) return c:IsSetCard(0x1449) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_DECK,0,1,nil) or (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,nil)) end Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) end
function s.thop(e,tp)
	local a=Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_DECK,0,1,nil) local b=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,nil) if not a and not b then return end
	local op=(a and b) and Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4)) or (a and 0 or 1)
	if op==0 then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) local g=Duel.SelectMatchingCard(tp,s.stfilter,tp,LOCATION_DECK,0,1,1,nil) if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,g) end
	else Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD) local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst() if tc then GearGal.PlaceAsContinuousSpell(tc,tp) end end
end
function s.discon(e,tp) return Duel.GetTurnPlayer()~=tp end
function s.costfilter(c) return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToGraveAsCost() end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_SZONE,0,1,nil) end Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_SZONE,0,1,1,nil):GetFirst() e:SetLabelObject(tc) Duel.SendtoGrave(tc,REASON_COST) end
function s.disfilter(c) return c:IsFaceup() and not c:IsDisabled() end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) if chkc then return chkc:IsOnField() and s.disfilter(chkc) end if chk==0 then return Duel.IsExistingTarget(s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE) Duel.SelectTarget(tp,s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) end
function s.disop(e,tp)
	local tc=Duel.GetFirstTarget() if tc and tc:IsRelateToEffect(e) then GearGal.NegateUntilEndPhase(tc,e:GetHandler()) end
	local sc=e:GetLabelObject() if sc and sc:IsSetCard(0x1449) then local e1=Effect.CreateEffect(e:GetHandler()) e1:SetDescription(aux.Stringid(id,1)) e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) e1:SetCode(EVENT_PHASE+PHASE_END) e1:SetCountLimit(1) e1:SetLabelObject(sc) e1:SetOperation(s.endop) e1:SetReset(RESET_PHASE+PHASE_END) Duel.RegisterEffect(e1,tp) end
end
function s.endop(e,tp) local tc=e:GetLabelObject() if tc and tc:IsLocation(LOCATION_GRAVE) then GearGal.PlaceAsContinuousSpell(tc,tp) end end
function s.retcon(e,tp,eg,ep,ev,re,r,rp) local c=e:GetHandler() return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetReasonPlayer()~=tp end
function s.retfilter(c) return c:IsSetCard(0x7449) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.retfilter(chkc) end if chk==0 then return Duel.IsExistingTarget(s.retfilter,tp,LOCATION_GRAVE,0,1,nil) end Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) local g=Duel.SelectTarget(tp,s.retfilter,tp,LOCATION_GRAVE,0,1,1,nil) Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE) end
function s.retop(e,tp) local tc=Duel.GetFirstTarget() if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then local fid=tc:GetFieldID() local e1=Effect.CreateEffect(e:GetHandler()) e1:SetType(EFFECT_TYPE_FIELD) e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON) e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET) e1:SetTargetRange(1,0) e1:SetLabel(fid) e1:SetTarget(s.splimit) e1:SetReset(RESET_PHASE+PHASE_END) Duel.RegisterEffect(e1,tp) end end
function s.splimit(e,c) return c:GetFieldID()==e:GetLabel() end
