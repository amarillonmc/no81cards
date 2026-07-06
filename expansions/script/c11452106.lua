--王宫的凶召
local s,id=GetID()
function s.initial_effect(c)
	-- Activate (主效果干干净净，无需任何Cost判断)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	-- Act in hand (将副作用直接写在这个内置权限的 Cost 中)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCost(s.handcost)
	c:RegisterEffect(e2)
	
	-- Granted Effect (被赋予的效果实体)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.discon)
	e3:SetCost(s.discost)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	
	-- Grant (赋予动作)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(s.grtg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end

-- ==================== 手卡发动专属的 Cost ====================
function s.handcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- 直接在此处注册结算后的对方特召效果。
	-- 如果是靠「处刑人」发动的，就不会经过这里，也就不会让对方特召，完美符合 K 社逻辑。
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==e:GetLabel()
end

function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local op=1-tp
	if Duel.GetLocationCount(op,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(s.spfilter,op,LOCATION_HAND,0,nil,e,op)
	if #g>0 and Duel.SelectYesNo(op,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,op,HINTMSG_SPSUMMON)
		local sg=g:Select(op,1,1,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,op,op,false,false,POS_FACEUP)
		end
	end
end

-- ==================== 赋予效果的目标判定 ====================
function s.grtg(e,c)
	-- 必须是效果怪兽，且存在于这张卡的相同纵列（GetColumnGroup自动包含双方场上）
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and e:GetHandler():GetColumnGroup():IsContains(c)
end

-- ==================== 被赋予的无效效果逻辑 ====================
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) 
		and Duel.IsChainNegatable(ev) and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end

function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end