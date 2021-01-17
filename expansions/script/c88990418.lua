--闪刀姬 吸血鬼千金
function c8899.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,8899)
	e1:SetCost(c8899.spcost)
	e1:SetTarget(c8899.sptg)
	e1:SetOperation(c8899.spop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8899,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c8899.atkcon)
	e2:SetCost(c8899.atkcost)
	e2:SetOperation(c8899.atkop)
	c:RegisterEffect(e2)
end
function c8899.tgfilter(c,tp)
	return c:GetOwner()~=tp and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>-1
end
function c8899.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8899.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c8899.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c8899.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c8899.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c8899.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()
		and (Duel.GetAttacker():IsControler(tp) 
		or Duel.GetAttackTarget():IsControler(tp))
end
function c8899.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(8899)==0
		and Duel.CheckLPCost(tp,100) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,3000)/100)
	local t={}
	for i=1,m do
		t[i]=i*100
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
	e:GetHandler():RegisterFlagEffect(8899,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c8899.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	if c:IsControler(1-tp) then c=Duel.GetAttackTarget() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(e:GetLabel())
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
