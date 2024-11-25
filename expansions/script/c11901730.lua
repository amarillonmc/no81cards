--炎魔的禁忌 普罗米修斯
local s,id,o=GetID()
function s.initial_effect(c)
    aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	c:EnableReviveLimit()
    --Fusion
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(function(e) 
	    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --Equip
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE) 
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetTarget(s.htgtg) 
	e2:SetOperation(s.htgop) 
	c:RegisterEffect(e2)
    --Desed
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+1)
    e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.ffilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.filter0(c,tid)
	return (c:IsLocation(0x10) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
        and c:IsReason(REASON_DESTROY) and c:GetTurnID()==tid and c:IsSetCard(0x408)
end
function s.filter1(c,e,tid)
	return s.filter0(c,tid) and not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x408) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(s.filter0,tp,0x30,0,nil,Duel.GetTurnCount())
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,0x40,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,0x40,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x30)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter1),tp,0x30,0,nil,e,Duel.GetTurnCount())
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,0x40,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,0x40,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat)
			if mat:IsExists(Card.IsFacedown,1,nil) then
				local cg=mat:Filter(Card.IsFacedown,nil)
				Duel.ConfirmCards(1-tp,cg)
			end
			if mat:IsExists(Card.IsLocation,1,nil,0x30) then
				local cg=mat:Filter(Card.IsLocation,nil,0x30)
				Duel.HintSelection(cg)
			end
			Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
function s.eqfi1ter(c)
	return c:IsSetCard(0x408) and c:IsFaceup()
end
function s.htgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=Duel.GetMatchingGroup(s.eqfi1ter,tp,0x04,0,e:GetHandler())
        return #g>0 and Duel.GetLocationCount(tp,0x08)>0
    end
end
function s.htgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.eqfi1ter,tp,0x04,0,e:GetHandler())
    if c:IsRelateToEffect(e) and #g>0 and Duel.GetLocationCount(tp,0x08)>0 then
        Duel.Hint(3,tp,518)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        local tc=sg:GetFirst()
        if Duel.Equip(tp,c,tc) then
            local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_EQUIP_LIMIT)
		    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetLabelObject(tc)
		    e1:SetValue(s.eqlimit)
		    c:RegisterEffect(e1)
        end
	end
end
function s.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=Duel.GetFieldGroup(tp,0x0c,0x0c)
        return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x0c)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0x0c,0x0c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end