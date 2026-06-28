--髑岩袭来
local s,id=GetID()

--规则上当作「叛骨」卡使用
s.named_with_Rebellion_Skull=1

--判定函数
function s.Rebellion_Skull(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Rebellion_Skull) or (SETCARD_REBELLION_SKULL and c:IsSetCard(SETCARD_REBELLION_SKULL))
end
function s.Skullize(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_Skullize) or (SETCARD_SKULLIZE and c:IsSetCard(SETCARD_SKULLIZE))
end

function s.initial_effect(c)
	--①：选场上1张魔陷破坏，那之后可以融合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	-- Category 包含破坏、特招、融合、除外
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 破坏目标的过滤器
function s.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end

-- 融合素材过滤器
function s.mfilter0(c)
	return c:IsOnField() and c:IsRace(RACE_ZOMBIE) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function s.mfilter1(c,e)
	return s.mfilter0(c) and not c:IsImmuneToEffect(e)
end
function s.mfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and c:IsRace(RACE_ZOMBIE) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end

-- 融合目标过滤器：守备力0的不死族
function s.ffilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_ZOMBIE) and c:IsDefense(0)
		and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and c:CheckFusionMaterial(m,nil,chkf)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 注意：使用 e:GetHandler() 作为例外，确保不选发动中的自身
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	-- 仅注册必发的破坏 OperationInfo
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 1. 破坏处理（非取对象，且排除自身）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	if #dg>0 then
		Duel.HintSelection(dg)
		if Duel.Destroy(dg,REASON_EFFECT)>0 then
			-- 2. 那之后，融合召唤逻辑 (参考 Miracle Fusion)
			local chkf=tp
			local mg1=Duel.GetFusionMaterial(tp):Filter(s.mfilter1,nil,e)
			local mg2=Duel.GetMatchingGroup(s.mfilter2,tp,LOCATION_GRAVE,0,nil)
			mg1:Merge(mg2)
			
			local sg1=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
			
			local mg3=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
			end
			
			if #sg1>0 or (sg2~=nil and #sg2>0) then
				if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					Duel.BreakEffect()
					
					local sg=sg1:Clone()
					if sg2 then sg:Merge(sg2) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=sg:Select(tp,1,1,nil)
					local tc=tg:GetFirst()
					
					if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
						local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
						tc:SetMaterial(mat1)
						Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
						Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
					else
						local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
						local fop=ce:GetOperation()
						fop(ce,e,tp,tc,mat2)
					end
					tc:CompleteProcedure()
				end
			end
		end
	end
end
