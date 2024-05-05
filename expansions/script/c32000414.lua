--武色B-蔚蓝虎鲸

local id=32000414
local zd=0x3c5
function c32000414.initial_effect(c)
	--ToHandAndSpSum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(c32000414.e1con)
	e1:SetTarget(c32000414.e1tg)
	e1:SetOperation(c32000414.e1op)
	c:RegisterEffect(e1)
	
	--AtkUpEquip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c32000414.e2upcon)
	e2:SetValue(1200)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)

	--Funsion
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCountLimit(1,id+1)
	e4:SetTarget(c32000414.e4tg)
	e4:SetOperation(c32000414.e4op)
    c:RegisterEffect(e4)
end

--e1
function c32000414.e1con(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 or Duel.GetCurrentPhase()==PHASE_BATTLE) and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end

function c32000414.e1spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and not c:IsCode(id)
end

function c32000414.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c32000414.e1spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end

function c32000414.e1op(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if not (c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c:IsAbleToHand()) then return end
   Duel.SendtoHand(c,nil,REASON_EFFECT)
   
    if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c32000414.e1spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp)) then return end
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32000414.e1spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	
end

--e2

function c32000414.e2upcon(e)
	local ph=Duel.GetCurrentPhase()
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and ec:IsRelateToBattle()
end

--e4 fusion
			

function c32000414.filter0(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and c:IsSetCard(zd)
end

function c32000414.filter1(c,e)
	return not c:IsImmuneToEffect(e) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(zd)
end
function c32000414.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(zd) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c32000414.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,zd)
end

function c32000414.e4tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c32000414.filter0,tp,LOCATION_ONFIELD,0,nil)
		local mg2=Duel.GetMatchingGroup(c32000414.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		aux.FCheckAdditional=c32000414.fcheck
		local res=Duel.IsExistingMatchingCard(c32000414.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c32000414.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c32000414.e4op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c32000414.filter1,tp,LOCATION_ONFIELD,0,nil,e)
	local mg2=Duel.GetMatchingGroup(c32000414.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	aux.FCheckAdditional=c32000414.fcheck
	local sg1=Duel.GetMatchingGroup(c32000414.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c32000414.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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




