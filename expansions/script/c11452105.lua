--紫炁星辰 (シキ・ドラコテイル)
local s,id,o=GetID()
local cm = s

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 检查魔陷在墓地是否可以发动效果 (引入官方完整参数检查)
function s.check_te(c,e,tp)
	local te,ceg,cep,cev,cre,cr,crp=c:CheckActivateEffect(false,true,true)
	if not te then return false end
	local tg=te:GetTarget()
	if not tg then return true end
	local _IsExistingTarget=Duel.IsExistingTarget
	Duel.IsExistingTarget=function(f,p,s,o,ct,ex,...) return _IsExistingTarget(f,p,s,o,ct,e:GetHandler(),...) end
	local res=tg(te,tp,ceg,cep,cev,cre,cr,crp,0,nil)
	Duel.IsExistingTarget=_IsExistingTarget
	return res
end

function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end

function s.filter2(c,e,tp,m,tc,f,chkf)
	-- 【1】备份原版 Auxiliary 调度函数
	local _FConditionFilterMix = Auxiliary.FConditionFilterMix
	local _FSelectMixRep = Auxiliary.FSelectMixRep
	local _FCheckMixRepGoal = Auxiliary.FCheckMixRepGoal
	local _FCheckMixGoal = Auxiliary.FCheckMixGoal
	local _IsLocation=Card.IsLocation
	-- 【2】拦截初筛：强行让 tc 进入候选池 (mg)
	--[[Auxiliary.FConditionFilterMix = function(t, fc, sub, concat_fusion, ...)
		if t == tc then return true end
		return _FConditionFilterMix(t, fc, sub, concat_fusion, ...)
	end

	Auxiliary.FSelectMixRep = function(c, tp, mg, sg, fc, sub, chkfnf, fun1, minc, maxc, ...)
		-- 给所有的 fun 套上 tc 免检外衣
		local w_fun1 = function(card, ...) if card == tc then return true end return fun1(card, ...) end
		local args = {...}
		for i=1, #args do
			if type(args[i]) == "function" then
				local orig = args[i]
				args[i] = function(card, ...) if card == tc then return true end return orig(card, ...) end
			end
		end
		return _FSelectMixRep(c, tp, mg, sg, fc, sub, chkfnf, w_fun1, minc, maxc, table.unpack(args))
	end

	Auxiliary.FCheckMixRepGoal = function(p, sg, fc, sub, chkfnf, fun1, minc, maxc, ...)
		
		local w_fun1 = function(card, ...) if card == tc then return true end return fun1(card, ...) end
		local args = {...}
		for i=1, #args do
			if type(args[i]) == "function" then
				local orig = args[i]
				args[i] = function(card, ...) if card == tc then return true end return orig(card, ...) end
			end
		end
		return _FCheckMixRepGoal(p, sg, fc, sub, chkfnf, w_fun1, minc, maxc, table.unpack(args))
	end
	function Auxiliary.FCheckMixGoal(sg,tp,fc,sub,chkfnf,...)
		local args = {...}
		for i=1, #args do
			if type(args[i]) == "function" then
				local orig = args[i]
				args[i] = function(card, ...) if card == tc then return true end return orig(card, ...) end
			end
		end
		return _FCheckMixGoal(sg,tp,fc,sub,chkfnf,table.unpack(args))
	end--]]
	
	Card.IsLocation=function(c,loc) if c==tc and c:IsExtraDeckMonster() then return loc&LOCATION_EXTRA>0 elseif c==tc then return loc&LOCATION_HAND>0 else return _IsLocation(c,loc) end end

	--Debug.Message(Card.IsLocation)
	local res=c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
	local chk=c:CheckFusionMaterial(m,tc,chkf)
	if res and not chk and Duel.DisableActionCheck then
		Duel.DisableActionCheck(true)
		local token=Duel.CreateToken(tp,c:GetOriginalCode())
		Duel.DisableActionCheck(false)
		chk=token:CheckFusionMaterial(m,tc,chkf)
	end
	
	-- 【5】阅后即焚，不留痕迹地恢复现场
	Auxiliary.FConditionFilterMix = _FConditionFilterMix
	Auxiliary.FSelectMixRep = _FSelectMixRep
	Auxiliary.FCheckMixRepGoal = _FCheckMixRepGoal
	Auxiliary.FCheckMixGoal = _FCheckMixGoal
	Card.IsLocation = _IsLocation
	return res and chk
end

function s.cfilter(c,e,tp)
	if not c:IsSetCard(0x1c9) or not c:IsCanBeEffectTarget(e) then return false end
	if c:IsType(TYPE_MONSTER) then
		if not c:IsAbleToHand() and not c:IsAbleToExtra() then return false end
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		mg1:AddCard(c)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,c,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				mg2:AddCard(c)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,c,mf,chkf)
			end
		end
		return res
	elseif c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsAbleToDeck() and s.check_te(c,e,tp)
	end
	return false
end

function s.rescon(sg,e,tp,mg)
	local m=sg:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	local sp=sg:FilterCount(Card.IsType,nil,TYPE_SPELL)
	local tr=sg:FilterCount(Card.IsType,nil,TYPE_TRAP)
	return m<=1 and sp<=1 and tr<=1
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then
		return e:IsCostChecked() and Duel.IsExistingTarget(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=mg:SelectSubGroup(tp,s.rescon,false,1,3)
	Duel.SetTargetCard(sg) 
	Duel.ClearTargetCard()
	e:SetProperty(0)
	local st=sg:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
	local m=sg:Filter(Card.IsType,nil,TYPE_MONSTER)
	cm[e]={}
	for tc in aux.Next(st) do
		-- 【官方标准】提取完整的事件变量
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
		if te then
			-- 【官方标准】建立效果关联
			tc:CreateEffectRelation(e)
			local tg=te:GetTarget()
			e:SetProperty(e:GetProperty()|te:GetProperty())
			if tg then
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				
				local _SelectTarget=Duel.SelectTarget
				Duel.SelectTarget=function(sp,f,p,s,o,min,max,ex,...) cm[te]=_SelectTarget(sp,f,p,s,o,min,max,c,...):Clone() cm[te]:KeepAlive() return cm[te] end
				local _SetTargetCard=Duel.SetTargetCard
				Duel.SetTargetCard=function(g) _SetTargetCard(g) local sg if aux.GetValueType(g)=="Card" then sg=Group.FromCards(g) else sg=g:Clone() end cm[te]=sg cm[te]:KeepAlive() end
				
				-- 【官方标准】使用捕获的事件变量调用目标函数
				tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
				te:SetLabelObject(e:GetLabelObject())
				cm[e][tc]=te

				Duel.SelectTarget=_SelectTarget
				Duel.SetTargetCard=_SetTargetCard
			end
		end
	end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.SetTargetCard(m)
	sg:KeepAlive()
	cm[e][c]=sg
	Duel.ClearOperationInfo(0)
	if #sg>#m then Duel.SetOperationInfo(0,CATEGORY_TODECK,sg-m,#sg-#m,0,0) end
	if #m>0 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,m,#m,0,0) end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=cm[e][c]:Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	
	-- == 操作1：魔法·陷阱卡回到卡组并适用效果 ==
	local st=g:Filter(Card.IsType,nil,TYPE_SPELL+TYPE_TRAP)
	while st:FilterCount(Card.IsRelateToEffect,nil,e)>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=st:Filter(Card.IsRelateToEffect,nil,e):Select(tp,1,1,nil):GetFirst()
		st:RemoveCard(tc)
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and cm[e] and cm[e][tc] then
			local te = cm[e][tc] --tc:GetActivateEffect()
			local op = te:GetOperation()
			if op then
				-- 【官方标准】使用当前事件的变量执行 operation
				e:SetProperty(te:GetProperty())
				Duel.ClearTargetCard()
				if aux.GetValueType(cm[te])=="Group" then
					Duel.SetTargetCard(cm[te])
					cm[te]:DeleteGroup()
					cm[te] = nil
				end
				op(e,tp,eg,ep,ev,re,r,rp)
				e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			end
		end
	end
	
	-- == 操作2：怪兽回到手卡·额外卡组并融合 ==
	local m=g:Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsType,nil,TYPE_MONSTER)
	if #m>0 then
		local tc=m:GetFirst()
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		if not tc:IsRelateToEffect(e) then return end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if tc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
			
			local chkf=tp
			local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
			mg1:AddCard(tc)
			local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,tc,nil,chkf)
			
			local mg2=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg2=fgroup(ce,e,tp)
				mg2:AddCard(tc)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,tc,mf,chkf)
			end
			
			if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local f_mon=tg:GetFirst()
				if sg1:IsContains(f_mon) and (sg2==nil or not sg2:IsContains(f_mon) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
					local mat1=Duel.SelectFusionMaterial(tp,f_mon,mg1,tc,chkf)
					f_mon:SetMaterial(mat1)
					Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
					Duel.BreakEffect()
					Duel.SpecialSummon(f_mon,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				else
					local mat2=Duel.SelectFusionMaterial(tp,f_mon,mg2,tc,chkf)
					local fop=ce:GetOperation()
					fop(ce,e,tp,f_mon,mat2)
				end
				f_mon:CompleteProcedure()
			end
		end
	end
end