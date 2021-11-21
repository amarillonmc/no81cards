--升阶魔法 G-神智的统合
local m=16107109
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
function cm.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	--c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	--c:RegisterEffect(e2)
end
----
function cm.xyzfilter0(g,e,tp)
	local c=g:GetFirst()
	local mc=g:GetNext()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RANK)
	e1:SetValue(10)
	e1:SetReset(RESET_CHAIN+RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RANK)
	e2:SetValue(10)
	e2:SetReset(RESET_CHAIN+RESET_EVENT+RESETS_STANDARD)
	mc:RegisterEffect(e2,true)
	local res=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,mc),2,2)
	local res1=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,mc,c:GetOriginalRank()+mc:GetOriginalRank())
	e1:Reset()
	e2:Reset()
	return res or res1
end
function cm.filter2(c,e,tp,mc,sc,rk)
	return c:IsRank(rk) and mc:IsCanBeXyzMaterial(c) and sc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spfilter3(c,e,tp)
	return c:IsRelateToEffect(e)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if chkc then return false end
	if chk==0 then return ct>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and mg:CheckSubGroup(cm.xyzfilter0,2,2,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:SelectSubGroup(tp,cm.xyzfilter0,false,2,2,e,tp)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,sg1:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.spfilter3,nil,e,tp)
	if g:GetCount()<2 then return end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RANK)
	e1:SetValue(10)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	tc1:RegisterEffect(e1,true)
	local e2=e1:Clone()
	tc2:RegisterEffect(e2,true)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	local sg=Group.FromCards(tc1,tc2)
	local xyzg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,sg,2)
	local xyzg1=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,tc1,tc2,tc1:GetOriginalRank()+tc2:GetOriginalRank())
			local opt=0
			if xyzg:GetCount()>0 and xyzg1:GetCount()>0 then
				opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
			elseif xyzg1:GetCount()>0 then
				opt=Duel.SelectOption(tp,aux.Stringid(m,0))
			elseif xyzg:GetCount()>0 then
				opt=Duel.SelectOption(tp,aux.Stringid(m,1))+1
			end
			if opt==0 then
				local xyz1=xyzg1:Select(tp,1,1,nil):GetFirst()
				xyz1:SetMaterial(sg)
				local mg=tc1:GetOverlayGroup()
				local mg2=tc2:GetOverlayGroup()
				if mg:GetCount()~=0 or mg2:GetCount()~=0 then
					Duel.Overlay(xyz1,mg)
					Duel.Overlay(xyz1,mg2)
				end
				Duel.Overlay(xyz1,sg)
				Duel.SpecialSummon(xyz1,SUMMON_TYPE_XYZ,tp,tp,false,false,  POS_FACEUP)
				xyz1:CompleteProcedure()
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
				local mg=tc1:GetOverlayGroup()
				local mg2=tc2:GetOverlayGroup()
				if mg:GetCount()~=0 or mg2:GetCount()~=0 then
					 Duel.Overlay(xyz,mg)
					 Duel.Overlay(xyz,mg2)
				end
				Duel.XyzSummon(tp,xyz,g)
			end
end
function cm.spfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,ct,ct)
end
function cm.spfilter1(c,e,tp,mc,sc,rk)
	return c:IsRank(rk) and mc:IsCanBeXyzMaterial(c) and sc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
----
function cm.thfilter(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end