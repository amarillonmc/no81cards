local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddFusionProcCodeFunRep(c,s.matfilter,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),2,63,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.accost)
	e1:SetOperation(s.acop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.fscon)
	e2:SetTarget(s.fstg)
	e2:SetOperation(s.fsop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local sg=Group.CreateGroup()
		sg:KeepAlive()
		local ge0=Effect.GlobalEffect()
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetLabelObject(sg)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
	end
end
function s.matfilter(c,fc)
	return c:IsRace(RACE_INSECT) and c:IsFusionType(TYPE_FUSION)
end
function s.costfilter(c,tp)
	return c:GetFlagEffect(id)>0 and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK,0,1,c,tp)
end
function s.tffilter(c,tp)
	return c:GetType()&0x20002==0x20002 and c:GetActivateEffect():IsActivatable(tp)
end
function s.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sc=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if not sc then return end
	Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=sc:GetActivateEffect()
	local tep=sc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	Duel.RaiseEvent(sc,73734821,te,0,tp,tp,Duel.GetCurrentChain())
end
function s.fscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function s.ffilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.spfil1(c,tc,tp)
	return math.abs(tc:GetSequence()-c:GetSequence())==1 and c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(s.spfil2,tp,LOCATION_GRAVE,0,1,tc,c:GetSequence())
end
function s.spfil2(c,seq)
	return math.abs(seq-c:GetSequence())==1 and s.mfilter(c)
end
function s.fcheck(tp,sg,fc)
	if #sg>2 then return false end
	if #sg==1 then
		local seq=sg:GetFirst():GetSequence()
		return Duel.IsExistingMatchingCard(function(sc,seq)return math.abs(seq-sc:GetSequence())==1 and s.mfilter(sc)end,tp,LOCATION_GRAVE,0,1,nil,seq) or Duel.IsExistingMatchingCard(s.spfil1,tp,LOCATION_GRAVE,0,1,nil,sg:GetFirst(),tp)
	else
		local seq1=sg:GetFirst():GetSequence()
		local seq2=sg:GetNext():GetSequence()
		return math.abs(seq1-seq2)==1 or (math.abs(seq1-seq2)==2 and Duel.IsExistingMatchingCard(function(sc,seq1,seq2)return sc:GetSequence()==(seq1+seq2)/2 and sc:IsType(TYPE_SPELL+TYPE_TRAP)end,tp,LOCATION_GRAVE,0,1,nil,seq1,seq2))
	end
end
function s.gcheck(tp)
	return  function(sg)
				if #sg~=2 then return false end
				local seq1=sg:GetFirst():GetSequence()
				local seq2=sg:GetNext():GetSequence()
				return math.abs(seq1-seq2)==1 or (math.abs(seq1-seq2)==2 and Duel.GetMatchingGroup(function(sc,seq1,seq2)return sc:GetSequence()==(seq1+seq2)/2 and sc:IsType(TYPE_SPELL+TYPE_TRAP)end,tp,LOCATION_GRAVE,0,nil,seq1,seq2))
			end
end
function s.fcheck2(tp,sg,fc)
	return #sg==2
end
function s.gcheck2(sg)
	return #sg==2
end
function s.fstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil)
		aux.FCheckAdditional=s.fcheck
		aux.GCheckAdditional=s.gcheck(tp)
		local res=Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=s.fcheck2
		aux.GCheckAdditional=s.gcheck2
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_GRAVE)
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil)
	aux.FCheckAdditional=s.fcheck
	aux.GCheckAdditional=s.gcheck(tp)
	local sg1=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=s.fcheck2
	aux.GCheckAdditional=s.gcheck2
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	local thc=nil
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2~=nil then sg:Merge(sg2) end
		::cancel::
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc)
			or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			aux.FCheckAdditional=s.fcheck
			aux.GCheckAdditional=s.gcheck(tp)
			local mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			if #mat<2 then goto cancel end
			local seq1=mat:GetFirst():GetSequence()
			local seq2=mat:GetNext():GetSequence()
			thc=Duel.GetFirstMatchingCard(function(sc,seq1,seq2)return sc:GetSequence()==(seq1+seq2)/2 and sc:IsType(TYPE_SPELL+TYPE_TRAP)end,tp,LOCATION_GRAVE,0,nil,seq1,seq2)
			tc:SetMaterial(mat)
			Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			aux.FCheckAdditional=s.fcheck2
			aux.GCheckAdditional=s.gcheck2
			local mat=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			if #mat<2 then goto cancel end
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
	if Duel.GetOperatedGroup():GetCount()>0 and thc and thc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.SendtoHand(thc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thc)
	end
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,sg)
	if #g==0 then return end
	sg:Merge(g)
	local cp={}
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		if te:GetCode()==EVENT_BECOME_TARGET and te:IsActivated() and te:GetType()&EFFECT_TYPE_SINGLE~=0 then table.insert(cp,te:Clone()) end
		return f(tc,te,bool)
	end
	for tc in aux.Next(g) do
		Duel.CreateToken(tp,tc:GetOriginalCode())
		if #cp>0 then tc:RegisterFlagEffect(id,0,0,0) end
		cp={}
	end
	Card.RegisterEffect=f
end
