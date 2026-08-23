--反叛的古之咬 英雄史诗奏
function c28355662.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c28355662.excondition)
	e0:SetCost(c28355662.excost)
	e0:SetDescription(aux.Stringid(28355662,0))
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(c28355662.cost)
	e1:SetTarget(c28355662.target)
	e1:SetOperation(c28355662.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28355662.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c28355662.destg)
	e2:SetOperation(c28355662.desop)
	c:RegisterEffect(e2)
end
function c28355662.excondition(e)
	return Duel.GetLP(e:GetHandlerPlayer())~=4000
end
function c28355662.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetLP(tp,4000)
end
function c28355662.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)<=3000 or Duel.CheckLPCost(tp,2000) end
	if Duel.GetLP(tp)>3000 then Duel.PayLPCost(tp,2000) end
end
function c28355662.spfilter(c,e,tp)
	return c:IsSetCard(0x285) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,1-tp)-- and (Duel.GetMZoneCount(1-tp,nil,tp,LOCATION_REASON_CONTROL)>0 or Duel.GetFieldCard(tp,LOCATION_MZONE,2) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,0x4))--c:IsAbleToChangeControler() and 
end
function c28355662.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28355662.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(1-tp)>0 end-- and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	--local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	--Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28355662.efffilter(c)
	return c:IsSetCard(0x285) and c:IsFaceup() and c.effop
end
function c28355662.mfilter(c,tp,e)
	return c:GetSequence()==2 and (c:IsFaceup() or c:IsControler(tp)) and (not e or not c:IsImmuneToEffect(e) and c:IsDestructable(e))
end
function c28355662.ffilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c28355662.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(1-tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c28355662.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	--[[local kc=Duel.GetFieldCard(tp,LOCATION_MZONE,2)--kogane
	local zone=0xff
	if Duel.GetMZoneCount(1-tp,nil,tp,LOCATION_REASON_CONTROL)==0 and not kc then zone=0x4 end]]
	if not sc or Duel.SpecialSummon(sc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)==0 then return end
	if c28355662.fstg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(28355662,2)) then
		Duel.BreakEffect()
		c28355662.fsop(e,tp,eg,ep,ev,re,r,rp)
	end
	--[[kc=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
	local b1=sc:IsControlerCanBeChanged()
	local b2=kc
	if not (b1 or b2) then return end
	local op=b1 and 0 or 1
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(28355662,0),aux.Stringid(28355662,1)) end
	if op==0 and Duel.GetControl(sc,1-tp)==0 or op==1 and Duel.Destroy(kc,REASON_EFFECT)==0 then return end
	--not pinch
	local g=Duel.GetMatchingGroup(c28355662.efffilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then return end
	Duel.BreakEffect()
	for tc in aux.Next(g) do
		tc.effop(tc)
	end]]
end
function c28355662.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c28355662.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
		local res=Duel.IsExistingMatchingCard(c28355662.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c28355662.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
end
function c28355662.fsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c28355662.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp,e)
	local sg1=Duel.GetMatchingGroup(c28355662.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c28355662.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			if Duel.Destroy(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)==#mat1 then
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c28355662.descon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsAttackAbove(Duel.GetLP(tp)) and at:IsRelateToBattle()
end
function c28355662.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c28355662.gcheck(g)
	return g:FilterCount(Card.IsControler,nil,0)<=1 and g:FilterCount(Card.IsControler,nil,1)<=1
end
function c28355662.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:SelectSubGroup(tp,c28355662.gcheck,false,1,2)
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
end
