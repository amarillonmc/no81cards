--逢魔绮想譚 明谈暗对
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.lpcon)
	e1:SetTarget(s.lptg)
	e1:SetOperation(s.lpop)
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
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(s.rctg)
	e3:SetOperation(s.rcop)
	c:RegisterEffect(e3)    
end
function s.confilter(c)
	return c:IsSetCard(0xca1) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,1,nil)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0
    local b2=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0    
	if chk==0 then return (b1 or b2) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,1000)
    if e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetLabel()==1 then
    	e:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
    end
end
function s.rmfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemove()
end        
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 then
    	local b1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0
    	local b2=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0   
        if not b1 and not b2 then return end
    	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,5),1},
			{b2,aux.Stringid(id,6),2})
        local res=0    
        if op==1 then
        	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
        	local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
        	Duel.ConfirmCards(1-tp,g1)
            Duel.ConfirmCards(tp,g2)
            Duel.ShuffleHand(tp)
            Duel.ShuffleExtra(1-tp)       
            res=1 
        elseif op==2 then
        	local g1=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
        	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
        	Duel.ConfirmCards(1-tp,g1)
            Duel.ConfirmCards(tp,g2)
            Duel.ShuffleExtra(tp)
            Duel.ShuffleHand(1-tp)
            res=1
        end    
        if e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetLabel()==1 and res~=0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
			getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK,OPCODE_ISTYPE}
			local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
            local tg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):Filter(s.rmfilter,nil,ac)
            if tg:GetCount()>0 then
            	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
            	local tc=tg:Select(1-tp,1,1,nil):GetFirst()
                Duel.HintSelection(Group.FromCards(tc))
                if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 and tc:IsLocation(LOCATION_REMOVED) then
                	tc:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
                    local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabelObject(tc)
					e1:SetCountLimit(1)
        			e1:SetCondition(s.retxcon)
					e1:SetOperation(s.retxop)
					Duel.RegisterEffect(e1,tp)    
                end
            end
        end
    end
end
function s.retxcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id+o)>0
end
function s.retxop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
    if tc:IsType(TYPE_PENDULUM) and tc:IsPreviousPosition(POS_FACEUP) then
    	Duel.SendtoExtraP(tc,tc:GetPreviousControler(),REASON_EFFECT)
    else
		Duel.SendtoDeck(tc,tc:GetPreviousControler(),2,REASON_EFFECT)        
    end    
end
function s.actcon(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and e:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.cfilter(c,tp)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0
    local b2=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 
	return c:IsSetCard(0xca1) and ((c:IsFaceup() and c:GetSequence()<5) or c:IsLocation(LOCATION_HAND)) and c:IsAbleToRemoveAsCost()
		and (b1 or b2)
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
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
function s.fselect(g,tp)
	return g:IsExists(Card.IsControler,1,nil,tp) and g:IsExists(Card.IsControler,1,nil,1-tp)
end    
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT)~=0 then 
    	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
        if g:CheckSubGroup(s.fselect,2,2,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then 
        	Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:SelectSubGroup(tp,s.fselect,false,2,2,tp)
            if not sg then return end
            Duel.HintSelection(sg)
            Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
        end
    end
end