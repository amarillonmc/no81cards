local cm,m = GetID()
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCondition(Auxiliary.DualNormalCondition)
	e2:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e2)
end
function cm.f(c)
	return c:IsCode(m,31987274) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.f,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	e:SetLabelObject(g:GetFirst())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc = e:GetLabelObject()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	    if tc:IsType(TYPE_NORMAL) then
	        local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        	e1:SetCode(EVENT_REMOVE)
        	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
        	Duel.Recover(tp,800,REASON_EFFECT) 
        	end)
        	e1:SetReset(RESET_PHASE+PHASE_END)
        	Duel.RegisterEffect(e1,tp)
        	local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
            e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
            --e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	        --  return Duel.GetTurnPlayer()==tp end)
            e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
            local g = Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil)
            if #g>0 then
                g = g:Select(tp,1,1,nil)
            	if #g>0 then Duel.SendtoHand(g,tp,REASON_EFFECG) end
            end
            e:Reset()
            end)
            Duel.RegisterEffect(e2,tp)
            local g=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_DECK,0,1,nil)
	        if #g>0 then
	            g = g:Select(tp,1,1,nil)
	            if #g>0 then  Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
	        end
	    else
    	    local op = cm.SE(1-tp,m,
    	    {true,0},
    	    {true,1},
    	    --{Duel.IsExistingMatchingCard(cm.ff,tp,LOCATION_DECK,0,1,nil),2}
    	    {true,2})
	        if op == 0 then
	            local e1=Effect.CreateEffect(c)
            	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
            	e1:SetCode(EVENT_REMOVE)
            	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
            	Duel.Recover(tp,800,REASON_EFFECT) 
            	end)
            	e1:SetReset(RESET_PHASE+PHASE_END)
            	Duel.RegisterEffect(e1,tp)
	        elseif op == 1 then
	            local e1=Effect.CreateEffect(c)
            	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
            	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
            	--e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				--	return Duel.GetTurnPlayer()==tp end)
            	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) 
            	local g = Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil)
            	if #g>0 then
            	    g = g:Select(tp,1,1,nil)
            	    if #g>0 then Duel.SendtoHand(g,tp,REASON_EFFECG) end
                end
                e:Reset()
            	end)
            	Duel.RegisterEffect(e1,tp)
	        elseif op == 2 then
	            local g=Duel.GetMatchingGroup(cm.ff,tp,LOCATION_DECK,0,1,nil)
	            if #g>0 then
	                g = g:Select(tp,1,1,nil)
	                if #g>0 then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
	            end
	        end
	    end
	end
end
function cm.ff(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToRemove()
end
function cm.SE(tp,id,...)
    local v = {...}
	local off=1
	local ops={}
	local opval={}
	for k,i in ipairs(v) do
	    local a,b = i[1],i[2]
    	if a then
    		ops[off]=aux.Stringid(id,b)
    		opval[off]=k-1
    		off=off+1
    	end
    end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	return sel
end