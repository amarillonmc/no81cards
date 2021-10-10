--联合模块-Combine
local m=20000315
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
	end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():GetOverlayGroup():GetCount()>0 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=e:GetHandler():GetOverlayGroup():FilterSelect(tp,Card.IsAbleToHandAsCost,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_COST)
		Duel.ConfirmCards(1-tp,sg)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(function(c,tp)
			return c:IsSetCard(0xfd3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() end,tp,LOCATION_DECK,0,1,nil,tp) end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,function(c,tp)return c:IsSetCard(0xfd3)and c:IsType(TYPE_SPELL+TYPE_TRAP)and c:IsSSetable()end,tp,LOCATION_DECK,0,1,1,nil,tp)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
			and Duel.IsExistingMatchingCard(function(c)return c:IsSetCard(0xfd3) and c:IsType(TYPE_SPELL+TYPE_TRAP)end,tp,LOCATION_DECK,0,1,nil) end
		if Duel.SelectEffectYesNo(tp,c,96) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSetCard(0xfd3) and c:IsType(TYPE_SPELL+TYPE_TRAP)end,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
			return true
		else return false end
	end)
	c:RegisterEffect(e2)
end
