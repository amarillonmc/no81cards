--圣兽战队-大地君主
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddFusionProcMix(c, false, false, 33201705, 33201703, 33201701)
	aux.AddContactFusionProcedure(c, Card.IsAbleToRemoveAsCost, LOCATION_ONFIELD + LOCATION_GRAVE + LOCATION_HAND, 0, Duel.Remove,POS_FACEUP, REASON_COST)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, id + 10000)
	e3:SetCondition(s.e3con)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.NegateAnyFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end


function s.e3con(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() == 1 - tp
end

function s.filter(c)
	return c:IsSetCard(0x6327) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end

function s.e3tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk == 0 then
		return e:GetHandler():IsAbleToExtra()
			and Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_REMOVED, 0, 1, nil)
			and Duel.IsExistingMatchingCard(Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, e:GetHandler())
			and Duel.GetLocationCount(tp, LOCATION_SZONE) >= 1
	end
	Duel.SetOperationInfo(0, CATEGORY_TOEXTRA, e:GetHandler(), 1, 0, 0)
end

function s.e3op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
	local tg = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_REMOVED, 0, 1, 3, nil)
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c, nil, 2, REASON_EFFECT) ~= 0 then
		if #tg > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
			local mc = Duel.SelectMatchingCard(tp, Card.IsFaceup, tp, LOCATION_MZONE, 0, 1, 1, nil):GetFirst()
			if mc then
				for ec in aux.Next(tg) do
					if Duel.Equip(tp, ec, mc, false) then
						-- Equip limit and type change
						local e1 = Effect.CreateEffect(mc)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetCode(EFFECT_EQUIP_LIMIT)
						e1:SetValue(s.eqlimit)
						e1:SetLabelObject(mc)
						e1:SetReset(RESET_EVENT + RESETS_STANDARD)
						ec:RegisterEffect(e1)
						local e2 = Effect.CreateEffect(mc)
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e2:SetCode(EFFECT_CHANGE_TYPE)
						e2:SetValue(TYPE_SPELL + TYPE_EQUIP)
						e2:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
						ec:RegisterEffect(e2)
					end
				end
			end
		end
	end
end

function s.eqlimit(e, c)
	return c == e:GetLabelObject()
end
