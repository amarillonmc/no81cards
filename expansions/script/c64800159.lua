--燃煤大巡洋舰 强盛
local s,id,o=GetID()
Duel.LoadScript("c64800150.lua")
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_PENDULUM),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	RMJ_02.word(c)
	RMJ_02.pen(c,id)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
	--sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+10000)
	e3:SetCondition(s.rcon)
	e3:SetCost(s.cost)
	e3:SetOperation(s.rop)
	c:RegisterEffect(e3)
end

--e1
function s.cf(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function s.spf(c,e,tp)
	return c:IsSetCard(0x541a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cf,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.spf(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spf,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spf,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end

--e2
function s.val(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*-200
end

--e3
function s.rcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(RMJ_02.rmf,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,RMJ_02.rmf,tp,LOCATION_EXTRA,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,e:GetLabel()))
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_EVENT+RESET_CHAIN)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_EVENT+RESET_CHAIN)
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,1-tp)
end