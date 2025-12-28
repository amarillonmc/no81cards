--落日残响·彩梦
local s,id,o=GetID()
function s.initial_effect(c)
	--①：召唤/特召回手并发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1b)

	--②：手卡融合（解放素材）
	-- 参数: c, 融合怪兽过滤器(nil=任意), 素材过滤器(可解放), 额外素材函数, 额外素材移动(nil), 素材处理(解放)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SendtoHand(c,nil,REASON_COST)
	-- 回手后保持公开
	if c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,5))
	end
end

-- 墓地过滤器
function s.gyfilter(c,tp)
	return c:IsSetCard(0x614) and Duel.IsExistingMatchingCard(s.deckfilter,tp,LOCATION_DECK,0,1,nil,c)
end

-- 卡组过滤器：同种类，不同名
function s.deckfilter(c,rc)
	return c:IsSetCard(0x614) and not c:IsCode(rc:GetCode())
		and (c:IsAbleToHand() or c:IsSSetable())
		and ( (c:IsType(TYPE_MONSTER) and rc:IsType(TYPE_MONSTER))
		   or (c:IsType(TYPE_SPELL) and rc:IsType(TYPE_SPELL))
		   or (c:IsType(TYPE_TRAP) and rc:IsType(TYPE_TRAP)) )
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 选项1：回复300
	local b1=true
	-- 选项2：墓地匹配搜索 (HOPT)
	local b2=(Duel.GetFlagEffect(tp,id)==0)
		and Duel.IsExistingMatchingCard(s.gyfilter,tp,LOCATION_GRAVE,0,1,nil,tp)

	if chk==0 then return b1 or b2 end

	local ops={}
	local opval={}
	local off=1
	
	ops[off]=aux.Stringid(id,1) -- 回复
	opval[off]=1
	off=off+1
	
	if b2 then
		ops[off]=aux.Stringid(id,2) -- 检索/盖放
		opval[off]=2
		off=off+1
	end

	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	e:SetLabel(sel)

	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300)
	elseif sel==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1) -- 记录使用
	end
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Recover(tp,300,REASON_EFFECT)
	elseif sel==2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4)) -- 选墓地参照卡
		local g1=Duel.SelectMatchingCard(tp,s.gyfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		local tc1=g1:GetFirst()
		if tc1 then
			Duel.HintSelection(g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g2=Duel.SelectMatchingCard(tp,s.deckfilter,tp,LOCATION_DECK,0,1,1,nil,tc1)
			local tc2=g2:GetFirst()
			if tc2 then
				local b_th=tc2:IsAbleToHand()
				local b_set=(tc2:IsSSetable() or tc2:IsCanBeSpecialSummoned(e,POS_FACEDOWN_DEFENSE,tp,false,false))
				local op=0
				if b_th and b_set then
					op=Duel.SelectOption(tp,1190,1153)
				elseif b_th then
					op=0
				else
					op=1
				end
				
				if op==0 then
					Duel.SendtoHand(tc2,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc2)
				else
					if tc2:IsType(TYPE_MONSTER) then
					Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
					else
					Duel.SSet(tp,tc2,tp,true)
					end
				end
			end
		end
	end
end

-- === 效果② ===
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	if c:IsLocation(LOCATION_HAND) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,5))
	end
end

function s.filter0(c)
	return c:IsSetCard(0x614) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x614) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)<=1
end
function s.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)<=1
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then
			local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
				aux.FCheckAdditional=s.fcheck
				aux.GCheckAdditional=s.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
	local exmat=false
	if Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil) then
		local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=s.fcheck
		aux.GCheckAdditional=s.gcheck
	end
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=s.fcheck
				aux.GCheckAdditional=s.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION+REASON_RELEASE)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end