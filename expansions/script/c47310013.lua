-- 怒符「愤怒的忌狼之面」
Duel.LoadScript('c47310000.lua')
local s,id=GetID()
function s.eff1(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsAbleToGrave()
end
function s.eqfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x3c10) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	g2:Merge(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g2,2,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		Duel.Recover(tp,600,REASON_EFFECT)
		Hnk.public(e:GetHandler(),id,tp)
	end
end
function s.initial_effect(c)
    s.eff1(c)
	Hata_no_Kokoro.steff2q(c,id)
end
