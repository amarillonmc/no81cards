--炎魔的丰壤 莎布尼古拉斯
local s,id,o=GetID()
function s.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,s.matfi1ter,aux.FilterBoolFunction(s.matfi2ter),3,3,true,true)
    --atk up
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.val)
	c:RegisterEffect(e1)
    --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id)
    e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
        return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
    --immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.ccon)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
    if not s.Des_check then
		s.Des_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.matfi1ter(c)
	return c:IsSetCard(0x408) and c:IsType(TYPE_FUSION)
end
function s.matfi2ter(c)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_FIEND)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(Card.IsReason,nil,REASON_DESTROY)
	local val=Duel.GetFlagEffectLabel(tp,id)
    local va2=Duel.GetFlagEffectLabel(1-tp,id)
	if val==nil then 
        Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1,#g)
	else
	    Duel.SetFlagEffectLabel(tp,id,val+#g)
    end
    if va2==nil then 
        Duel.RegisterFlagEffect(1-tp,id,RESET_PHASE+PHASE_END,0,1,#g)
	else
	    Duel.SetFlagEffectLabel(1-tp,id,va2+#g)
    end
end
function s.val(e,c)
    local val=Duel.GetFlagEffectLabel(c:GetControler(),id)
	if val~=nil then return val*500
    else return 0 end
end
function s.fsfilter(c)
	return c:GetOriginalLevel()<=10 and c:IsType(TYPE_FUSION)
end
function s.ccon(e)
	return Duel.GetMatchingGroupCount(s.fsfilter,e:GetHandlerPlayer(),0x04,0,nil)>0
end
function s.efilter(e,re)
	return re:GetOwner()~=e:GetOwner() and re:IsActivated()
end
function s.eq2imit(e,c)
	return c==e:GetLabelObject()
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsDestructable(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,e:GetHandler(),e)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,0x40,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,0x40,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,e:GetHandler(),e)
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,0x40,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,0x40,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local res=false
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			if Duel.Destroy(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)==#mat1 then
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				res=true
			end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
			res=true
		end
		if res then
			tc:CompleteProcedure()
        end
	end
end