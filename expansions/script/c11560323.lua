--咒箱女王·娜哈特·娜哈特
function c11560323.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,function(c) return c.SetCard_XdMcy end,8,3) 
	c:EnableReviveLimit() 
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)   
	e1:SetRange(LOCATION_EXTRA)  
	e1:SetCountLimit(1,11560323+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c11560323.xxcon) 
	e1:SetOperation(c11560323.xxop) 
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21560323)
	e2:SetTarget(c11560323.rmtg)
	e2:SetOperation(c11560323.rmop)
	c:RegisterEffect(e2)
end
c11560323.SetCard_XdMcy=true  
function c11560323.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic()	
end 
function c11560323.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.ConfirmCards(1-tp,c) 
	Duel.Hint(HINT_CARD,0,11560323) 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(11560323,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c11560323.yspcost)
	e1:SetTarget(c11560323.ysptg)
	e1:SetOperation(c11560323.yspop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT) 
	e2:SetTargetRange(LOCATION_HAND,0) 
	e2:SetTarget(function(e,c) 
	return c:IsType(TYPE_TRAP+TYPE_SPELL) and c.SetCard_XdMcy end)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)


end  
function c11560323.yspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c11560323.ysfilter1(c,e,tp)
	local lv=c:GetLevel()
	return c.SetCard_XdMcy and lv>0 and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c11560323.ysfilter2,tp,LOCATION_DECK,0,1,c,e,tp,c:GetLevel()) 
end
function c11560323.ysfilter2(c,e,tp,lv)
	return c.SetCard_XdMcy and c:IsType(TYPE_RITUAL) and c:IsLevelBelow(lv) and c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c11560323.ysptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c11560323.ysfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)  
		and Duel.GetFlagEffect(tp,11560323)==0
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11560323.ysfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,11560323,RESET_CHAIN,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11560323.yspop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11560323.ysfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end




function c11560323.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end  
function c11560323.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then 
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	end 
end 
function c11560323.imop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(function(e,te) 
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end)  
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
end 







