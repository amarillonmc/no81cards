--Misaki, View of Eternity
function c33741060.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c33741060.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c33741060.regcon)
	e1:SetOperation(c33741060.regop)
	e1:SetLabelObject(e0) 
	c:RegisterEffect(e1)
end
function c33741060.valcheck(e,c)
	local val=c:GetMaterial():FilterCount(Card.IsType,nil,TYPE_TOKEN)
	e:SetLabel(val)
end
function c33741060.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabelObject():GetLabel()~=0
end
function c33741060.regop(e,tp,eg,ep,ev,re,r,rp)
	local vt=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if vt>=1 then
		--recover
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(33741060,5))
		e0:SetCategory(CATEGORY_RECOVER)
		e0:SetType(EFFECT_TYPE_QUICK_O)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetRange(LOCATION_MZONE)
		e0:SetCountLimit(1,33741060)
		e0:SetTarget(c33741060.rectg)
		e0:SetOperation(c33741060.recop)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e0)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33741060,vt))
	end
	if vt>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(33741060,6))
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1,33741060+10000000)
		e1:SetTarget(c33741060.atktg)
		e1:SetOperation(c33741060.atkop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	if vt>=3 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_DRAW)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_MZONE)
		e2:SetOperation(c33741060.rmop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
	if vt>=4 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_MOVE)
		e3:SetProperty(EFFECT_FLAG_DELAY)
		e3:SetRange(LOCATION_MZONE)
		e3:SetOperation(c33741060.disop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
	end
end
function c33741060.rfilter(c,tp)
	return c:IsType(TYPE_TOKEN) and (c:GetAttack()>0 or c:GetDefense()>0) and (c:IsControler(tp) or c:IsFaceup())
end
function c33741060.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c33741060.rfilter,1,nil,tp) and e:IsCostChecked() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local tc=Duel.SelectReleaseGroup(tp,c33741060.rfilter,1,1,nil,tp):GetFirst()
	local val=tc:GetAttack()+tc:GetDefense()
	if val>8000 then val=8000 end
	Duel.HintSelection(Group.FromCards(tc))
	Duel.Release(tc,REASON_COST)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c33741060.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c33741060.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) and Duel.CheckLPCost(tp,1000) and e:IsCostChecked() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local t={1000}
	for i=2,4 do
		if Duel.CheckLPCost(tp,i*1000) then t[i]=i*1000 end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33741060,0))
	local val=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,val)
	e:SetLabel(val)
end
function c33741060.atkop(e,tp,eg,ep,ev,re,r,rp)
	local val=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_TOKEN)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c33741060.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	if g:FilterCount(Card.IsAbleToRemove,nil)==0 then return end
	Duel.Hint(HINT_CARD,0,33741060)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local fid=e:GetHandler():GetFieldID()
	for tc in aux.Next(og) do
		tc:RegisterFlagEffect(33741060,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
	og:KeepAlive()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetLabel(fid)
	e0:SetLabelObject(og)
	e0:SetCountLimit(1)
	e0:SetCondition(c33741060.thcon)
	e0:SetOperation(c33741060.thop)
	if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e0:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		e0:SetValue(Duel.GetTurnCount())
	else
		e0:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e0:SetValue(0)
	end
	Duel.RegisterEffect(e0,tp)
end
function c33741060.thfilter(c,fid)
	return c:GetFlagEffectLabel(33741060)==fid and c:IsAbleToHand()
end
function c33741060.thcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp or Duel.GetTurnCount()==e:GetValue() then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c33741060.thfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c33741060.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33741060)
	local g=e:GetLabelObject()
	local sg=g:Filter(c33741060.thfilter,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
end
function c33741060.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	if g:FilterCount(aux.NegateAnyFilter,nil)==0 then return end
	Duel.Hint(HINT_CARD,0,33741060)
	for tc in aux.Next(g) do
		local ct=Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()<=PHASE_STANDBY and 2 or 1
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,ct)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,ct)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN,ct)
			tc:RegisterEffect(e3)
		end
	end
end
