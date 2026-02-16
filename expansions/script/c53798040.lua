local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--检查两个效果是否已经使用过（利用FlagEffect记录）
	local b1=Duel.GetFlagEffect(tp,id)==0
	local b2=Duel.GetFlagEffect(tp,id+1)==0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		--同时可用时，让玩家选择
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		--只有效果1可用
		op=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		--只有效果2可用
		op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	end
	e:SetLabel(op)
	--根据选择注册Flag，限制一回合一次
	if op==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	--获取对方发动效果的卡的原卡名
	local rc=re:GetHandler()
	local code=rc:GetOriginalCode()
	
	if op==0 then
		--不能用该效果及同名卡效果把卡加入手卡
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_TO_HAND)
		e1:SetTargetRange(0,1) --作用于对方
		e1:SetLabel(code)
		e1:SetTarget(s.thlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		--不能用该效果及同名卡效果把怪兽特殊召唤
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(0,1) --作用于对方
		e1:SetLabel(code)
		e1:SetTarget(s.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.thlimit(e,c,tp,re)
	--re是导致加手的效果，检查其持有者是否为指定的原卡名
	return re and re:GetHandler():IsOriginalCode(e:GetLabel())
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	--se是导致特召的效果，检查其持有者是否为指定的原卡名
	return se and se:GetHandler():IsOriginalCode(e:GetLabel())
end