--爱妮慕丝和愉快的小伙伴们
local s,id,o=GetID()
function s.initial_effect(c)
	--手卡特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--翻开卡组    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--不能把效果发动
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_TRIGGER)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCondition(s.atcon)
	e0:SetRange(LOCATION_HAND)
	c:RegisterEffect(e0)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnPlayer()==1-tp and bit.band(r,REASON_BATTLE)~=0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(3600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5)
		and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToGrave,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function s.tgfilter(c)
	return c:IsSetCard(0x364a) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function s.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x64a) and c:IsType(TYPE_MONSTER)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,5) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()>0 then
			if g:IsExists(s.tgfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.DisableShuffleCheck()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g:FilterSelect(tp,s.tgfilter,1,1,nil)
                Duel.SendtoGrave(sg,REASON_EFFECT)
                local og=Duel.GetOperatedGroup()                             
                if sg:GetFirst():IsLocation(LOCATION_GRAVE) and og:Filter(Card.IsType,nil,TYPE_MONSTER):GetCount()>0 then
                	local b1=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil):GetCount()>0
					local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil)      			
    				local b3=(b1 and b2)
                	if Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
                    	and (b1 or b2 or b3)
                		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
                		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
                   	 	local tg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
						if tg:GetCount()>0 and Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
                        	local sel=0
							local ac=0
                    		if b1 then sel=sel+1 end
                            if b2 then sel=sel+2 end
                            if sel==1 then
								ac=Duel.SelectOption(tp,aux.Stringid(id,5))
							elseif sel==2 then
								ac=Duel.SelectOption(tp,aux.Stringid(id,6))+1
							elseif b3 then
								ac=Duel.SelectOption(tp,aux.Stringid(id,5),aux.Stringid(id,6),aux.Stringid(id,4))
							else
								ac=Duel.SelectOption(tp,aux.Stringid(id,5),aux.Stringid(id,6))
							end
                    		if ac==0 or ac==2 then
                          		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
								local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil):Select(tp,1,1,nil)
								if dg:GetCount()>0 then
									Duel.HintSelection(dg)
									Duel.Destroy(dg,REASON_EFFECT)
								end						
            				end
							if ac==1 or ac==2 then
                        		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
                   	 			local bc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
								if bc then
                                	Duel.SendtoHand(bc,nil,REASON_EFFECT)
                                    local og=Duel.GetOperatedGroup()
                        			Duel.ConfirmCards(1-tp,bc)
                                    if og:Filter(Card.IsCode,nil,id):GetCount()>0 then
                                    	local e1=Effect.CreateEffect(e:GetHandler())
										e1:SetType(EFFECT_TYPE_SINGLE)
										e1:SetCode(EFFECT_PUBLIC)
										e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOHAND+RESET_PHASE+PHASE_END)
										og:GetFirst():RegisterEffect(e1)
                                        og:GetFirst():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOHAND+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,7))                                                                      
                                    end
                               	end     
                        	end
                    	end
                    end                    
                end                               
			end  
        	Duel.ShuffleDeck(tp)                        
		end
	end        
end
function s.atcon(e)
	return e:GetHandler():GetFlagEffect(id)>0
end