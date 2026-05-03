--武装解限-斗转星移
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,16190330)
	--发动    
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION+CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)    
    if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
    	if tc:IsControler(e:GetHandler():GetOwner()) and tc:IsCode(16190330) then
			Duel.RegisterFlagEffect(e:GetHandler():GetOwner(),id,0,0,0)
        end    
	end
end
function s.tgfilter(c)
	return c:IsCode(16190330) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_TUNER)
    	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
    	local ct=Duel.GetFlagEffect(tp,id)
    	if ct<=0 or not Duel.SelectYesNo(tp,aux.Stringid(id,5)) then return end
        Duel.ShuffleDeck(tp)
        Duel.BreakEffect()
        for i=1,ct do
        	local b1=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
            local b2=Duel.GetMatchingGroupCount(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE,nil)>0
            local b3=Duel.IsPlayerCanDraw(tp,1)
            local b4=Duel.GetMatchingGroupCount(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)>0
        	if not b1 and not b2 and not b3 and not b4 then break end
            local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(id,1),1},
				{b2,aux.Stringid(id,2),2},
				{b3,aux.Stringid(id,3),3},
				{b4,aux.Stringid(id,4),4})
			if i>1 then
				Duel.BreakEffect()
			end
            if op==1 then
            	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
                if g:GetCount()>0 then
                	local sg=g:Select(tp,1,1,nil)
                    Duel.HintSelection(sg)
                    Duel.Destroy(sg,REASON_EFFECT)
                end
            elseif op==2 then
            	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,0,LOCATION_GRAVE,nil)
                if rg:GetCount()>0 then
                	local tg=rg:Select(tp,1,1,nil)
                    Duel.HintSelection(tg)
                    Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
                end
            elseif op==3 then
            	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
                	Duel.BreakEffect()
					Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
                end
            elseif op==4 then
            	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
            end
        end
	end   
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end    
function s.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end