--神器鸣动
local m=60002233
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0x625,LOCATION_ONFIELD)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate2)
	c:RegisterEffect(e1)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.xfilter,tp,LOCATION_MZONE,0,0,100,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_COST)
	end
	e:SetLabel(g:GetCount())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x625,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x625)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x625,2)
		--cost
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e4:SetCountLimit(1)
		e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e4:SetRange(LOCATION_SZONE)
		e4:SetOperation(cm.ccost)
		e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e4)
		--selfdes
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetRange(LOCATION_SZONE)
		e7:SetCode(EFFECT_SELF_DESTROY)
		e7:SetCondition(cm.descon)
		c:RegisterEffect(e7)
		--choose
		local op=0
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
		if op==0 then
			--审判之枪
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetRange(LOCATION_SZONE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCountLimit(1)
			e2:SetOperation(cm.damop1)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e2)
		elseif op==1 then
			--永恒教义
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetRange(LOCATION_SZONE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCountLimit(1)
			e2:SetOperation(cm.damop2)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e2)
		elseif op==2 then
			--罪恶之盾
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetCode(EFFECT_CHANGE_DAMAGE)
			e2:SetRange(LOCATION_SZONE)
			e4:SetTargetRange(1,0)
			e4:SetValue(cm.damval)
			e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
		end
	end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x625,2)
		--cost
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e4:SetCountLimit(1)
		e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e4:SetRange(LOCATION_SZONE)
		e4:SetOperation(cm.ccost)
		e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e4)
		--selfdes
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e7:SetRange(LOCATION_SZONE)
		e7:SetCode(EFFECT_SELF_DESTROY)
		e7:SetCondition(cm.descon)
		c:RegisterEffect(e7)
		--choose
		local op=0
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
		if op==0 then
			--审判之枪
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetRange(LOCATION_SZONE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCountLimit(1)
			e2:SetOperation(cm.damop1)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e2)
		elseif op==1 then
			--永恒教义
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetRange(LOCATION_SZONE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCountLimit(1)
			e2:SetOperation(cm.damop2)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e2)
		elseif op==2 then
			--罪恶之盾
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetCode(EFFECT_CHANGE_DAMAGE)
			e2:SetRange(LOCATION_SZONE)
			e4:SetTargetRange(1,0)
			e4:SetValue(cm.damval)
			e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
		end
		local tc=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),e:GetLabel()) 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_EXTRA,0,0,tc,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.damop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cm.xfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g:GetFirst(),REASON_EFFECT)
	end
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function cm.damop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function cm.damval(e,re,val,r,rp,rc)
	if val>1500 then return 1500 end
	return val
end
function cm.ccost(e,tp,eg,ep,ev,re,r,rp)
	if Card.IsCanRemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT) then
		Card.RemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT)
	end
end
function cm.descon(e)
	return Card.GetCounter(e:GetHandler(),0x625)==0
end
function cm.xfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5622)
end