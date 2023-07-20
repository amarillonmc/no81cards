--感官超载
function c33711004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c33711004.condition)
	e1:SetTarget(c33711004.target)
	e1:SetOperation(c33711004.activate)
	c:RegisterEffect(e1)
	if not c33711004.global_check then
		c33711004.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(c33711004.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33711004.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if Duel.GetCurrentPhase()~=PHASE_DRAW then
		while tc do
			Duel.RegisterFlagEffect(tc:GetControler(),33711004,RESET_PHASE+PHASE_END,0,1)
			tc=eg:GetNext()
		end
	end
end
function c33711004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,33711004)>4
end
function c33711004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,21) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(21)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,21)
end
function c33711004.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==21 then
		if Duel.SelectYesNo(tp,aux.Stringid(33711004,1)) then
			local thg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			Duel.SendtoHand(thg,1-tp,REASON_EFFECT)
			local num=Duel.GetOperatedGroup():GetCount()
			Duel.Draw(p,(21+num)*2,REASON_EFFECT)
		end
	end
end