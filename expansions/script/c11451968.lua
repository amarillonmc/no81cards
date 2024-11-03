--秘计螺旋 陨击
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,m-5)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetLabelObject(e1)
	e3:SetTargetRange(1,1)
	e3:SetTarget(cm.actarget)
	e3:SetOperation(cm.costop)
	Duel.RegisterEffect(e3,0)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.chcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.chtg)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ct=Duel.GetTurnCount()-c:GetTurnID()
		if not (c:IsLocation(LOCATION_SZONE) and c:IsFacedown()) then ct=1 end
		local eset={c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN)}
		return ct+#eset>1
	end
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTurnCount()-c:GetTurnID()
	if not (c:IsLocation(LOCATION_SZONE) and c:IsFacedown()) then ct=1 end
	local eset={c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN)}
	if ct==1 then
		local tab=cm[flag]
		local options={}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		eset[op+1]:UseCountLimit(tp,1)
	end
	if ct==0 then
		Debug.Message("请依次选择两个「在盖放的回合发动」效果。")
		local tab=cm[flag]
		local options={}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(options))
		eset[op+1]:UseCountLimit(tp,1)
		table.remove(eset,op+1)
		options={}
		for _,te in ipairs(eset) do
			table.insert(options,te:GetDescription())
		end
		op=Duel.SelectOption(tp,table.unpack(options))
		eset[op+1]:UseCountLimit(tp,1)
		Debug.Message("选择完毕。")
	end
end
function cm.filter(c)
	return c:IsCode(m-5) and c:CheckActivateEffect(false,false,false)~=nil
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (Duel.GetLocationCount(tp,LOCATION_SZONE)>1 or e:GetHandler():IsOnField()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil,code)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		local tc=sg:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true)
		te:UseCountLimit(tp,1,true)
		local cost=te:GetCost()
		local target=te:GetTarget()
		local operation=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if not tc:IsType(TYPE_EQUIP) then tc:CancelToGrave(false) end
		tc:CreateEffectRelation(te)
		if cost then cost(te,tp,ceg,cep,cev,cre,cr,crp,1) end
		if target then target(te,tp,ceg,cep,cev,cre,cr,crp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			for fc in aux.Next(g) do
				fc:CreateEffectRelation(te)
			end
		end
		if operation then
			operation(te,tp,ceg,cep,cev,cre,cr,crp)
			Duel.BreakEffect()
			operation(te,tp,ceg,cep,cev,cre,cr,crp)
			Duel.BreakEffect()
			operation(te,tp,ceg,cep,cev,cre,cr,crp)
		end
		tc:ReleaseEffectRelation(te)
		if g then
			for fc in aux.Next(g) do
				fc:ReleaseEffectRelation(te)
			end
		end
	end   
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x836)
end
function cm.filter0(c)
	return c:IsCanBeFusionMaterial()
end
function cm.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if rp==tp then
			local chkf=tp
			local mg1=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_ONFIELD,0,nil)
			local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
			if not res then
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					local mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				end
			end
			return res
		else return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_EXTRA,1,nil) end
	end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_ONFIELD,0,nil)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
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
	end
end