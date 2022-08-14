--燃煤概念机 纽可门
local s,id,o=GetID()
Duel.LoadScript("c64800150.lua")
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	RMJ_02.des1(c,id)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id+10000)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsm from deck+hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,id+20000)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.tkcost)
	e3:SetTarget(s.tktg)
	e3:SetOperation(s.tkop)
	c:RegisterEffect(e3)
end

--e1e2
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(RMJ_02.pf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	local g1=Duel.GetMatchingGroup(RMJ_02.pf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(RMJ_02.pf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)<=0
		or Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,RMJ_02.pf,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.Destroy(g1,REASON_EFFECT)
end

--e3
function s.rmf0(c,e,tp)
	return RMJ_02.rmf(c) and Duel.IsExistingMatchingCard(s.rmf1,tp,LOCATION_EXTRA,0,1,c,e,tp,c)
end
function s.rmf1(c,e,tp,rc1)
	return RMJ_02.rmf(c) and Duel.IsExistingMatchingCard(s.rmf2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,rc1,c)
end
function s.rmf2(c,e,tp,rc1,rc2)
	return c:IsSetCard(0x541a) and not (c:IsCode(rc1:GetCode()) or c:IsCode(rc2:GetCode())) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spf(c,e,tp,code1,code2)
	return c:IsSetCard(0x541a) and not (c:IsCode(code1) or c:IsCode(code2)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmf0,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,s.rmf0,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local rc1=g1:GetFirst()
	local g2=Duel.SelectMatchingCard(tp,s.rmf1,tp,LOCATION_EXTRA,0,1,1,rc1,e,tp,rc1)
	local rc2=g2:GetFirst()
	e:SetLabel(rc1:GetCode(),rc2:GetCode())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local x,y=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(s.spf,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,x,y) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spf,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,x,y)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKSHF)
		tc:RegisterEffect(e1)
	end
end
