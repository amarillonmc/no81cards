--燃煤概念机 透平尼亚
local s,id,o=GetID()
Duel.LoadScript("c64800150.lua")
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	RMJ_02.des1(c,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id+10000)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+20000)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

--spsm from remove
function s.rmf(c,code)
	return RMJ_02.rmfe(c) and not c:IsCode(code) 
end
function s.spf(c,e,tp)
	return c:IsSetCard(0x541a) and Duel.IsExistingMatchingCard(s.rmf,tp,LOCATION_EXTRA,0,2,nil,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.spf(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.spf,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spf,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,LOCATION_EXTRA)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.rmf,tp,LOCATION_EXTRA,0,2,nil,tc:GetCode()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.rmf,tp,LOCATION_EXTRA,0,2,2,nil,tc:GetCode())
		if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==2 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--spsm from hand
function s.tef(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x541a)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tef,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local g=Duel.SelectMatchingCard(tp,s.tef,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_COST)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Damage(1-tp,1200,REASON_EFFECT)
	end
end
