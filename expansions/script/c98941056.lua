--影之侵染
local s,id,o=GetID()
function c98941056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetOperation(s.trueac)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetDescription(aux.Stringid(id,6))
	e0:SetRange(LOCATION_DECK)
	e0:SetCondition(s.descon)
	e0:SetCost(s.cost2)
	c:RegisterEffect(e0)
	--Fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98941056,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)	
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98941056,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+o)
	e3:SetTarget(c98941056.chtg)
	e3:SetOperation(c98941056.chop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c98941056.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c98941056.eftg(e,c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9d)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetValue()~=id+1 then return end
	if rc:IsLocation(LOCATION_MZONE) and rc:GetFlagEffect(id)==0 then
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c98941056.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsAbleToHand()
end
function c98941056.extfilter(c)
	return c:IsFaceup() and c:IsSummonLocation(LOCATION_EXTRA)
end
function c98941056.trueac(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c98941056.extfilter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c98941056.thfilter,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 and Duel.GetFlagEffect(tp,id+3)==0 and Duel.SelectYesNo(tp,aux.Stringid(98941056,7)) then
		local ct=g1:GetClassCount(Card.GetCode)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g2:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		if sg and sg:GetCount()>0 then
		   Duel.SendtoHand(sg,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,sg)
	   end
	   Duel.RegisterFlagEffect(tp,id+3,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
end
function c98941056.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function c98941056.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c98941056.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9d) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c98941056.filter3(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetFlagEffect(tp,id)~=0 then return end
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c98941056.filter0,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c98941056.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c98941056.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98941056.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsOnField() then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(c98941056.filter3,nil,e)
	local mg2=Duel.GetMatchingGroup(c98941056.filter1,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c98941056.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ct=0
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c98941056.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			ct=mat1:FilterCount(s.desfilter,nil,tp)
			tc:SetMaterial(mat1)
			local xc=mat1:GetFirst()
			local hg=Group.CreateGroup()
			while xc do 
				hg:AddCard(xc)
				Duel.HintSelection(hg)
				if xc:IsLocation(LOCATION_MZONE) and xc:IsCanChangePosition() and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then Duel.ChangePosition(xc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
				else Duel.SendtoGrave(xc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION) end
				Duel.BreakEffect()
				hg:RemoveCard(xc)
				xc=mat1:GetNext()
			end
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
	   	tc:CompleteProcedure()
	end
end
function s.tgfilter1(c)
	return c:IsSetCard(0x9d) and c:IsAbleToGrave()
end
function c98941056.desfilter(c,tp)
	return c:IsControler(tp)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>=1 end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,EFFECT_FLAG_OATH,1)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>=1 end
end
function c98941056.yyfilter(c)
	return c:IsSetCard(0x9d)
end
function c98941056.disfilter(c)
	return c:IsSetCard(0x9d) and c:IsFaceup()
end
function s.filterx(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER)
end
function s.sfilter1(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:IsExists(s.sfilter2,1,c,e,tp,c)
end
function s.sfilter2(c,e,tp,oc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
end
function c98941056.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filterx,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c98941056.yyfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,id)==0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:IsExists(s.sfilter1,1,nil,e,tp,g) end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function c98941056.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsOnField() then return end
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c98941056.repop)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98941056.yyfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c98941056.repop(e,tp,eg,ep,ev,re,r,rp)
	local oog=Duel.GetMatchingGroup(c98941056.disfilter,tp,LOCATION_MZONE,0,nil)
	if oog:GetCount()==0 then 
		local g=Duel.GetMatchingGroup(s.filterx,1-tp,LOCATION_GRAVE,0,nil)
	 	if not Duel.IsPlayerAffectedByEffect(1-tp,59822133) and g:IsExists(s.sfilter1,1,nil,e,1-tp,g) then
			Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(id,4))
			local sc=g:FilterSelect(1-tp,s.sfilter1,1,1,nil,e,1-tp,g):GetFirst()
			Duel.Hint(HINT_SELECTMSG,lp,aux.Stringid(id,5))
			local oc=g:FilterSelect(1-tp,s.sfilter2,1,1,sc,e,1-tp,sc):GetFirst()
			Duel.SpecialSummonStep(sc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(tp,sc)
			Duel.SpecialSummonStep(oc,0,1-tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		 	Duel.ConfirmCards(tp,oc)
			Duel.SpecialSummonComplete()
		end
	else
		local g=Duel.GetMatchingGroup(s.filterx,tp,LOCATION_GRAVE,0,nil)
		if not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:IsExists(s.sfilter1,1,nil,e,tp,g) then
		   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
		   local sc=g:FilterSelect(tp,s.sfilter1,1,1,nil,e,tp,g):GetFirst()
		   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
		   local oc=g:FilterSelect(tp,s.sfilter2,1,1,sc,e,tp,sc):GetFirst()
		   Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,sc)
			Duel.SpecialSummonStep(oc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,oc)
			Duel.SpecialSummonComplete()
		end
	end
end