if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
if not pcall(function() require("expansions/script/c15000000") end) then require("script/c15000000") end
local m=15005148
local cm=_G["c"..m]
cm.name="荣耀主的终章"
function cm.initial_effect(c)
	aux.AddCodeList(c,15005130)
	c:SetSPSummonOnce(15005148)
	--split link summon
	Satl.AddSplitProcedure(c,cm.matfilter)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.efilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--redirect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(cm.recon)
	e5:SetValue(LOCATION_DECK)
	c:RegisterEffect(e5)
end
cm.Split_link=1
function cm.matfilter(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_MACHINE)
end
function cm.recon(e)
	return e:GetHandler():IsFaceup()
end
function cm.efilter(e,c)
	return Satl.GetSplitGroup(e:GetHandler()):IsContains(c) and not c==e:GetHandler()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil,e,tp) end
	local ct=Duel.GetMatchingGroupCount(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local rg=Duel.SelectReleaseGroup(tp,cm.rfilter,1,ct,nil,e,tp)
	ct=Duel.Release(rg,REASON_COST)
	e:SetLabel(ct)
end
function cm.spfilter(c,e,tp)
	return (aux.IsCodeListed(c,15005130) or c:IsCode(15005130)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and Duel.GetMZoneCount(tp,c)>=1 and c:IsReleasable(REASON_COST) and c:IsFaceup()
end
function cm.spgcheck(g,ct)
	return g:GetCount()==ct
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,63060238) and not Duel.IsPlayerAffectedByEffect(tp,97148796)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cct=e:GetLabel()
	if Duel.IsPlayerCanSpecialSummon(tp) then
		local ct=1
		local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local spg=Group.CreateGroup()
		local check=0
		while (ct<=dcount and check==0) do
			local g=Duel.GetDecktopGroup(tp,ct)
			local fg=g:Filter(cm.spfilter,nil,e,tp)
			if fg:CheckSubGroup(cm.spgcheck,1,#fg,cct) then
				check=1
				spg=fg
			end
			ct=ct+1
		end
		if check==0 then
			Duel.ConfirmDecktop(tp,dcount)
			Duel.ShuffleDeck(tp)
			return
		end
		Duel.ConfirmDecktop(tp,ct-1)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or spg:GetCount()==0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if ft>=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spcg=Group.CreateGroup()
			if ft<=Duel.GetLocationCount(tp,LOCATION_MZONE) then
				spcg=spg
			else
				spcg=spg:Select(tp,ft,ft,nil)
			end
			local tc=spcg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				tc=spcg:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end