--虚构素体 A001
local m=20000162
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000150") end) then require("script/c20000150") end
function cm.initial_effect(c)
	aux.AddCodeList(c,20000166)
	local e1,e2=fu_cim.Hint(c,m,cm.con1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(fu_cim.Remove_Material_condition)
	e3:SetCost(fu_cim.Remove_Material_cost)
	e3:SetTarget(cm.tg2)
	e3:SetOperation(cm.op2)
	c:RegisterEffect(e3)
end
--e1
function cm.conf1(c)
	return c:IsFaceup() and c:IsLevel(3)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.conf1,tp,LOCATION_MZONE,0,1,nil)
end
--e2
function cm.tgf2(c,e,tp,mc)
	return not c:IsCode(e:GetHandler():GetCode()) and c:IsType(TYPE_XYZ) and c:IsSetCard(0xcfd1) and c:IsRank(6) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,0))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
		if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.tgf2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
			local sc=g:GetFirst()
			if sc then
				local mg=c:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(c))
				Duel.Overlay(sc,Group.FromCards(c))
				if Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(m,1))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
					e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					e1:SetValue(cm.op2val)
					sc:RegisterEffect(e1,true)
				end
				Duel.SpecialSummonComplete()
				sc:CompleteProcedure()
			end
		end
	end
end
function cm.op2val(e,c)
	if not c then return false end
	return not c:IsCode(20000166)
end