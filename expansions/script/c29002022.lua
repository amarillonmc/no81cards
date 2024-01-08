--方舟骑士-令
c29002022.named_with_Arknight=1
function c29002022.initial_effect(c)
	--special summon condition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e4)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c29002022.spcon1)
	e0:SetOperation(c29002022.spop1)
	c:RegisterEffect(e0)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29002022,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e1:SetCost(c29002022.spcost)
	e1:SetTarget(c29002022.sptg)
	e1:SetOperation(c29002022.spop)
	c:RegisterEffect(e1)
	--change 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e2:SetCode(EVENT_CHAIN_SOLVING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c29002022.cgcon) 
	e2:SetOperation(c29002022.cgop) 
	c:RegisterEffect(e2)
	if not c29002022.global_check then
		c29002022.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c29002022.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
c29002022.kinkuaoi_Akscsst=true
function c29002022.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(0,29002022,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c29002022.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local x=Duel.GetFlagEffect(0,29002022)
	return x>=12 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c29002022.spop1(e,tp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29002022.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c29002022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,29065548,0,TYPES_TOKEN_MONSTER,2500,2500,12,RACE_WYRM,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c29002022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,29065548,0,TYPES_TOKEN_MONSTER,2500,2500,12,RACE_WYRM,ATTRIBUTE_WIND) then return end
	local token=Duel.CreateToken(tp,29065548)
	c:CreateRelation(token,RESET_EVENT+RESETS_STANDARD)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c29002022.tokendescon)
	e6:SetOperation(c29002022.tokendesop)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e6,true)
	Duel.SpecialSummonComplete()
end
function c29002022.tokendescon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c29002022.tokendesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end
function c29002022.rlfil(c) 
	return c:IsType(TYPE_TOKEN) and c:IsReleasable() 
end 
function c29002022.cgcon(e,tp,eg,ep,ev,re,r,rp) 
	return rp==1-tp and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065548) and Duel.IsExistingMatchingCard(c29002022.rlfil,tp,LOCATION_MZONE,0,1,nil)
end  
function c29002022.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c29002022.repop)   
end 
function c29002022.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,29002022) 
	local g=Duel.GetMatchingGroup(c29002022.rlfil,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.Release(sg,REASON_EFFECT)
	end 
end




