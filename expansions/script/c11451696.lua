--DX超性能纵连少女
local m=11451696
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	local col=0
	if loc&LOCATION_MZONE~=0 then
		col=aux.MZoneSequence(seq)
	elseif loc&LOCATION_SZONE~=0 then
		if seq>4 then return false end
		col=aux.SZoneSequence(seq)
	else
		return false
	end
	if p==1-tp then col=4-col end
	return aux.GetColumn(c,tp)==col
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,m)
	if chk==0 then return re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() and (ct<1 or Duel.IsPlayerCanDraw(tp,1)) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsCode(m) then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	local col=0
	if loc&LOCATION_MZONE~=0 then
		col=aux.MZoneSequence(seq)
	elseif loc&LOCATION_SZONE~=0 and seq<=4 then
		col=aux.SZoneSequence(seq)
	end
	if p==1-tp then col=4-col end
	e:SetLabel(col)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	if ct>=1 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		local ct=Duel.GetFlagEffect(tp,m)
		local rflag=false
		if ct>=1 and c:IsRelateToEffect(e) and c:IsCanTurnSet() then
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			rflag=true
		end
		if ct>=2 then
			if rflag then Duel.BreakEffect() end
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if ct==3 then
			local lab=e:GetLabel()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetLabel(lab)
			e1:SetValue(cm.aclimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.aclimit(e,re,tp)
	local rc,loc,seq=re:GetHandler(),re:GetActivateLocation(),re:GetActivateSequence()
	return loc&LOCATION_ONFIELD>0 and seq<=4 and (rc:IsControler(tp) and seq~=e:GetLabel()) or (rc:IsControler(1-tp) and seq~=4-e:GetLabel())
end