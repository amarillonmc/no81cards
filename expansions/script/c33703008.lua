--～世界记录仪再始动～
local m=33703008
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--Effect 1
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_ACTIVATE)
	e01:SetCode(EVENT_FREE_CHAIN)
	e01:SetOperation(cm.actop)
	c:RegisterEffect(e01)
	--Effect 2  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--Effect 3 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(cm.leaveop)
	c:RegisterEffect(e4)
end
--Effect 1
function cm.pf(c) 
	return not c:IsPublic() and c:GetOriginalCodeRule()~=m and c:IsType(TYPE_CONTINUOUS)	 
end 
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.pf,tp,LOCATION_HAND,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tag=g:Select(tp,1,1,nil)
		if #tag==0 then return false end
		local tc=tag:GetFirst()
		cm.copyop(e,tp,tc)
	end
end
function cm.copyop(e,tp,tc)
	local c=e:GetHandler()
	local cid=c:CopyEffect(tc:GetCode(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	local fid=c:GetFieldID()
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(66)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_PUBLIC)
	e12:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e12:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e12)
	Duel.AdjustAll()
	if tc:IsPublic() then
		tc:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1)) 
	end
	c:SetHint(CHINT_CARD,tc:GetCode())
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77584012,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetLabel(cid)
	e2:SetOperation(cm.rstop)
	c:RegisterEffect(e2)
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
--Effect 2
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.pf,tp,0,LOCATION_HAND,nil)
	if chk==0 then return #g>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.pf,tp,LOCATION_HAND,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tag=g:Select(tp,1,1,nil)
	if #tag==0 then return false end
	local tc=tag:GetFirst()
	cm.copyop(e,tp,tc)
end
--Effect 3
function cm.pzf(c,fid) 
	return c:IsPublic() and c:GetFlagEffect(m+100)>0 and c:GetFlagEffectLabel(m+100)==fid
end   
function cm.leaveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local g=Duel.GetMatchingGroup(cm.pzf,tp,LOCATION_HAND,0,nil,fid)
	if #g==0 then return end
	local tg=g:Filter(Card.IsAbleToDeck,nil)
	if #tg==0 then return false end
	if Duel.SendtoDeck(tg,1-tp,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 or tg:Filter(Card.IsLocation,nil,LOCATION_DECK)==0 then return false end
	if not Duel.IsPlayerCanDraw(1-tp,1) then return false end
	Duel.BreakEffect()
	Duel.Draw(1-tp,1,REASON_EFFECT)
end 