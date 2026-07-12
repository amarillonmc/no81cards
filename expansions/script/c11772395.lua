--北岐同心
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)
	--手卡发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c:IsSetCard(0x6c75) and c:IsLevelAbove(8) and c:IsAbleToHand()     
end
function s.tgfilter(c)
	return c:IsSetCard(0x6c75) and c:IsLevelBelow(4) and c:IsAbleToGrave() 
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return (b1 or b2) end
    local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2),1},
		{b2,aux.Stringid(id,3),2})
    e:SetLabel(op)
    if op==1 then
    	e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    elseif op==2 then
    	e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
    end	
end
function s.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x6c75)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
    local res=false
    if op==1 then
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)            
            if Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
				if sg:GetCount()>0 then
                	local e1=Effect.CreateEffect(e:GetHandler())				
					e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)					
					e1:SetCode(EVENT_SUMMON_SUCCESS)				
                    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)	
                    e1:SetLabelObject(e:GetHandler())
					e1:SetOperation(s.tgop)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
					sg:GetFirst():RegisterEffect(e1,true)
					Duel.Summon(tp,sg:GetFirst(),true,nil)
				end
			else
        		res=true
        	end
		end        
    elseif op==2 then
    	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then		
            if Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				Duel.BreakEffect()
				Duel.ShuffleHand(tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
				if sg:GetCount()>0 then
                	local e2=Effect.CreateEffect(e:GetHandler())				
					e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)					
					e2:SetCode(EVENT_SUMMON_SUCCESS)				
                    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)	
                    e2:SetLabelObject(e:GetHandler())
					e2:SetOperation(s.tgop)
                    e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
					sg:GetFirst():RegisterEffect(e2,true)
					Duel.Summon(tp,sg:GetFirst(),true,nil)
				end
			else
        		res=true
        	end
		end
    end
    if res and Duel.GetMatchingGroupCount(Card.IsSummonType,tp,LOCATION_MZONE,0,nil,SUMMON_TYPE_ADVANCE)>0
    	and Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())>0
        and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
    	Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler()):Select(tp,1,1,nil)
        if tg:GetCount()>0 then
        	Duel.HintSelection(tg)
            Duel.SendtoGrave(tg,REASON_EFFECT)
        end
    end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	if Duel.GetMatchingGroupCount(Card.IsSummonType,tp,LOCATION_MZONE,0,nil,SUMMON_TYPE_ADVANCE)>0
    	and Duel.GetMatchingGroupCount(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ec)>0
        and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
    	Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,ec):Select(tp,1,1,nil)
        if tg:GetCount()>0 then
        	Duel.HintSelection(tg)
            Duel.SendtoGrave(tg,REASON_EFFECT)
        end
    end    
    e:Reset()
end
function s.handcon(e)
	return Duel.GetMatchingGroupCount(Card.IsSummonType,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,SUMMON_TYPE_SPECIAL)==0
end