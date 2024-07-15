--齐驱之刃 影潜者 奥纽克斯
function c40011516.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)   
	--set 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40011516)  
	e2:SetTarget(c40011516.settg)
	e2:SetOperation(c40011516.setop)
	c:RegisterEffect(e2)   
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	--trap effect 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE) 
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,40011516+1)
	e3:SetCondition(c40011516.discon) 
	e3:SetTarget(c40011516.distg)
	e3:SetOperation(c40011516.disop)
	c:RegisterEffect(e3) 
end
function c40011516.setfilter(c)
	return c:IsSetCard(0xaf1b) and not c:IsCode(40011516) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c40011516.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40011516.setfilter,tp,LOCATION_DECK,0,1,nil) end 
end
function c40011516.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c40011516.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(TYPE_TRAP)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c40011516.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if not (c:IsFacedown()) then return false end 
	return rp==1-tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainDisablable(ev) 
	and (e:GetHandler():GetTurnID()~=Duel.GetTurnCount() or e:GetHandler():IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN)) 
end 
function c40011516.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40011516.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		c:CancelToGrave() 
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsEnvironment(40011525,tp) and Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xaf1b) and c:IsAbleToGrave() end,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(40011516,0)) then  
			Duel.BreakEffect()
			local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0xaf1b) and c:IsAbleToGrave() end,tp,LOCATION_DECK,0,1,1,nil) 
			Duel.SendtoGrave(sg,REASON_EFFECT) 
		end 
	end 
end 






