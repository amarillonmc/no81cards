local m=15005911
local cm=_G["c"..m]
cm.name="机龙门·异质锻炉"
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(cm.atcon)
	e1:SetValue(cm.atlimit)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.atcon)
	e2:SetTarget(cm.atlimit)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
	--fusion
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_FUSION_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.ftg)
	e4:SetOperation(cm.fop)
	c:RegisterEffect(e4)
end
function cm.atcon(e)
	return Duel.IsExistingMatchingCard(cm.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.atfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ))
end
function cm.atlimit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not (c:IsRace(RACE_MACHINE) and (c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ)))
end
function cm.setfilter(c)
	return c:IsSetCard(0x9f43) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function cm.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,LOCATION_MZONE,1,REASON_EFFECT) end
end
function cm.mfilter(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function cm.sfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9f43) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.gfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and cm.mfilter(c,e)
end
function cm.fop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.RemoveOverlayCard(tp,LOCATION_MZONE,LOCATION_MZONE,1,3,REASON_EFFECT)>0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(cm.mfilter,nil,e)
			+Duel.GetMatchingGroup(cm.gfilter,tp,LOCATION_GRAVE,0,nil,e)
		local sg1=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if (#sg1>0 or (sg2~=nil and #sg2>0)) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			::cancel::
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=sg:Select(tp,1,1,nil):GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				if #mat<2 then goto cancel end
				tc:SetMaterial(mat)
				Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				if #mat<2 then goto cancel end
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat)
			end
			tc:CompleteProcedure()
		end
	end
end