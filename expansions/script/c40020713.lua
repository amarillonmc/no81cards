--创界神 拉·赫尔阿克提
local s,id=GetID()
s.named_with_Grandwalker=1
function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end
function s.WeaponInsect(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_WeaponInsect
end
function s.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.pzcon)
	e3:SetTarget(s.pztg)
	e3:SetOperation(s.pzop)
	c:RegisterEffect(e3)  
end
function s.setfilter(c)
	return s.WeaponInsect(c) and not (c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS))
end


function s.szfilter(c, e, tp)
	if c:IsAbleToHand() then return true end
	if (c:GetOriginalType() & TYPE_MONSTER) ~= 0 
		and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
		and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then 
		return true 
	end
	return false
end

function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then

		if not Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil) then return false end

		local hasEmpty = Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
		local canReplace = Duel.IsExistingMatchingCard(s.szfilter, tp, LOCATION_SZONE, 0, 1, nil, e, tp)
		return hasEmpty or canReplace
	end
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)

	local hasEmpty = Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
	

	if not hasEmpty then

		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
		local sg = Duel.SelectMatchingCard(tp, s.szfilter, tp, LOCATION_SZONE, 0, 1, 1, nil, e, tp)
		if #sg == 0 then return end
		local sc = sg:GetFirst()
		

		local canth = sc:IsAbleToHand()
		local cansp = sc:IsType(TYPE_MONSTER) 
			and sc:IsCanBeSpecialSummoned(e, 0, tp, false, false) 
			and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		
		if canth and cansp then

			if Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
				Duel.SendtoHand(sc, nil, REASON_EFFECT)
				Duel.ConfirmCards(1 - tp, sc)
			else
				Duel.SpecialSummon(sc, 0, tp, tp, false, false, POS_FACEUP)
			end
		elseif canth then

			Duel.SendtoHand(sc, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, sc)
		elseif cansp then

			Duel.SpecialSummon(sc, 0, tp, tp, false, false, POS_FACEUP)
		else
			return
		end
	end
	
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g == 0 then return end
	local tc = g:GetFirst()
	
	Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	
	local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	tc:RegisterEffect(e1)
end

function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end


function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLocation(tp,LOCATION_PZONE,0)
			or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
end


function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	

	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		return
	end


	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end