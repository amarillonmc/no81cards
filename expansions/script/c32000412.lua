--武色Y-明黄土蜥

local id=32000412
local zd=0x3c5
function c32000412.initial_effect(c)
	--EquipWhenSSpSum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(c32000412.e1tg)
	e1:SetOperation(c32000412.e1op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

    --DesteoyCanNot
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	
    local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e5:SetRange(LOCATION_ONFIELD)
	e5:SetCountLimit(1,id+1)
	e5:SetTarget(c32000412.e5tg)
	e5:SetOperation(c32000412.e5op)
    c:RegisterEffect(e5)
end

--e1
function c32000412.e1eqfilter(c)
	return c:IsSetCard(zd) and c:IsType(TYPE_MONSTER) and not c:IsCode(id)
end

function c32000412.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32000412.e1eqfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end

function c32000412.e1op(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.IsExistingMatchingCard(c32000412.e1eqfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then return end 
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqg=Duel.SelectMatchingCard(tp,c32000412.e1eqfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local etg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Equip(tp,eqg:GetFirst(),etg:GetFirst())
	
	local c=eqg:GetFirst()
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(true)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end


--e5
function c32000412.filter0(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and c:IsSetCard(zd)
end
function c32000412.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsLocation(LOCATION_HAND) and c:IsSetCard(zd)
end
function c32000412.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(zd) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c32000412.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,zd)
end

function c32000412.e5tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c32000412.filter0,tp,LOCATION_HAND,0,nil)
		local mg2=Duel.GetMatchingGroup(c32000412.filter0,tp,LOCATION_ONFIELD,0,nil)
		mg1:Merge(mg2)
		aux.FCheckAdditional=c32000412.fcheck
		local res=Duel.IsExistingMatchingCard(c32000412.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c32000412.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED)
end

function c32000412.e5op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c32000412.filter1,tp,LOCATION_HAND,0,nil,e)
	local mg2=Duel.GetMatchingGroup(c32000412.filter0,tp,LOCATION_ONFIELD,0,nil)
	mg1:Merge(mg2)
	aux.FCheckAdditional=c32000412.fcheck
	local sg1=Duel.GetMatchingGroup(c32000412.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c32000412.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,mg3,mf,chkf)
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
    end
end







