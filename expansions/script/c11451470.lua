--虚诞狂想 终末的奏鸣
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e2:SetOperation(cm.efop)
	c:RegisterEffect(e2)
	--change code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ADD_CODE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.chtg)
	e3:SetValue(11451461)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,5))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.drcon)
	e4:SetTarget(cm.drtg)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsPosition(POS_FACEUP_ATTACK) then
			tc:RegisterFlagEffect(m-10,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		end
	end
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if not rc or not rc:IsSetCard(0x97a) or not rc:IsType(TYPE_MONSTER) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(cm.chtg)
	e1:SetValue(11451461)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
end
function cm.filter(c)
	return Duel.IsPlayerAffectedByEffect(c:GetControler(),11451461) and ((c:IsOnField() and c:IsStatus(STATUS_EFFECT_ENABLED)) or c:IsLocation(LOCATION_HAND))
end
function cm.filter6(c,e)
	return c:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.chtg(e,c)
	if c then return c:GetFlagEffect(m-10)>0 and c:IsType(TYPE_MONSTER) and c:IsFaceup() end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return tc~=e:GetHandler() and tc:IsSetCard(0x97a)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function Group.ForEach(group,func,...)
    if aux.GetValueType(group)=="Group" and group:GetCount()>0 then
        local d_group=group:Clone()
        for tc in aux.Next(d_group) do
            func(tc,...)
        end
    end
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToRemove,p,LOCATION_HAND,0,1,2,nil)
	local tg=g:Filter(cm.filter,nil)
	if tg and tg:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,11451461)
		local te=Duel.IsPlayerAffectedByEffect(tp,11451461)
		g:Sub(tg)
		te:GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local ct=Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		if ct>0 then
			local fid=c:GetFieldID()
			tg:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			tg:KeepAlive()
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(11451461,1))
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetLabel(fid)
			e2:SetLabelObject(tg)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetOperation(cm.retop2)
			Duel.RegisterEffect(e2,tp)
		end
		if g and #g>0 then
			local ct2=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			ct=ct+ct2
		end
		Duel.Draw(p,ct,REASON_EFFECT)
	elseif #g>0 then
		local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Draw(p,ct,REASON_EFFECT)
	end
end
function cm.retop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(cm.filter6,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	e:GetLabelObject():DeleteGroup()
end