-- 恋爱头脑战-天才们
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddFusionProcCode2(c,12819100,12819105,true,true)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_EXTRA)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3a73))
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetValue(id)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.e4tg)
	e4:SetOperation(s.e4op)
	c:RegisterEffect(e4)
end
function s.e4filter(c,e,tp)
	return c:IsSetCard(0x3a73) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_ILLUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
	and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function s.e4thfilter(c)
	return c:IsSetCard(0x3a73) and c:IsAbleToHand()
end
function s.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.e4op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	if not c:IsRelateToEffect(e) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	local g1=Duel.GetMatchingGroup(s.e4filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	local b1=#g1>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.e4thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local b2=#g2>0
	if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local op=aux.SelectFromOptions(tp,{b1,1118},{b2,1190})
		if op==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g1:SelectSubGroup(tp,aux.drccheck,false,2,2)
			if #sg>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=g2:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end