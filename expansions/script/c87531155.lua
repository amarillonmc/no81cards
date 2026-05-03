--死冥权能
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--抽卡代替
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--除外    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e2:SetCountLimit(1,id)
    e2:SetCondition(s.rmcon)
    e2:SetCost(s.rmcost)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
    --盖放	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_SSET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+o)
	e3:SetCondition(s.setcon)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function s.tgfilter(c)
	return c:IsSetCard(0x364b) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.IsPlayerCanNormalDraw(tp) then return end
	aux.GiveUpNormalDraw(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)		
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end    
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rt=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil,POS_FACEDOWN)
	if chk==0 then return Duel.CheckLPCost(tp,400,true) and rt>0 end
	local lp=Duel.GetLP(tp)
	local t={}
	for i=1,rt do
		if not Duel.CheckLPCost(tp,i*400,true) then break end
		t[i]=i
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local an=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,an*400,true)
	e:SetLabel(an)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetLabel()
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_DECK,0,nil,POS_FACEDOWN)
	if chk==0 then return rg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,ct,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()    
	local ct=e:GetLabel()
	local g=Duel.GetDecktopGroup(tp,ct)    
	Duel.DisableShuffleCheck()
	if g:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==ct and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)==ct then
    	local fid=c:GetFieldID()
    	local og=Duel.GetOperatedGroup()
    	if ct>1 then ct=ct-1 end
    	local tc=og:GetFirst()
    	while tc do
        	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,ct,fid)           
    		tc=og:GetNext()
        end                        
		og:KeepAlive()
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,ct)
		e1:SetLabel(fid,0,ct)
		e1:SetLabelObject(og)
		e1:SetCondition(s.thcon)
		e1:SetOperation(s.thop)
		Duel.RegisterEffect(e1,tp)
    end
end
function s.thfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local fid=e:GetLabel()
	local g=e:GetLabelObject()
    if not g:IsExists(s.thfilter,1,nil,fid) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct,dt=e:GetLabel()
	local g=e:GetLabelObject()
    local sg=g:Filter(s.thfilter,nil,fid)	    
    ct=ct+1
	e:GetHandler():SetTurnCounter(ct)
	e:SetLabel(fid,ct,dt)
    if ct~=dt then return end
    g:DeleteGroup()
    local tc=sg:GetFirst()
    while tc do
		if tc:GetFlagEffectLabel(id)==fid then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
        end
        tc=sg:GetNext()    
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
    if re and re:GetHandler():IsSetCard(0x364b) then
    	e:SetCategory(CATEGORY_RECOVER+CATEGORY_LEAVE_GRAVE)
    	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1600)
    end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 and re and re:GetHandler():IsSetCard(0x364b) then
    	Duel.BreakEffect()
        Duel.Recover(tp,1600,REASON_EFFECT)
	end        
end