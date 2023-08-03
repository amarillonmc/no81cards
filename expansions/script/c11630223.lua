--风型镜·乱流
local m=11630223
local cm=_G["c"..m]
function c11630223.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
cm.SetCard_xxj_Mirror=true
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.chainlm(c))
	end
end
function cm.chainlm(c)
	return function(e,ep,tp)
		return tp==ep or not e:GetHandler():GetColumnGroup():IsContains(c)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local tc=sg:GetFirst()
		while tc do
			if tc:IsLocation(LOCATION_REMOVED) then
				local rtp = math.random(0, 1)
				if tc:IsType(TYPE_MONSTER) then
					--Duel.MoveToField(tc,tp,rtp,LOCATION_MZONE,tc:GetPreviousPosition(),true)
					--if rtp~=tc:GetControler() then
					Duel.ReturnToField(tc)
					Duel.GetControl(tc,rtp)
				else
					Duel.SendtoHand(tc,rtp,REASON_EFFECT)
				end
			end
			tc=sg:GetNext() 
		end
	end
end
