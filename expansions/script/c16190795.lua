--逢魔绮想譚 “规矩，规则”
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.efcon)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--盖放回合发动    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetType(EFFECT_TYPE_SINGLE)	    
	e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.actcon)
	e2:SetCost(s.actcost)
    e2:SetValue(id)
    e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--回复    
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_SSET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.rctg)
	e3:SetOperation(s.rcop)
	c:RegisterEffect(e3)           
end
function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	if ev<=1 then return false end
    local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)    
	return te and te:GetHandler():IsSetCard(0xb201)
end
function s.rmfilter(c)
	return c:IsSetCard(0xb201) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToRemove()
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=rp==tp and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil)
    local b2=rp==1-tp and Duel.IsChainDisablable(ev) 
	if chk==0 then return (b1 or b2) end
    if rp==tp then
    	if e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetLabel()==1 then
        	e:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
        else
        	e:SetCategory(CATEGORY_REMOVE)
        end
    	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
    elseif rp==1-tp then  
    	 if e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetLabel()==1 then
        	e:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
        else
        	e:SetCategory(CATEGORY_DISABLE)
        end
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)    	
    end
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	if rp==tp then  
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
        	res=1
		end    
    elseif rp==1-tp then
    	res=Duel.NegateEffect(ev)    
	end
    if e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1)
    	and res~=0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function s.actcon(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.cfilter(c)
	return c:IsSetCard(0xb201) and ((c:IsFaceup() and c:GetSequence()<5) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToRemoveAsCost()
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil):GetFirst()
    local res=0
	if Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
    	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
    	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
        e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)    
        res=1
    end
    if res~=0 then
    	e:GetLabelObject():SetLabel(1)
    else
    	e:GetLabelObject():SetLabel(0)
    end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)>0
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
    if tc:IsPreviousLocation(LOCATION_MZONE) then
		Duel.ReturnToField(tc)
    elseif tc:IsPreviousLocation(LOCATION_HAND) then
    	Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
    end
    tc:ResetFlagEffect(id)
end
function s.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function s.setfilter(c)
	return c:IsSetCard(0xb201) and not c:IsCode(id) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) 
    	and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
    	and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
		if tc then Duel.SSet(tp,tc) end
    end
end