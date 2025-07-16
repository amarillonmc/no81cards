--绮奏残律·绯影再响
function c66620515.initial_effect(c)

	-- 从自己的手卡·场上·墓地把「绮奏」融合怪兽卡决定的融合素材怪兽除外，把那1只融合怪兽从额外卡组融合召唤
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,66620515)
	e1:SetTarget(c66620515.target)
	e1:SetOperation(c66620515.activate)
	c:RegisterEffect(e1)
	
	-- 自己主要阶段把这个回合没有送去墓地的这张卡除外，以自己的墓地·除外状态的最多3只「绮奏」怪兽为对象才能发动，那些怪兽回到卡组
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66620515,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,66620516)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c66620515.tdtg)
	e2:SetOperation(c66620515.tdop)
	c:RegisterEffect(e2)
end

-- 从自己的手卡·场上·墓地把「牌佬」融合怪兽卡决定的融合素材怪兽除外，把那1只融合怪兽从额外卡组融合召唤
function c66620515.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end

function c66620515.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end

function c66620515.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x666a) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end

function c66620515.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end

function c66620515.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c66620515.filter0,nil)
		local mg2=Duel.GetMatchingGroup(c66620515.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c66620515.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c66620515.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
end

function c66620515.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c66620515.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c66620515.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c66620515.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c66620515.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if #sg1>0 or (sg2 and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			if mat1:IsExists(Card.IsFacedown, 1, nil) then
				local g=mat1:Filter(Card.IsFacedown, nil)
				Duel.ConfirmCards(1-tp, g)
			end
			Duel.HintSelection(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			if mat2:IsExists(Card.IsFacedown, 1, nil) then
				local g=mat2:Filter(Card.IsFacedown, nil)
				Duel.ConfirmCards(1-tp, g)
			end
			Duel.HintSelection(mat2)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end

-- 自己主要阶段把这个回合没有送去墓地的这张卡除外，以自己的墓地·除外状态的最多3只「绮奏」怪兽为对象才能发动，那些怪兽回到卡组
function c66620515.tdfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666a) and c:IsAbleToDeck()
end

function c66620515.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c66620515.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66620515.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c66620515.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end

function c66620515.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
