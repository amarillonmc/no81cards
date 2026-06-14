--灵魂调律
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(s.drcost)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)    
end
function s.costfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x33b0)
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:Select(tp,1,g:GetCount(),nil)
    for tc in aux.Next(sg) do
    	if tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
    	else
    		Duel.HintSelection(Group.FromCards(tc))
   	 	end
    end            
	e:SetLabelObject(sg)
    sg:KeepAlive()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)	
	local sg=e:GetLabelObject()
    local ct=1
    if sg and sg:GetCount()>0 then ct=sg:GetCount() end
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end    
function s.tgfilter(c)
	return c:IsSetCard(0x33b0) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGrave()
end    
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=e:GetLabelObject()
    local ct=sg:GetCount()
    if ct>0 and Duel.Draw(tp,ct,REASON_EFFECT)~=0 then
    	local oc1=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_HAND)
    	local tg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c)
    	if tg:GetCount()>0 and oc1>0 then
        	Duel.BreakEffect()
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        	local rg=tg:Select(tp,1,tg:GetCount(),nil)
        	if rg:GetCount()>0 and Duel.SendtoGrave(rg,REASON_EFFECT)~=0 then
            	local oc2=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
            	if oc2>0 then
            		local st=oc1-oc2
                	if oc1<oc2 then st=oc2-oc1 end
                	if st>0 then
                    	Duel.ShuffleHand(tp)
                    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
                        local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil):Select(tp,st,st,nil)
                        Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
                    end    
                end    
            end
    	end
    end
    sg:DeleteGroup()
end