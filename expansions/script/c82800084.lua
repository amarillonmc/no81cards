--蓬莱山辉夜的五种神宝
local s,id,o=GetID()
s.karuya_name_list=true 
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(1124)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x861) and c:IsType(TYPE_MONSTER)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.rccfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	local b1=Duel.GetFlagEffect(tp,id)==0
	local b2=Duel.GetFlagEffect(tp,id+100)==0 and s.damtg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	local b3=Duel.GetFlagEffect(tp,id+200)==0 and s.target2(e,tp,eg,ep,ev,re,r,rp,0)
	local b4=Duel.GetFlagEffect(tp,id+300)==0 and s.postg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	local b5=Duel.GetFlagEffect(tp,id+400)==0 and s.drtg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=1124
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=1122
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=1106
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=1131
		opval[off-1]=4
		off=off+1
	end
	if b5 then
		ops[off]=1108
		opval[off-1]=5
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	elseif sel==2 then
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE+PHASE_END,0,1)
		s.damtg(e,tp,eg,ep,ev,re,r,rp,1,chkc)
	elseif sel==3 then
		Duel.RegisterFlagEffect(tp,id+200,RESET_PHASE+PHASE_END,0,1)
		s.target2(e,tp,eg,ep,ev,re,r,rp,1)
	elseif sel==4 then
		Duel.RegisterFlagEffect(tp,id+300,RESET_PHASE+PHASE_END,0,1)
		s.postg(e,tp,eg,ep,ev,re,r,rp,1,chkc)
	elseif sel==5 then
		Duel.RegisterFlagEffect(tp,id+400,RESET_PHASE+PHASE_END,0,1)
		s.drtg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		Duel.RegisterEffect(e2,tp)
	elseif sel==2 then
		s.damop(e,tp,eg,ep,ev,re,r,rp)
	elseif sel==3 then
		s.activate2(e,tp,eg,ep,ev,re,r,rp)
	elseif sel==4 then
		s.posop(e,tp,eg,ep,ev,re,r,rp)
	elseif sel==5 then
		s.drop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function s.danfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.danfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.danfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.danfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack())
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetBaseAttack()/2
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and atk>0 then
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if #hg>0 then
		Duel.ConfirmCards(tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=hg:Select(tp,1,1,nil):GetFirst()
		if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(rc)
			e1:SetCountLimit(1)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
function s.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and aux.NegateMonsterFilter(c)
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e) then
		Duel.NegateRelatedChain(tc,RESETS_STANDARD-RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
