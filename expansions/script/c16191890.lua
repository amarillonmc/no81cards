--心之辉彩的萌芽
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES_SELF)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(2,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--回到卡组
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.tdcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.confilter(c)
	return (c:IsSetCard(0x57b0) or c:IsRace(RACE_SPELLCASTER)) and c:IsDiscardable(REASON_EFFECT)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==d then
    	Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(s.confilter,p,LOCATION_HAND,0,1,nil) then
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=Duel.SelectMatchingCard(p,s.confilter,p,LOCATION_HAND,0,1,1,nil)
			if dg:GetCount()>0 then
				Duel.ShuffleHand(p)
				Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD,p)
			end
		else
			local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD,p)
		end    
    end
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_COST) 
    Duel.ConfirmCards(1-tp,e:GetHandler())
end
function s.tdfilter(c)
	return c:IsSetCard(0x57b0) and c:IsAbleToDeck()
end    
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND,0,1,nil) 
    	and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
    	Duel.ConfirmCards(1-tp,tc)
        local res=false
		if Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0 then
			if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
            	res=true
            end
    	else
    		if Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 then
            	res=true
            end
    	end
        Duel.ShuffleHand(tp)
        if res and tc:IsLocation(LOCATION_DECK) then
        	Duel.BreakEffect()
            Duel.Draw(tp,1,REASON_EFFECT)
        end
	end
end