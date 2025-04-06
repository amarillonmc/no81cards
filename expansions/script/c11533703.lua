--影灵衣归魂 艾丽娅儿
function c11533703.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--ritual level
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_RITUAL_LEVEL)
	e0:SetValue(c11533703.rlevel)
	c:RegisterEffect(e0)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11533703)
	e2:SetTarget(c11533703.thtg)
	e2:SetOperation(c11533703.thop)
	c:RegisterEffect(e2)
	--set 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,21533703)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 end) 
	e3:SetTarget(c11533703.settg)
	e3:SetOperation(c11533703.setop)
	c:RegisterEffect(e3)
end
function c11533703.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	local clv=c:GetLevel()
	return (lv<<16)+clv
end
function c11533703.thfilter(c)
	return c:IsSetCard(0xb4) and c:IsAbleToHand()
end
function c11533703.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533703.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11533703.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c11533703.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc) 
		--if tc:IsType(TYPE_MONSTER) then 
			--ritual level
			--local e2=Effect.CreateEffect(c)
			--e2:SetType(EFFECT_TYPE_SINGLE)
			--e2:SetCode(EFFECT_RITUAL_LEVEL)
			--e2:SetValue(c11533703.rlevel) 
			--e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			--c:RegisterEffect(e2)
		--end 
	end
end 
function c11533703.rlevel(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler()) 
	local clv=c:GetLevel() 
	return (lv<<16)+clv  
end
function c11533703.setfilter(c)
	return c:IsSetCard(0xb4) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c11533703.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11533703.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c11533703.bgfilter(c)  
	return c:IsAbleToGrave()
end  
function c11533703.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c11533703.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SSet(tp,g:GetFirst())~=0 and Duel.SelectYesNo(tp,aux.Stringid(11533703,0)) and Duel.IsExistingMatchingCard(c11533703.bgfilter,tp,LOCATION_REMOVED,0,1,nil) then
		Duel.BreakEffect() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local tg=Duel.SelectMatchingCard(tp,c11533703.bgfilter,tp,LOCATION_REMOVED,0,1,1,nil)  
	if tg:GetCount()>0 then  
		Duel.SendtoGrave(tg,REASON_EFFECT+REASON_RETURN)  
	end  
	end
end
