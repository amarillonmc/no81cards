--泡沫融合
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.stcon)
	e2:SetTarget(s.sttg)
	e2:SetOperation(s.stop)
	c:RegisterEffect(e2)
end
s.fusion_effect=true
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rac=0
		local crac=1
		while bit.band(RACE_ALL,crac)~=0 do
			local catt=1
            local val=0
			for iatt=0,7 do
            	local l=1
                while l<=12 do
                    if Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,0,0,l,crac,catt) then
                        rac=rac+crac
                        val=1
                        break
                    end
                    l=l+1
				end
                catt=catt*2
                if val==1 then break end
			end
			crac=crac*2
		end
		e:SetLabel(rac)
        return e:IsCostChecked()
			and rac~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local crac=Duel.AnnounceRace(tp,1,e:GetLabel())
	local att=0
	local catt=1
    local t={}
	for iatt=0,7 do
        local val=0
        local l=1
        local a=1
        while l<=12 do
            if Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,0,0,l,crac,catt) then
                t[a]=l
                a=a+1
                val=1
            end
            l=l+1
		end
        if val>0 then att=att+catt end
        catt=catt*2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	catt=Duel.AnnounceAttribute(tp,1,att)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local lv=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(crac,lv)
	Duel.SetTargetParam(catt)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp) 
    local rac,lv=e:GetLabel() 
    local att=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,0,0,lv,rac,att) then return end
	local token=Duel.CreateToken(tp,id+1)
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(rac)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(att)
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(lv)
	token:RegisterEffect(e3)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
        if s.fcon(e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			s.fop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splim)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function s.splim(e,c)
	return c:IsLocation(0x40) and not c:IsType(TYPE_FUSION)
end
function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        local g=Duel.GetMatchingGroup(nil,tp,0x0e,0,nil)
        return e:GetHandler():IsSSetable() and #g>1
    end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(nil,tp,0x0e,0,nil)
	if #g>1 then
        Duel.Hint(3,tp,502)
        local sg=g:Select(tp,2,2,nil)
        Duel.HintSelection(sg)
        if Duel.Destroy(sg,0x40)==2 and c:IsRelateToEffect(e) and Duel.SSet(tp,c)>0 then
            local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
        end
    end 
end
--Extra Function
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fcon(e,tp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
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
function s.fop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
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
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce~=nil then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end