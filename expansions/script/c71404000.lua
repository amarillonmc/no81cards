--星象观测
yume=yume or {}
if c71404000 then
---@param c Card
function c71404000.initial_effect(c)
	--same effect sends this card to grave or banishes it, and spsummon another card check
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	local e0a=yume.AddThisCardBanishedAlreadyCheck(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(71404000,0))
	e1:SetOperation(c71404000.op1)
	c:RegisterEffect(e1)
	--Fissure
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetCondition(c71404000.con2)
	e2:SetTarget(c71404000.rmtarget)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--Gravekeeper's Servant
	local e2a=Effect.CreateEffect(c)
	e2a:SetType(EFFECT_TYPE_FIELD)
	e2a:SetCode(81674782)
	e2a:SetRange(LOCATION_FZONE)
	e2a:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2a:SetTargetRange(0xff,0xff)
	e2a:SetTarget(c71404000.checktg)
	c:RegisterEffect(e2a)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(71404000,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_CUSTOM+71404000)
	e3:SetCountLimit(1)
	e3:SetCost(yume.stellar_memories.LimitCost)
	e3:SetTarget(c71404000.tg3)
	e3:SetOperation(c71404000.op3)
	c:RegisterEffect(e3)
	--place field
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71404000,3))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	--e4:SetCode(EVENT_CUSTOM+71504000)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e4:SetLabelObject(e0)
	e4:SetCondition(c71404000.con4)
	e4:SetCost(c71404000.cost4)
	e4:SetTarget(c71404000.tg4)
	e4:SetOperation(c71404000.op4)
	c:RegisterEffect(e4)
	local e4a=e4:Clone()
	e4a:SetRange(LOCATION_REMOVED)
	e4a:SetLabelObject(e0a)
	c:RegisterEffect(e4a)
	aux.RegisterMergedDelayedEvent(c,71404000,EVENT_TO_HAND)
	--aux.RegisterMergedDelayedEvent(c,71504000,EVENT_REMOVE)
	yume.stellar_memories.GlobalCheck(c)
end
function c71404000.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(0,LOCATION_REMOVED,LOCATION_REMOVED)
	if ct>0 and Duel.SelectYesNo(tp,aux.Stringid(71404000,1)) then
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end
function c71404000.filter2a(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:GetOriginalType()&(TYPE_RITUAL+TYPE_MONSTER)~=0
end
function c71404000.filter2b(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:GetOriginalType()&(TYPE_LINK+TYPE_MONSTER)~=0
end
function c71404000.con2(e)
	return Duel.IsExistingMatchingCard(c71404000.filter2a,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	and Duel.IsExistingMatchingCard(c71404000.filter2b,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c71404000.rmtarget(e,c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and not c:IsSummonableCard()
end
function c71404000.checktg(e,c)
	return not c:IsPublic()
end
function c71404000.filter3(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToRemove(tp)
end
function c71404000.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71404000.filter3,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c71404000.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c71404000.filter3,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c71404000.filtercon4(c,tp,se)
	return se==nil or c:GetReasonEffect()~=se
end
function c71404000.con4(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(c71404000.filtercon4,1,nil,tp,se)
end
function c71404000.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,71404000,tp)==0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,71404000,RESET_CHAIN,0,1)
	yume.stellar_memories.RegStellarCostLimit(e,tp)
end
function c71404000.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsForbidden() end
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
	end
end
function c71404000.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsForbidden() then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
end
if not yume.stellar_memories then
yume.stellar_memories={}
---@param c Card
---@return Effect
function yume.AddThisCardBanishedAlreadyCheck(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(aux.ThisCardInGraveAlreadyCheckReg)
	c:RegisterEffect(e1)
	return e1
end
---Handle selection border list
---@param blist table|nil @A list for selection borders
---@return number,number,number,number
function yume.stellar_memories.HandleSelectionBorderList(blist)
	local lb1,ub1,lb2,ub2=1,1,1,1
	if blist then
		if blist[1] then
			lb1=blist[1][1] or lb1
			ub1=blist[1][2] or ub1
		end
		if blist[2] then
			lb2=blist[2][1] or lb2
			ub2=blist[2][2] or ub2
		end
	end
	return lb1,ub1,lb2,ub2
end
--Experimental quick algorithm for checking if there are ub1 cards from g1, including at least ub2 cards in g2
--Time complexity: O(nlogn)
---@param g1 Group
---@param g2 Group
---@param blist table|nil @A list for selection borders
---@return boolean
function yume.stellar_memories.QuickInclusiveSelectCheck(g1,g2,blist)
	local lb1,_,lb2=yume.stellar_memories.HandleSelectionBorderList(blist)
	local g3=g1&g2
	return #g1>lb1 and #g3>lb2
end
--Experimental quick algorithm for selecting ub1-ub2 cards from g1, including at least ub2 cards in g2
--Time complexity: O(nlogn)
---@param tp number
---@param g1 Group
---@param g2 Group
---@param blist table|nil @A list for selection borders
---@param msg number @Hint msg
---@return Group
function yume.stellar_memories.QuickInclusiveSelect(tp,g1,g2,blist,msg)
	local resg=Group.CreateGroup()
	local lb1,ub1,lb2=yume.stellar_memories.HandleSelectionBorderList(blist)
	local g3=g1&g2
	local rg=g1:Clone()
	if ub1>#g3 then ub1=#g3 end
	if #g1<lb1 or #g3<lb2 then return resg end
	--remaining borders
	local rlb1,rub1,rlb2=lb1,ub1,lb2
	local l=rlb1==0 and 0 or 1
	while rub1>0 do
		if rlb2>0 then
			if rub1==rlb2 then
				Duel.Hint(HINT_SELECTMSG,tp,msg)
				local sg=g3:Select(tp,rub1,rub1,nil)
				resg:Merge(sg)
				return resg
			else
				Duel.Hint(HINT_SELECTMSG,tp,msg)
				local sg=rg:Select(tp,l,1,nil)
				if #sg==0 then return resg end
				local sc=sg:GetFirst()
				resg:AddCard(sc)
				rg:RemoveCard(sc)
				rlb1,rub1=rlb1-1,rub1-1
				if rlb1==0 then l=0 end
				if g3:IsContains(sc) then
					rlb2=rlb2-1
					g3:RemoveCard(sc)
				end
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,msg)
			local sg=rg:Select(tp,rlb1,rub1,nil)
			resg:Merge(sg)
			return resg
		end
	end
	return resg
end
--Experimental quick algorithm for checking if there are enough cards from two groups, certain number for each group
--Time complexity: O(nlogn)
---@param g1 Group
---@param g2 Group
---@param blist table|nil @A list for selection borders
---@return boolean
function yume.stellar_memories.QuickDualSelectCheck(g1,g2,blist)
	local lb1,_,lb2=yume.stellar_memories.HandleSelectionBorderList(blist)
	local g3=g1+g2
	return #g1>=lb1 and #g2>=lb2 and #g3>=lb1+lb2
end
--Experimental quick algorithm for selecting cards from two groups, certain number for each group
--Time complexity: O(nlogn)
---@param tp number
---@param g1 Group
---@param g2 Group
---@param blist table|nil @A list for selection borders
---@param msg1 number @Hint msg 1
---@param msg2 number @Hint msg 2
---@param opf function? @A function for operations after selecting the first card, receiving the selected card as the first param and returning a bool standing for whether you do it("[opf], and if you do, select sg2")
---@param ... table
---@return Group,Group
function yume.stellar_memories.QuickDualSelect(tp,g1,g2,blist,msg1,msg2,opf,...)
	local g3=g1&g2
	local g4=g2-g3
	local exgroup=nil
	local lb1,ub1,lb2,ub2=yume.stellar_memories.HandleSelectionBorderList(blist)
	if #g2==lb2 and #(g1-g3)>=lb1 then
		exgroup=g3
	end
	if #g4<lb2 then
		local nxtub=#(g1+g4)-lb2
		if nxtub>=lb1 and ub1>nxtub then ub1=nxtub end
	end
	Duel.Hint(HINT_SELECTMSG,tp,msg1)
	local sg1=g1:Select(tp,lb1,ub1,exgroup)
	if not msg2 then return sg1 end
	local ext_params={...}
	if opf and not opf(sg1,table.unpack(ext_params)) then return sg1,Group.CreateGroup() end
	Duel.Hint(HINT_SELECTMSG,tp,msg2)
	local sg2=g2:Select(tp,lb2,ub2,sg1)
	return sg1,sg2
end
---@param c Card
function yume.stellar_memories.GlobalCheck(c)
	if not yume.stellar_memories.global_check then
		yume.stellar_memories.global_check=true
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_RELEASE)
		e1:SetOperation(yume.stellar_memories.ReleaseRegOp)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_MSET)
		e2:SetOperation(yume.stellar_memories.SetRegOp1)
		Duel.RegisterEffect(e2,0)
		local e3=e2:Clone()
		e3:SetCode(EVENT_CHANGE_POS)
		e3:SetOperation(yume.stellar_memories.SetRegOp2)
		Duel.RegisterEffect(e3,0)
		local e4=e2:Clone()
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetOperation(yume.stellar_memories.SetRegOp3)
		Duel.RegisterEffect(e4,0)
		local e5=e2:Clone()
		e5:SetCode(EVENT_SSET)
		Duel.RegisterEffect(e5,0)
	end
end
function yume.stellar_memories.ReleaseRegOp(e,tp,eg,ep,ev,re,r,rp)
	local p1,p0=false,false
	for tc in aux.Next(eg) do
		if not p0 and tc:IsPreviousControler(0) then
			p0=true
		elseif not p1 and tc:IsPreviousControler(1) then
			p1=true
		end
	end
	if p0 then
		Duel.RegisterFlagEffect(0,71404000,RESET_PHASE+PHASE_END,0,1)
	end
	if p1 then
		Duel.RegisterFlagEffect(1,71404000,RESET_PHASE+PHASE_END,0,1)
	end
end
function yume.stellar_memories.SetRegFilter2(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown()
end
function yume.stellar_memories.SetRegOp1(e,tp,eg,ep,ev,re,r,rp)
	local p1,p0=false,false
	for tc in aux.Next(eg) do
		if not p0 and tc:IsPreviousControler(0) then
			p0=true
		elseif not p1 and tc:IsPreviousControler(1) then
			p1=true
		end
	end
	if p0 then
		Duel.RegisterFlagEffect(0,71404000,RESET_PHASE+PHASE_END,0,1)
	end
	if p1 then
		Duel.RegisterFlagEffect(1,71404000,RESET_PHASE+PHASE_END,0,1)
	end
end
function yume.stellar_memories.SetRegOp2(e,tp,eg,ep,ev,re,r,rp)
	local p1,p0=false,false
	local setg=eg:Filter(yume.stellar_memories.SetRegFilter2,nil)
	for tc in aux.Next(setg) do
		if not p0 and tc:IsControler(0) then
			p0=true
		elseif not p1 and tc:IsControler(1) then
			p1=true
		end
	end
	if p0 then
		Duel.RegisterFlagEffect(0,71404000,RESET_PHASE+PHASE_END,0,1)
	end
	if p1 then
		Duel.RegisterFlagEffect(1,71404000,RESET_PHASE+PHASE_END,0,1)
	end
end
function yume.stellar_memories.SetRegOp3(e,tp,eg,ep,ev,re,r,rp)
	local p1,p0=false,false
	local setg=eg:Filter(Card.IsFacedown,nil)
	for tc in aux.Next(setg) do
		if not p0 and tc:IsPreviousControler(0) then
			p0=true
		elseif not p1 and tc:IsPreviousControler(1) then
			p1=true
		end
	end
	if p0 then
		Duel.RegisterFlagEffect(0,71404000,RESET_PHASE+PHASE_END,0,1)
	end
	if p1 then
		Duel.RegisterFlagEffect(1,71404000,RESET_PHASE+PHASE_END,0,1)
	end
end
function yume.stellar_memories.RegCostLimit(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsControler,tp))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	e4:SetTarget(yume.stellar_memories.SumLimit)
	e4:SetLabel(tp)
	Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_RELEASE)
	Duel.RegisterEffect(e5,tp)
end
function yume.stellar_memories.SumLimit(e,c,sump,sumtype,sumpos,targetp)
	return sumpos&POS_FACEDOWN>0 and c:IsControler(e:GetLabel())
end
function yume.stellar_memories.LimitCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,71404000,tp)==0 end
	yume.stellar_memories.RegCostLimit(e,tp)
end
function yume.stellar_memories.RitualUltimateFilter(c,e,tp,m1,m2,level_function,greater_or_equal)
	if not(c:GetOriginalType()&0x81==0x81 and yume.stellar_memories.RitualMonsterFilter(c,e,tp) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=yume.stellar_memories.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(yume.stellar_memories.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function yume.stellar_memories.RitualCheckGreater(g,c,lv)
	if atk==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(yume.stellar_memories.RitualCheckLevelFunction,lv,c)
end
function yume.stellar_memories.RitualCheckEqual(g,c,lv)
	if atk==0 then return false end
	return g:CheckWithSumEqual(yume.stellar_memories.RitualCheckLevelFunction,lv,#g,#g,c)
end
function yume.stellar_memories.RitualCheck(g,tp,c,lv,greater_or_equal)
	return yume.stellar_memories["RitualCheck"..greater_or_equal](g,c,lv) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function yume.stellar_memories.RitualCheckAdditional(c,lv,greater_or_equal)
	if greater_or_equal=="Equal" then
		return	function(g)
					return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g)) and g:GetSum(yume.stellar_memories.RitualCheckLevelFunction,c)<=lv
				end
	else
		return	function(g,ec)
					if atk==0 then return #g<=1 end
					if ec then
						return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g,ec)) and g:GetSum(yume.stellar_memories.RitualCheckLevelFunction,c)-yume.stellar_memories.RitualCheckLevelFunction(ec,c)<=lv
					else
						return not aux.RGCheckAdditional or aux.RGCheckAdditional(g)
					end
				end
	end
end
function yume.stellar_memories.RitualLevelFunction(c)
	return c:GetLevel()|c:GetLink()
end
--Level function used in RitualCheck...()
function yume.stellar_memories.RitualCheckLevelFunction(c,rc)
	local rlv=c:GetRitualLevel(rc)
	if rlv>0 then return rlv
	else return c:GetLink() end
end
function yume.stellar_memories.RCheckAdditional(tp,g,c)
	return g:IsExists(yume.stellar_memories.RitualIncludeCheck,1,nil)
end
function yume.stellar_memories.RitualIncludeCheck(c)
	return c:GetOriginalType()&TYPE_LINK~=0
end
function yume.stellar_memories.RitualUltimateTarget(greater_or_equal,summon_location,mat_location,extra_target)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					local mg=Duel.GetMatchingGroup(yume.stellar_memories.RitualBanishFilter,tp,mat_location,0,nil,tp)
					aux.RCheckAdditional=yume.stellar_memories.RCheckAdditional
					local res=Duel.IsExistingMatchingCard(yume.stellar_memories.RitualUltimateFilter,tp,summon_location,0,1,nil,e,tp,mg,nil,yume.stellar_memories.RitualLevelFunction,greater_or_equal)
					aux.RCheckAdditional=nil
					return res
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,summon_location)
				Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,mat_location)
				if extra_target then
					extra_target(e,tp,eg,ep,ev,re,r,rp)
				end
			end
end
function yume.stellar_memories.RitualBanishFilter(c,tp)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsAbleToRemove(tp)
		and (not c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup())
end
function yume.stellar_memories.RitualMonsterFilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceupEx()
end
function yume.stellar_memories.RitualUltimateOperation(greater_or_equal,summon_location,mat_location,extra_operation)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				::RitualUltimateSelectStart::
				local mg=Duel.GetMatchingGroup(yume.stellar_memories.RitualBanishFilter,tp,mat_location,0,nil,tp)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				aux.RCheckAdditional=yume.stellar_memories.RCheckAdditional
				local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(yume.stellar_memories.RitualUltimateFilter),tp,summon_location,0,1,1,nil,e,tp,mg,nil,yume.stellar_memories.RitualLevelFunction,greater_or_equal)
				local tc=tg:GetFirst()
				local mat=nil
				if tc then
					mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
					if tc.mat_filter then
						mg=mg:Filter(tc.mat_filter,tc,tp)
					else
						mg:RemoveCard(tc)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local lv=yume.stellar_memories.RitualLevelFunction(tc)
					aux.GCheckAdditional=yume.stellar_memories.RitualCheckAdditional(tc,lv,greater_or_equal)
					mat=mg:SelectSubGroup(tp,yume.stellar_memories.RitualCheck,true,1,lv,tp,tc,lv,greater_or_equal)
					aux.GCheckAdditional=nil
					if not mat then 
						aux.RCheckAdditional=nil
						goto RitualUltimateSelectStart
					end
					tc:SetMaterial(mat)
					Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				end
				if extra_operation then
					extra_operation(e,tp,eg,ep,ev,re,r,rp,tc,mat)
				end
				aux.RCheckAdditional=nil
			end
end
function yume.stellar_memories.MultiRitualBanishFilter(c,tp)
	return yume.stellar_memories.RitualIncludeCheck(c) and yume.stellar_memories.RitualBanishFilter(c,tp)
end
function yume.stellar_memories.MultiRitualMonsterFilter(c,e,tp,m1,level_function,greater_or_equal)
	if not (c:GetOriginalType()&0x81==0x81 and yume.stellar_memories.RitualMonsterFilter(c,e,tp) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	return mg:IsExists(yume.stellar_memories.MultiRitualCheck,1,nil,c,tp,level_function,greater_or_equal)
end
function yume.stellar_memories.MultiRitualCheck(mc,c,tp,level_function,greater_or_equal)
	local mg=Group.FromCards(mc)
	if c.mat_filter and not c.mat_filter(mc,tp) or c.mat_group_check and not c.mat_group_check(mg,tp) then return false end
	local lv=c:GetLevel()
	local mlv=level_function(mc)*2
	local greater_flag=greater_or_equal=="Greater"
	if greater_flag and mlv>=lv or mlv==lv then return true end
	local rlv=mc:GetRitualLevel(c)*2
	return greater_flag and (lv<=bit.band(rlv,0xffff) or lv<=bit.rshift(rlv,16)) or lv==bit.band(rlv,0xffff) or lv==bit.rshift(rlv,16)
end
function yume.stellar_memories.MultiRitualTargetCheck(e,tp,greater_or_equal,summon_location,mat_location)
	local mg=Duel.GetMatchingGroup(yume.stellar_memories.MultiRitualBanishFilter,tp,mat_location,0,nil,tp)
	local res=Duel.IsExistingMatchingCard(yume.stellar_memories.RitualMonsterFilter,tp,summon_location,0,1,nil,e,tp,mg,Card.GetLink,greater_or_equal)
	return res
end
function yume.stellar_memories.MultiRitualTarget(greater_or_equal,summon_location,mat_location,extra_target)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					return yume.stellar_memories.MultiRitualTargetCheck(e,tp,greater_or_equal,summon_location,mat_location)
				end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,summon_location)
				Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,mat_location)
				if extra_target then
					extra_target(e,tp,eg,ep,ev,re,r,rp)
				end
			end
end
function yume.stellar_memories.MainZoneFilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:GetSequence()<5
end
function yume.stellar_memories.MultiRitualSelectToUseFilter(c,e,tp,summon_location,level_function,greater_or_equal)
	return Duel.IsExistingMatchingCard(yume.stellar_memories.MultiRitualSelectToSummonFilter,tp,summon_location,0,1,c,e,tp,c,level_function,greater_or_equal)
end
function yume.stellar_memories.MultiRitualSelectToSummonFilter(c,e,tp,mc,level_function,greater_or_equal)
	return c:GetOriginalType()&0x81==0x81 and yume.stellar_memories.RitualMonsterFilter(c,e,tp)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and mc:IsCanBeRitualMaterial(c)
		and yume.stellar_memories.MultiRitualCheck(mc,c,tp,level_function,greater_or_equal)
end
function yume.stellar_memories.MultiRitualRitualLevelCheck(c,mc,level_function,greater_or_equal)
	local lv=c:GetLevel()
	local rlv=mc:GetRitualLevel(c)*2
	if level_function(mc)*2==rlv then return false end
	local greater_flag=greater_or_equal=="Greater"
	return greater_flag and (lv<=bit.band(rlv,0xffff) or lv<=bit.rshift(rlv,16)) or lv==bit.band(rlv,0xffff) or lv==bit.rshift(rlv,16)
end
function yume.stellar_memories.MultiRitualLevelCheck(c,mc,level_function,greater_or_equal)
	local lv=c:GetLevel()
	local mlv=level_function(mc)*2
	return greater_or_equal=="Greater" and mlv>=lv or mlv==lv
end
function yume.stellar_memories.MultiRitualCheckAdditional(lv)
	return	function(g)
				return g:GetSum(Card.GetLevel)<=lv
			end
end
function yume.stellar_memories.MultiRitualFSelect(g,tp,lv)
	return g:GetSum(Card.GetLevel)<=lv
end
function yume.stellar_memories.MultiRitualOperation(greater_or_equal,summon_location,mat_location,extra_operation,ct)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				if ft<0 then return end
				::cancel::
				local mg=Duel.GetMatchingGroup(yume.stellar_memories.MultiRitualBanishFilter,tp,mat_location,0,nil,tp)
				if ft==0 then
					mg=mg:Filter(yume.stellar_memories.MainZoneFilter,nil,tp)
				end
				mg=mg:Filter(yume.stellar_memories.MultiRitualSelectToUseFilter,nil,e,tp,summon_location,Card.GetLink,greater_or_equal)
				if mg:GetCount()==0 then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local mat=mg:Select(tp,1,1,nil)
				local mc=mat:GetFirst()
				local sg=Duel.GetMatchingGroup(yume.stellar_memories.MultiRitualSelectToSummonFilter,tp,summon_location,0,mc,e,tp,mc,Card.GetLink,greater_or_equal)
				if sg:GetCount()==0 then return end
				if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
				if ct and ct<ft then ft=ct end
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				--Ritual Summon 1 monster with ritual Level
				local b1=sg:IsExists(yume.stellar_memories.MultiRitualRitualLevelCheck,1,nil,mc,Card.GetLink,greater_or_equal)
				--Ritual Summon 1+ monsters with Link Rating
				local b2=sg:IsExists(yume.stellar_memories.MultiRitualLevelCheck,1,nil,mc,Card.GetLink,greater_or_equal)
				if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(71404000,4))) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tc=sg:Filter(yume.stellar_memories.MultiRitualRitualLevelCheck,nil,mc,Card.GetLink,greater_or_equal):SelectUnselect(nil,tp,false,true,1,1)
					if not tc then goto cancel end
					tc:SetMaterial(mat)
					Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
					tc:CompleteProcedure()
				else
					local lv=mc:GetLink()*2
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)aux.GCheckAdditional=yume.stellar_memories.MultiRitualCheckAdditional(lv)
					local tg=mg:SelectSubGroup(tp,yume.stellar_memories.MultiRitualFSelect,true,1,ft,tp,lv)
					aux.GCheckAdditional=nil
					if not tg then goto cancel end
					local tc=tg:GetFirst()
					while tc do
						tc:SetMaterial(mat)
						tc=tg:GetNext()
					end
					Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
					Duel.BreakEffect()
					tc=tg:GetFirst()
					while tc do
						Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
						tc:CompleteProcedure()
						tc=tg:GetNext()
					end
					Duel.SpecialSummonComplete()
				end
			end
end
function yume.stellar_memories.OptionalMultiRitualSummon(e,tp,msg,greater_or_equal,summon_location,mat_location,ct)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then return end
	::cancel::
	local mg=Duel.GetMatchingGroup(yume.stellar_memories.MultiRitualBanishFilter,tp,mat_location,0,nil,tp)
	if ft==0 then
		mg=mg:Filter(yume.stellar_memories.MainZoneFilter,nil,tp)
	end
	mg=mg:Filter(yume.stellar_memories.MultiRitualSelectToUseFilter,nil,e,tp,summon_location,Card.GetLink,greater_or_equal)
	if mg:GetCount()==0 or not Duel.SelectYesNo(tp,msg) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mat=mg:Select(tp,1,1,nil)
	local mc=mat:GetFirst()
	local sg=Duel.GetMatchingGroup(yume.stellar_memories.MultiRitualSelectToSummonFilter,tp,summon_location,0,mc,e,tp,mc,Card.GetLink,greater_or_equal)
	if sg:GetCount()==0 then return end
	if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if ct and ct<ft then ft=ct end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	--Ritual Summon 1 monster with ritual Level
	local b1=sg:IsExists(yume.stellar_memories.MultiRitualRitualLevelCheck,1,nil,mc,Card.GetLink,greater_or_equal)
	--Ritual Summon 1+ monsters with Link Rating
	local b2=sg:IsExists(yume.stellar_memories.MultiRitualLevelCheck,1,nil,mc,Card.GetLink,greater_or_equal)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(71404000,4))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Filter(yume.stellar_memories.MultiRitualRitualLevelCheck,nil,mc,Card.GetLink,greater_or_equal):SelectUnselect(nil,tp,false,true,1,1)
		if not tc then goto cancel end
		tc:SetMaterial(mat)
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		local lv=mc:GetLink()*2
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		aux.GCheckAdditional=yume.stellar_memories.MultiRitualCheckAdditional(lv)
		local tg=sg:SelectSubGroup(tp,yume.stellar_memories.MultiRitualFSelect,true,1,ft,tp,lv)
		aux.GCheckAdditional=nil
		if not tg then goto cancel end
		local tc=tg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=tg:GetNext()
		end
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		tc=tg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
			tc=tg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end

function yume.stellar_memories.LinkSummonFilter(c)
	return c:IsLinkSummonable(nil) and c:IsRace(RACE_SPELLCASTER)
end
function yume.stellar_memories.LinkSummonTg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(yume.stellar_memories.LinkSummonFilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function yume.stellar_memories.LinkSummonOp(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,yume.stellar_memories.LinkSummonFilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end
end