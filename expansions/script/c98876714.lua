--繁花之寻芳精
function c98876714.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,98876714+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98876714.spcon)
	c:RegisterEffect(e1)   
	--draw 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98876714,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,18876714)
	e2:SetCost(c98876714.drcost)
	e2:SetTarget(c98876714.drtg)
	e2:SetOperation(c98876714.drop)
	c:RegisterEffect(e2) 
	--atk up 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,28876714)
	e3:SetCost(c98876714.atcost)
	e3:SetTarget(c98876714.attg)
	e3:SetOperation(c98876714.atop)
	c:RegisterEffect(e3) 
	if not c98876714.global_check then
		c98876714.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c98876714.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end 
function c98876714.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do 
	if tc:IsType(TYPE_FUSION) then 
	Duel.RegisterFlagEffect(tc:GetSummonPlayer(),18876714,RESET_PHASE+PHASE_END,0,1)  
	end 
	if tc:IsType(TYPE_SYNCHRO) then 
	Duel.RegisterFlagEffect(tc:GetSummonPlayer(),28876714,RESET_PHASE+PHASE_END,0,1)  
	end 
	if tc:IsType(TYPE_XYZ) then 
	Duel.RegisterFlagEffect(tc:GetSummonPlayer(),38876714,RESET_PHASE+PHASE_END,0,1)  
	end 
	tc=eg:GetNext()
	end
end
function c98876714.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 
		   and Duel.GetFlagEffect(tp,18876714)~=0 
		   and Duel.GetFlagEffect(tp,28876714)~=0
		   and Duel.GetFlagEffect(tp,38876714)~=0	 
end 
function c98876714.dfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c98876714.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable()
		and Duel.IsExistingMatchingCard(c98876714.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c98876714.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end 
function c98876714.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c98876714.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end 
function c98876714.atctfil(c) 
	return c:IsAbleToDeckAsCost() and c:IsCode(95286165,32441317,78610936)  
end 
function c98876714.atcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c98876714.atctfil,tp,LOCATION_GRAVE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK) 
	local g=Duel.SelectMatchingCard(tp,c98876714.atctfil,tp,LOCATION_GRAVE,0,1,99,nil) 
	local x=Duel.SendtoDeck(g,nil,2,REASON_COST) 
	e:SetLabel(x) 
end 
function c98876714.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c98876714.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local x=e:GetLabel() 
	if c:IsFaceup() and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(500*x)
		c:RegisterEffect(e1)
	end 
end 
  










