--阿巴阿巴拟人太阳花
function c21185695.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21185695)
	e1:SetCost(c21185695.cost)
	e1:SetTarget(c21185695.tg)
	e1:SetOperation(c21185695.op)
	c:RegisterEffect(e1)
	if not c21185695_discard_check then
		c21185695_discard_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetCondition(c21185695.gecon)
		ge1:SetOperation(c21185695.geop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_REMOVE)
		Duel.RegisterEffect(ge2,0)
	end	
end
function c21185695.gecon(e,tp,eg,ep,ev,re,r,rp)
	local a = 
		function(c) return 
		c:IsReason(REASON_COST+REASON_DISCARD) and c:IsPreviousLocation(LOCATION_HAND)	
		and c:IsType(TYPE_MONSTER)
		end;
	local chain = Duel.GetChainInfo(ev,CHAININFO_CHAIN_COUNT)	
	if chain and chain<=0 then return end
	if not chain then return end
	local dg=eg:Filter(a,nil)
	return #dg>0
end
function c21185695.geop(e,tp,eg,ep,ev,re,r,rp)
	local a = 
		function(c) return 
		c:IsReason(REASON_COST+REASON_DISCARD) and c:IsPreviousLocation(LOCATION_HAND)
		and c:IsType(TYPE_MONSTER)
		end;
	local dg=eg:Filter(a,nil)
	for tc in aux.Next(dg) do 
	tc:RegisterFlagEffect(21185695,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c21185695.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c21185695.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a = 
		function(c) return 
		c:GetFlagEffect(21185695)>0 and c:IsFaceupEx() and not c:IsCode(21185695) and c:IsAbleToHand()
		end;	
	local g=Duel.GetMatchingGroup(a,0,0x30,0x30,nil)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c21185695.op(e,tp,eg,ep,ev,re,r,rp)
	local a = 
		function(c) return 
		c:GetFlagEffect(21185695)>0 and c:IsFaceupEx() and not c:IsCode(21185695) and c:IsAbleToHand()
		end;
	local g=Duel.GetMatchingGroup(a,0,0x30,0x30,nil)
	if #g<=0 then return end
	local dg=g:Filter(aux.NecroValleyFilter,nil)
	if #dg>0 then
	Duel.SendtoHand(dg,nil,REASON_EFFECT)
	end
end