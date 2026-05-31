local s,id=GetID()
function s.initial_effect(c)
	-- 记述卡名
	aux.AddCodeList(c,11772015,11772020,11772025)

	-- ①：从自己的场上·墓地把龙族融合怪兽卡决定的融合素材怪兽除外，把那1只融合怪兽从额外卡组融合召唤。把「11772015」，「11772020」，「11772025」融合召唤的场合，也能把手卡的怪兽丢弃作为融合素材。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.fustg)
	e1:SetOperation(s.fusop)
	c:RegisterEffect(e1)

	-- ②：有「11772015」卡名记述的卡被效果从手卡丢弃的场合才能发动。墓地·除外状态的这张卡加入手卡。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

-- ① 效果逻辑：融合判定与执行
function s.mfilter1(c,e)
	-- 场上和墓地：必须能被除外
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function s.mfilter2(c,e)
	-- 手卡：必须能被效果丢弃
	return c:IsDiscardable(REASON_EFFECT) and not c:IsImmuneToEffect(e)
end
function s.spfilter(c,e,tp,m1,m2,chkf)
	-- 限定龙族融合怪兽
	if not (c:IsType(TYPE_FUSION) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	local mg = m1:Clone()
	-- 判断是否是特定的3只怪兽
	if c:IsCode(11772015,11772020,11772025) then
		mg:Merge(m2) -- 融入可以被丢弃的手卡素材
	end
	return c:CheckFusionMaterial(mg,nil,chkf)
end
function s.spfilter_ce(c,e,tp,m,f,chkf)
	-- 兼容连锁素材的过滤
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_DRAGON) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end

function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local m1=Duel.GetMatchingGroup(s.mfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
		local m2=Duel.GetMatchingGroup(s.mfilter2,tp,LOCATION_HAND,0,nil,e)
		local res=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,m1,m2,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.spfilter_ce,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_MZONE+LOCATION_GRAVE)
end

function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local m1=Duel.GetMatchingGroup(s.mfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
	local m2=Duel.GetMatchingGroup(s.mfilter2,tp,LOCATION_HAND,0,nil,e)
	local sg1=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,m1,m2,chkf)
	
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.spfilter_ce,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end

	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mg=m1:Clone()
			-- 再次判定融合目标，动态给予素材库
			if tc:IsCode(11772015,11772020,11772025) then
				mg:Merge(m2)
			end
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat)
			
			-- 根据所选素材的位置剥离处理
			local mat_hand=mat:Filter(Card.IsLocation,nil,LOCATION_HAND)
			local mat_bg=mat:Filter(Card.IsLocation,nil,LOCATION_MZONE+LOCATION_GRAVE)
			
			if #mat_hand>0 then
				-- 手卡部分触发“被效果丢弃且作为融合素材”
				Duel.SendtoGrave(mat_hand,REASON_EFFECT+REASON_DISCARD+REASON_MATERIAL+REASON_FUSION)
			end
			if #mat_bg>0 then
				-- 场上/墓地部分除外
				Duel.Remove(mat_bg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			-- 连锁素材特判路线
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end

-- ② 效果逻辑：因符合条件的卡被丢弃回收自身
function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_EFFECT) and c:IsReason(REASON_DISCARD) and aux.IsCodeListed(c,11772015)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	-- 监听进入墓地/除外区的卡群，只要有任意一张满足条件即满足发动条件
	return eg:IsExists(s.cfilter,1,nil)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end