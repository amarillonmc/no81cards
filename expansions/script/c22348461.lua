--连拳
local m=22348461
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348461+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22348461.target)
	e1:SetOperation(c22348461.activate)
	c:RegisterEffect(e1)
	
end
function c22348461.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return #g>1 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c22348461.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	if #g1>0 then
		Duel.HintSelection(g1)
		if Duel.Destroy(g1,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) then
			Duel.BreakEffect()
			local g2=Duel.SelectMatchingCard(1-tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
			if g2:GetCount()>0 then
				Duel.HintSelection(g2)
				Duel.Destroy(g2,REASON_EFFECT)
			end
		end
	end
end
