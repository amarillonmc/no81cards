local s, id = GetID()


function s.initial_effect(c)
	-- 同调召唤条件：同调调整 + 幻龙族同调怪兽1只以上
	c:EnableReviveLimit()   
	 aux.AddSynchroMixProcedure(c,aux.Tuner(Card.IsType, TYPE_SYNCHRO),nil,nil,aux.NonTuner(nil),1,99,s.syncheck(c))
	
	
	-- 效果①：无效并除外魔陷/怪兽效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	
	-- 效果②：除外自身特召额外卡组3只怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1)
	e3:SetCondition(s.retcon)
	e3:SetTarget(s.rettg)
	e3:SetOperation(s.retop)
	c:RegisterEffect(e3)
end

function s.cfilter(c, syncard)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_WYRM) and c:IsNotTuner(syncard)
end

function s.syncheck(syncard)
	return  function(g)
				return g:IsExists(s.cfilter, 1, nil, syncard)
			end
end

--===== 效果①：无效+除外 =====--
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
		and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

--===== 效果②：除外自身特召额外卡组3只怪兽 =====--
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	-- 正确实现暂时除外并记录状态
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end

function s.spfilter(c,e,tp)
	return c:IsCode(95060210,95060220,95060230) 
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>1  -- 精确检测每个怪兽的位置
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 必须同时满足3个位置和3只不同卡名的存在
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		return g:GetClassCount(Card.GetCode)>=3  -- 确保存在3种不同卡名
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	-- 严格按名称各选1只
	local codes={95060210,95060220,95060230}
	local g=Group.CreateGroup()
	for _,code in ipairs(codes) do
		local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		local tc=sg:FilterSelect(tp,Card.IsCode,1,1,nil,code):GetFirst()
		if tc then g:AddCard(tc) end
	end
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)  
	
end

--===== 效果③：下个准备阶段特召自身 =====--
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)>0
end

function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end