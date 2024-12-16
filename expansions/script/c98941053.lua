--调皮宝贝升空艇
local s,id,o=GetID()
function c98941053.initial_effect(c)
	c:SetSPSummonOnce(291414)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x120),2,true)	
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.tgcon)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
	if not c98941053.globle_check then
		--chain check
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetOperation(c98941053.chainop)
		Duel.RegisterEffect(e1,0)

		c98941053.globle_check=true
		PK_hack_fusion_check=Card.CheckFusionMaterial
		function Card.CheckFusionMaterial(card,Group_fus,Card_g,int_chkf,not_mat)
			local exg=Group.CreateGroup()
			if card:GetOriginalCode()==98941053 then
				exg=Duel.GetMatchingGroup(c98941053.kfilter0,int_chkf,LOCATION_DECK,0,nil,card)
				exg=Group.__bxor(exg,Group_fus):Filter(Card.IsLocation,nil,LOCATION_DECK)
				if exg:GetCount()>0 then
					if Duel.GetFlagEffect(0,98941053)~=0 and Duel.GetFlagEffect(0,98941054)==0 then
						Duel.RegisterFlagEffect(0,98941054,RESET_EVENT+RESET_CHAIN,0,1)
						local e1=Effect.CreateEffect(card)
						e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
						e1:SetCode(EVENT_CHAIN_SOLVED)
						e1:SetOperation(c98941053.resetop)
						e1:SetReset(RESET_EVENT+RESET_CHAIN)
						Duel.RegisterEffect(e1,0)
						local e2=e1:Clone()
						e2:SetCode(EVENT_CHAIN_NEGATED)
						Duel.RegisterEffect(e2,0)
					end
					local hg=Group.__add(exg,Group_fus)
					return PK_hack_fusion_check(card,hg,Card_g,int_chkf,not_mat)
				end
			end
			return PK_hack_fusion_check(card,Group_fus,Card_g,int_chkf,not_mat)
		end
		PK_hack_fusion_select=Duel.SelectFusionMaterial
		function Duel.SelectFusionMaterial(tp,card,mg,gc_nil,chkf)
			if card:GetOriginalCode()==98941053 and Duel.GetFlagEffect(0,98941053)~=0 and Duel.GetFlagEffect(0,98941054)~=0 then
				exg=Duel.GetMatchingGroup(c98941053.kfilter0,int_chkf,LOCATION_DECK,LOCATION_DECK,nil,card)
				if exg:GetCount()>0 then
					mg:Merge(exg)
				end
			end
			Duel.ResetFlagEffect(0,98941054)
			return PK_hack_fusion_select(tp,card,mg,gc_nil,chkf)
		end
	end	
end
function c98941053.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,98941053,RESET_EVENT+RESET_CHAIN,0,1)
end
function c98941053.resetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(0,98941054)
	e:Reset()
end
function c98941053.splimit(e,c)
	if not c then return false end
	return not c:IsCode(98941053)
end
function c98941053.kfilter0(c,fc)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial(fc)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	--e1:SetTarget(s.target)
	e1:SetOperation(s.activatep)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98941053.filter0(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c98941053.filter1(c,e)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c98941053.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_WIND+ATTRIBUTE_FIRE+ATTRIBUTE_WATER) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c98941053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c98941053.filter0,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local res=Duel.IsExistingMatchingCard(c98941053.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c98941053.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c98941053.activatep(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(98941053,2)) then return end
	local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98941053.filter1),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c98941053.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c98941053.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
			if mat:Filter(c98941053.cfilter,nil):GetCount()>0 then
				local cg=mat:Filter(c98941053.cfilter,nil)
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
function c98941053.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) 
end