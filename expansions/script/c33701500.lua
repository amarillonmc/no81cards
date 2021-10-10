--【背景音台】POP TEAM EPIC
function c33701500.initial_effect(c)
	--card,code,oathcount,bgmHintID(卡片，卡号，契约回合,音乐提示)
	--card,code,oathcount,bgmHintID(<cardname>,<cardID>,<contractTurn>,<BGMFileName>)
	bgmhandle(c,33701500,6,1)
end
function bgmhandle(c,code,count,bgmid,con,cost,tg,op)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	if con then e0:SetCondition(con) end
	e0:SetCost((cost and {cost} or {function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		if bgmid then Duel.Hint(HINT_MUSIC,0,aux.Stringid(code,bgmid)) end
	end})[1])
	if tg then e0:SetTarget(tg) end
	if op then e0:SetOperation(op) end
	--indes
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	--Cannot activate
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetTargetRange(1, 0)
	e3:SetValue(function(e,re,tp)
		return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) end)
	--cannot set
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1, 0)
	e4:SetTarget(function(e,c)
		return c:IsType(TYPE_FIELD) end)
	c:RegisterEffect(e4)
	--Auto oath count
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return tp~=Duel.GetTurnPlayer() end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)   
		local c=e:GetHandler()
		if c:GetFlagEffect(1082946)==0 then
			c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,count)
			c:SetTurnCounter(0)
		end
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
		if ct>=count then
			Duel.Destroy(c,REASON_RULE)
			c:ResetFlagEffect(1082946)
		end end)
	c:RegisterEffect(e0)
	c:RegisterEffect(e1)
	c:RegisterEffect(e2)
	c:RegisterEffect(e3)
	c:RegisterEffect(e4)
	_G["c"..code][c] = e1  
end