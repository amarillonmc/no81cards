--祸津榆 彼列
local m=51354011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function cm.checktype(c,opt)
	return (opt==0 and c:IsType(TYPE_MONSTER)) or (opt==1 and c:IsType(TYPE_SPELL)) or (opt==2 and c:IsType(TYPE_TRAP))
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local type1=Duel.AnnounceType(tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
	local type2=Duel.AnnounceType(1-tp)
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local gg=false
	if type1~=type2 then
		if cm.checktype(tc,type1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		elseif cm.checktype(tc,type2) then
			local g=Duel.GetDecktopGroup(tp,5)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		else
			gg=true
		end
	else
		if cm.checktype(tc,type1) and cm.checktype(tc,type2) then
			cm.fusion(e,tp,eg,ep,ev,re,r,rp)
			local d1=Duel.Draw(tp,1,REASON_EFFECT)
			local d2=Duel.Draw(1-tp,1,REASON_EFFECT)
		else
			gg=true
		end
	end
	if gg then
		local g=Duel.GetDecktopGroup(tp,5)
		local g1=Duel.GetDecktopGroup(1-tp,5)
		g:Merge(g1)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xa0b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--fusion
function cm.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)  
		and (not f or f(c)) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.fusion(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_DECK))
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_DECK,LOCATION_DECK,nil)
	aux.FCheckAdditional=cm.fcheck
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
	aux.FCheckAdditional=nil
end