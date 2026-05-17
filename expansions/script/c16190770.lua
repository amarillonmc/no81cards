--逢魔绮想譚 双位面的奇迹
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,16190750)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.drcost)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
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
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.rctg)
	e3:SetOperation(s.rcop)
	c:RegisterEffect(e3)
end
function s.costfilter(c,tp,mc)
	return c:IsCode(16190750) and c:IsAbleToRemoveAsCost() 
    	and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,mc)
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil,tp,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil,tp,c)
    g1:Merge(g2)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function s.setfilter(c,tp,con)
	return c:IsSetCard(0xb201) and not c:IsCode(id) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
    	and (c:IsType(TYPE_FIELD) or ((con and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or Duel.GetLocationCount(tp,LOCATION_SZONE)>1)) 
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local con=e:GetHandler():IsLocation(LOCATION_SZONE)
	local b1=Duel.IsPlayerCanDraw(tp,1)
    local b2=e:GetHandler():IsStatus(STATUS_SET_TURN) and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,tp,con)
	if chk==0 then return (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
    if e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetLabel()==1 then
    	e:SetCategory(CATEGORY_DRAW+CATEGORY_SSET)
    end
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local con=e:GetHandler():IsLocation(LOCATION_SZONE)
	if e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetLabel()==1 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,tp,con)
    	and (not Duel.IsPlayerCanDraw(tp,1) or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then Duel.SSet(tp,tc) end           
    else    
		Duel.Draw(tp,1,REASON_EFFECT)
    end    
end
function s.actcon(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.cfilter(c,tp,mc,con)
	return c:IsSetCard(0xb201) and ((c:IsFaceup() and c:GetSequence()<5) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToRemoveAsCost()
		and (Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil,tp,con) or Duel.IsPlayerCanDraw(tp,1))
        and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,Group.FromCards(c,mc))
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    local con=c:IsLocation(LOCATION_SZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp,c,con) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp,c,con):GetFirst()
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
function s.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb201)
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_REMOVED,0,1,nil)
    	and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
    	Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
        if g:GetCount()>0 then
        	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
        end
    end
end