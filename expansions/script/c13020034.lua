--和声呼唤
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--back
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(0x30)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	getmetatable(e:GetHandler()).announce_filter={TYPE_RITUAL,OPCODE_ISTYPE,TYPE_SPELL+TYPE_TRAP,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	e:SetLabel(ac)
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsType(TYPE_RITUAL+TYPE_MONSTER)
end
function s.cdfilter(c,code)
	return c:IsCode(13000757) or c:IsCode(code)
end
function s.rlfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_RITUAL)
		and c:IsType(TYPE_MONSTER+TYPE_SPELL)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	local RspCheck=false
	if Duel.IsPlayerCanDiscardDeck(tp,3) then
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		if g:GetCount()>0 then
			if g:IsExists(s.cdfilter,1,nil,cid) then RspCheck=true end
			if g:IsExists(s.filter,1,nil,e,tp) and Duel.GetLocationCount(tp,0x04)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:FilterSelect(tp,s.filter,1,1,nil,e,tp)
				local tc=sg:GetFirst()
				if RspCheck and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
					tc:CompleteProcedure()
				else
					if Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
						Duel.NegateRelatedChain(tc,RESET_TURN_SET)
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetValue(RESET_TURN_SET)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e2)
						Duel.SpecialSummonComplete()
					end
				end
				g:Sub(sg)
			end
			local rg=g:Filter(s.rlfilter,nil)
			if #rg>0 then
				Duel.Release(rg,REASON_EFFECT)
			end
			Duel.ShuffleDeck(tp)
		end
	end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x02,0,1,nil)
		and e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function s.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.BreakEffect()
	local mg=Duel.GetMatchingGroup(s.mfilter,tp,0x06,0,nil)
	local lg=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,0x40,0,nil,mg,c)
	local res=Duel.IsExistingMatchingCard(s.filter2,tp,0x40,0,1,nil,e,tp,mg,c,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(s.filter2,tp,0x40,0,1,nil,e,tp,mg2,mf,c,chkf)
		end
	end
	local op=2
	if #lg>0 and res then op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3),aux.Stringid(id,4))
	elseif res then op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,4)) if op==1 then op=2 end
	elseif #lg>0 then op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))+1
	else return end
	if op==0 then
		s.fusion(e,tp,eg,ep,ev,re,r,rp,mg)
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=lg:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),mg,c)
	end
end
function s.fusion(e,tp,eg,ep,ev,re,r,rp,mg)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Group.CreateGroup()
	mg1:Merge(mg)
	local sg1=Duel.GetMatchingGroup(s.filter2,tp,0x40,0,nil,e,tp,mg1,nil,c,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,0x40,0,nil,e,tp,mg2,mf,chkf)
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end