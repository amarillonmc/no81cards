--远古与未来的接触
local m=37901009
local cm=_G["c"..m]
function cm.initial_effect(c)
--e1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.tf1,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tn=eg:GetFirst()
		while tn do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tn:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tn:RegisterEffect(e2)
			tn=eg:GetNext()
		end
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(cm.tf1,tp,LOCATION_DECK,0,1,nil)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tf1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
	end)
	c:RegisterEffect(e3)
--e4
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(cm.tf1,tp,LOCATION_REMOVED,0,1,nil) end
		local g=Duel.GetMatchingGroup(cm.tf1,tp,LOCATION_REMOVED,0,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,LOCATION_REMOVED)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(cm.tf1,tp,LOCATION_REMOVED,0,e:GetHandler())
		if e:GetHandler():IsRelateToEffect(e) and Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 and g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,nil,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e4)
end
--e1
function cm.tf1(c,e,tp)
	return c:IsSetCard(0x388) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end