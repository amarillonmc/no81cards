--特制药 活血丸
local m=11631005
local cm=_G["c"..m]
--strings
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--register
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_ACTIVATE_COST)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)  
	e2:SetTargetRange(1,0)  
	e2:SetTarget(cm.actarget)  
	e2:SetCost(aux.TRUE)  
	e2:SetOperation(cm.costop)  
	c:RegisterEffect(e2)  
end

--activate
function cm.cfilter(c)
	return c:IsSetCard(0xc220) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return ct>0 and ((not (c:IsLocation(LOCATION_HAND) and c:IsPublic() and e:IsHasType(EFFECT_TYPE_ACTIVATE))) or ct<2 or Duel.IsPlayerCanDraw(tp,math.floor(ct/2))) end
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(ct*500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500) 
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:GetFlagEffect(m)>0 then
		e:SetLabel(114514)
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
		if ct>2 then
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,math.floor(ct/2))   
		end
		c:ResetFlagEffect(m)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local ct=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct<=0 then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	local rec=Duel.Recover(p,ct*500,REASON_EFFECT)  
	if e:GetLabel()==114514 and rec>=1000 and Duel.IsPlayerCanDraw(p,math.floor(rec/1000)) then
		Duel.Draw(p,math.floor(rec/1000),REASON_EFFECT)
	end  
end  

--register
function cm.actarget(e,te,tp)  
	local tc=te:GetHandler()
	return tc==e:GetHandler() and tc:IsLocation(LOCATION_HAND) and tc:IsPublic()
end  
function cm.costop(e,tp,eg,ep,ev,re,r,rp) 
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1) 
end  
