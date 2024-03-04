--重兵装型女子高中生・肆
function c67670304.initial_effect(c)
	--cannot be material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(c67670304.limit)
	c:RegisterEffect(e1)   
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)  
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(67670304,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,67670304*1)
	e7:SetTarget(c67670304.sptg)
	e7:SetOperation(c67670304.spop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8) 
	--ex attack
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(67670304,1))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e9:SetRange(LOCATION_GRAVE)
	e9:SetCountLimit(1,67670304*2)
	e9:SetCost(c67670304.imcost)
	e9:SetTarget(c67670304.imtg)
	e9:SetOperation(c67670304.imop)
	c:RegisterEffect(e9)   
end 
function c67670304.limit(e,c,sumtype)
	if not c then return false end
	return not c:IsSetCard(0x1b7)
end
--spsummon
function c67670304.spfilter(c,e,tp)
	return c:IsSetCard(0x1b7) and not c:IsCode(67670304) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67670304.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c67670304.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local h1=Duel.Draw(tp,1,REASON_EFFECT)
	if h1>0 and Duel.IsExistingMatchingCard(c67670304.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(67670304,1)) then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c67670304.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--ex attack
function c67670304.costfilter(c)
	return c:IsSetCard(0x1b7) and c:IsAbleToRemoveAsCost()
end
function c67670304.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c67670304.costfilter,tp,LOCATION_GRAVE,0,c)
	if chk==0 then return c:IsAbleToRemoveAsCost() and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,1,nil)
	sg:AddCard(c)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c67670304.imfilter(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x1b7)
end
function c67670304.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tp=e:GetHandler():GetControler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67670304.imfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67670304.imfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c67670304.imfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c67670304.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--ex attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1) 
	end
end

