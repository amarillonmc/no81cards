local s,id=GetID()
function s.initial_effect(c)
	-- 记述卡名
	aux.AddCodeList(c,11772015)

	-- ①：场上的这张卡每回合只有1次不会被战斗·效果破坏。
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(s.indct)
	c:RegisterEffect(e1)

	-- ②：自己的主要阶段才能发动。从自己手卡选1张其他卡丢弃，这张卡从手卡特殊召唤。那之后，可以把自己的手卡·场上的怪兽作为融合素材，把1只龙族融合怪兽融合召唤，自己场上有「11772015」存在的场合，对方的手卡给自己确认。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	-- ③：这张卡被效果从手卡丢弃的场合才能发动。这张卡特殊召唤。
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.spcon2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)

	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end

-- ① 效果逻辑：代破判定
function s.indct(e,re,r,rp)
	if (r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)~=0 then
		return 1
	else
		return 0
	end
end

-- ② 效果逻辑
function s.cfilter(c)
	return c:IsDiscardable(REASON_EFFECT)
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_DRAGON) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.chkfilter(c)
	return c:IsFaceup() and c:IsCode(11772015)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 1. 效果丢弃
	if Duel.DiscardHand(tp,s.cfilter,1,1,REASON_EFFECT+REASON_DISCARD,c)>0 then
		-- 2. 特殊召唤
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			
			-- 判断当前是否能融合
			local chkf=tp
			local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
			local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
			local mg2=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
			end
			local can_fuse = (#sg1>0 or (sg2~=nil and #sg2>0))
			
			-- 判断当前是否满足看手卡的初步条件
			local can_look = Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
			
			-- 3. 核心改动：把两者打包为一个追加效果询问
			-- 只要满足其中至少一项，就可以问玩家是否发动
			if (can_fuse or can_look) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				local did_fuse = false
				
				-- ① 如果能融合，执行融合
				if can_fuse then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sg=sg1:Clone()
					if sg2 then sg:Merge(sg2) end
					local tc=sg:Select(tp,1,1,nil):GetFirst()
					if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
						local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
						tc:SetMaterial(mat1)
						Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
						Duel.BreakEffect()
						Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
					else
						local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
						local fop=ce:GetOperation()
						fop(ce,e,tp,tc,mat2)
					end
					tc:CompleteProcedure()
					did_fuse = true
				end

				-- ② 融合结束后，重新判定场上是否有 11772015 且对方有手卡
				if Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
					-- 如果前面刚刚融合过，中间需要插入时点阻断
					if did_fuse then Duel.BreakEffect() end
					
					local g_opp=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
					Duel.ConfirmCards(tp,g_opp)
					Duel.ShuffleHand(1-tp) 
				end
			end
		end
	end
end

-- ③ 效果逻辑
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) and (r&REASON_EFFECT)~=0 and (r&REASON_DISCARD)~=0
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end