--人与人，世界与世界
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

function s.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		--local mg0=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
		--mg1:Merge(mg0)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
			local mg0=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
			mg1:Merge(mg0)
		end
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
	--local mg0=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
	--mg1:Merge(mg0)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		local mg0=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg0)
	end
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
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat_used=nil  -- 用于记录第一次融合使用的素材
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			mat_used=mat1
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
			mat_used=mat2
		end
		tc:CompleteProcedure()
		local fusion_group = Group.CreateGroup()
		fusion_group:AddCard(tc)

		if mat_used and mat_used:GetCount()>0 then
			local extra_group=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_FUSION)
			local candidates={}
			local fc = extra_group:GetFirst()
    	while fc do
        if fc ~= tc and fc:CheckFusionMaterial(mat_used, nil, PLAYER_NONE) then
            table.insert(candidates, fc)
        end
        fc = extra_group:GetNext()
    	end
			if #candidates>0 then
				if Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
					Duel.BreakEffect()
					Duel.Remove(mat_used,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
					local new_fc
					if #candidates==1 then
						new_fc=candidates[1]
					else
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						new_fc=Duel.SelectMatchingCard(tp,function(c) return c:IsType(TYPE_FUSION) and c~=tc and c:CheckFusionMaterial(mat_used,nil,PLAYER_NONE) end,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
					end
					if new_fc then
						--new_fc:SetMaterial(mat_used)
						Duel.BreakEffect()
						Duel.SpecialSummon(new_fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
						new_fc:CompleteProcedure()
						fusion_group:AddCard(new_fc)
					end
				end
			end
		end
		if fusion_group:GetCount() > 0 then
			fusion_group:KeepAlive()
			local e_restrict = Effect.CreateEffect(e:GetHandler())
			e_restrict:SetType(EFFECT_TYPE_FIELD)
			e_restrict:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e_restrict:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e_restrict:SetTargetRange(1, 0)
			e_restrict:SetLabelObject(fusion_group)  -- 现在传入的是 Group 对象
			e_restrict:SetTarget(s.summonlimit)
			e_restrict:SetReset(RESET_PHASE + PHASE_END + RESET_SELF_TURN, 2)
			Duel.RegisterEffect(e_restrict, tp)
		end
	end
end

function s.summonlimit(e, c, sp, sumtype, sumpos, targetp, se)
	if not c:IsLocation(LOCATION_EXTRA) then return false end
  if not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA) then return true end
	local fusion_group = e:GetLabelObject()
	local numm = fusion_group:GetCount()
  if not fusion_group or fusion_group:GetCount() == 0 then return false end
	if c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_FUSION) then
		local tc1 = fusion_group:GetFirst()
		local race1 = tc1:GetRace()
		local attr1 = tc1:GetAttribute()
		local tc2 = fusion_group:GetNext()
		local hasSecond = (tc2 ~= nil)
		if hasSecond then
    	local race2 = tc2:GetRace()
    	local attr2 = tc2:GetAttribute()
    	if (c:GetRace() == race1 or c:GetAttribute() == attr1) or
      (c:GetRace() == race2 or c:GetAttribute() == attr2) then
        return false  -- 允许特殊召唤
    	else
        return true   -- 禁止
    end
		else
    	if c:GetRace() == race1 or c:GetAttribute() == attr1 then
        return false
    	else
        return true
    	end
		end
	end
  return true  -- 禁止特殊召唤
end

function debug_log(...)
    local args = {...}
    local message = table.concat(args, " ")
    error("[DEBUG] " .. message, 0) -- 注意最后的 0，表示不显示调用栈信息，只输出消息
end