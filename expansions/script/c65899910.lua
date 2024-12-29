--平心静气
function c65899910.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65899910.target)
	e1:SetOperation(c65899910.activate)
	c:RegisterEffect(e1)
end
function c65899910.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local dt=Duel.GetDrawCount(tp)
	if tid==1 then
		dt=1
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DRAW_COUNT)}
		for _,te in pairs(eset) do
			if te:GetValue()>dt then dt=te:GetValue() end
		end
		for _,te in pairs(eset) do
			if te:GetValue()==0 then dt=0 end
		end
	end
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c65899910.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(p,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
	local tid=Duel.GetTurnCount()
	local dt=Duel.GetDrawCount(tp)
		if tid==1 then
			dt=1
			local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DRAW_COUNT)}
			for _,te in pairs(eset) do
				if te:GetValue()>dt then dt=te:GetValue() end
			end
			for _,te in pairs(eset) do
				if te:GetValue()==0 then dt=0 end
			end
		end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	e1:SetValue(dt+2)
	Duel.RegisterEffect(e1,tp)
end