--特制药·化骨散
local m=11631021
local cm=_G["c"..m]
--strings
cm.tezhiyao=true 
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
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
	return c.yaojishi and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove(tp) end  
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil,tp) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 then
		e:SetLabel(114514)
		c:ResetFlagEffect(m)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		local ct=Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		if ct>0 and e:GetLabel()==114514 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct then
			local g=Duel.GetDecktopGroup(1-tp,ct)
			if g:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN):GetCount()==ct and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.DisableShuffleCheck()
				Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			end
		end
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
