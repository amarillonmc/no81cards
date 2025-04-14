--天启录的神启
function c21170001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21170001+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c21170001.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21170001,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c21170001.con3)
	e3:SetCost(c21170001.cost3)
	e3:SetTarget(c21170001.tg3)
	e3:SetOperation(c21170001.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21170001,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c21170001.con3)
	e4:SetCost(c21170001.cost3)
	e4:SetTarget(c21170001.tg4)
	e4:SetOperation(c21170001.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21170001,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c21170001.con3)
	e5:SetCost(c21170001.cost3)
	e5:SetTarget(c21170001.tg5)
	e5:SetOperation(c21170001.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(21170001,3))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetRange(LOCATION_SZONE)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c21170001.con3)
	e6:SetCost(c21170001.cost3)
	e6:SetTarget(c21170001.tg6)
	e6:SetOperation(c21170001.op6)
	c:RegisterEffect(e6)
end
function c21170001.q(c)
	return c:IsCode(21170001-1) and not c:IsForbidden() and c:CheckUniqueOnField(c:GetControler())
end
function c21170001.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c21170001.q),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(21170001,4)) then
		Duel.Hint(3,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c21170001.con3(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c21170001.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(21170001)==0 end
	e:GetHandler():RegisterFlagEffect(21170001,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
end
function c21170001.f1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c21170001.f2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x6917) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c21170001.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c21170001.f2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c21170001.f2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21170001.op3(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c21170001.f1,nil,e)
	local sg1=Duel.GetMatchingGroup(c21170001.f2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c21170001.f2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
function c21170001.synchro(c)
	return c:IsSynchroSummonable(nil) and c:IsSetCard(0x6917)
end
function c21170001.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21170001.synchro,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21170001.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21170001.synchro,tp,LOCATION_EXTRA,0,nil)
	if #g>0 then
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local tg=g:Select(tp,1,1,nil)
	Duel.SynchroSummon(tp,tg:GetFirst(),nil)
	end
end
function c21170001.xyz(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x6917)
end
function c21170001.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21170001.xyz,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21170001.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21170001.xyz,tp,LOCATION_EXTRA,0,nil)
	if #g>0 then
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local tg=g:Select(tp,1,1,nil)
	Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
function c21170001.link(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x6917)
end
function c21170001.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21170001.link,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21170001.op6(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c21170001.link,tp,LOCATION_EXTRA,0,nil)
	if #g>0 then
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local tg=g:Select(tp,1,1,nil)
	Duel.LinkSummon(tp,tg:GetFirst(),nil)
	end
end