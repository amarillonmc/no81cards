--教导的蛟龙神
function c12057810.initial_effect(c)
	--nontuner
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCode(EFFECT_NONTUNER)
	e0:SetValue(c12057810.tnval)
	c:RegisterEffect(e0)
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(12057810,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,12057810)
	e1:SetTarget(c12057810.sptg)
	e1:SetOperation(c12057810.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057810,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22057810)
	e2:SetTarget(c12057810.thtg)
	e2:SetOperation(c12057810.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)	
	--t or p  
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12057810,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,32057810)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c12057810.xthtg)
	e4:SetOperation(c12057810.xthop)
	c:RegisterEffect(e4)
end
function c12057810.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c12057810.thfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x145,0x16b) and c:IsAbleToHand()
end
function c12057810.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057810.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12057810.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12057810.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12057810.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c12057810.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil) 
	if g:GetCount()<=0 then return end 
	local dg=g:Select(tp,1,1,nil) 
	if Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end
function c12057810.xthfilter(c,tp)
	return c:IsSetCard(0x145,0x16b) 
		and (c:IsAbleToHand() or (c:CheckActivateEffect(false,false,false)~=nil and c:CheckActivateEffect(false,false,false):IsActivatable(tp)))
end
function c12057810.xthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057810.xthfilter,tp,LOCATION_REMOVED,0,1,nil,tp) and Duel.GetTurnPlayer()~=tp  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c12057810.xthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c12057810.xthfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect()~=nil and tc:GetActivateEffect():IsActivatable(tp) and tc:CheckActivateEffect(false,false,false)~=nil 
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
		local te,te1=tc:GetActivateEffect()
		local tep=tc:GetControler()
		if not te then return end  
		if tc:IsType(TYPE_FIELD) then 
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)  
		else 
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)  
		end   
		if te1~=nil and te1:IsActivatable(tp) then 
		op=Duel.SelectOption(tp,te:GetDescription(),te1:GetDescription())
		end 
		if op and op==1 then te=te1 end 
			local condition=te:GetCondition()
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
				and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
				and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
				Duel.ClearTargetCard()
				e:SetProperty(te:GetProperty())
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				if tc:IsType(TYPE_CONTINUOUS+TYPE_FIELD) or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then 
				else  
				tc:CancelToGrave(false)
				end
				tc:CreateEffectRelation(te)
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tep,eg,ep,ev,re,r,rp,1) end 
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) 
				if g~=nil then 
				local tg=g:GetFirst()
				while tg do
					tg:CreateEffectRelation(te)
					tg=g:GetNext()
				end
				end
				if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(te)
				if g~=nil then 
				tg=g:GetFirst()
				while tg do
					tg:ReleaseEffectRelation(te)
					tg=g:GetNext()
				end
				end
			else
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
end


