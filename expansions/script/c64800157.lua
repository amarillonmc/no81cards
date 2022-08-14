--燃煤机船 克拉蒙特
local s,id,o=GetID()
Duel.LoadScript("c64800150.lua")
function s.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	RMJ_02.word(c)
	RMJ_02.pen(c,id)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--spsm
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id+10000)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

--e1
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),0,0,0)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and re:GetHandler():IsFaceup() and re:GetHandler():IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(-1200)
		re:GetHandler():RegisterEffect(e1)
	end
end

--e2
function s.spf(c,e,tp)
	return c:IsSetCard(0x541a) and c:IsLevelBelow(6) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(RMJ_02.rmf,tp,LOCATION_EXTRA,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,RMJ_02.rmf,tp,LOCATION_EXTRA,0,3,3,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spf,tp,LOCATION_REMOVED+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spf,tp,LOCATION_REMOVED+LOCATION_HAND,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spf,tp,LOCATION_REMOVED+LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			local tc=g:GetFirst()
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			   local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				Duel.SpecialSummonComplete()
				if c:IsRelateToEffect(e) and c:GetLevel()~=tc:GetLevel() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.BreakEffect()
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_CHANGE_LEVEL)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetValue(tc:GetLevel())
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					c:RegisterEffect(e3)
				end
			end
		end
	end
end