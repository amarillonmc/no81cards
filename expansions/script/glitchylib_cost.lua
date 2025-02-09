--COSTS
function Auxiliary.CreateCost(...)
	local x={...}
	if #x==0 then return end
	local f	=	function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then
						for _,cost in ipairs(x) do
							if not cost(e,tp,eg,ep,ev,re,r,rp,chk) then
								return false
							end
						end
						return true
					end
					for _,cost in ipairs(x) do
						cost(e,tp,eg,ep,ev,re,r,rp,chk)
					end
				end
	return f
end

function Auxiliary.RevealFilter(f)
	return	function(c,...)
				return not c:IsPublic() and (not f or f(c,...))
			end
end

-----------------------------------------------------------------------
function Auxiliary.DummyCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function Auxiliary.ConfirmRuleCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,Group.FromCards(e:GetHandler()))
end
function Auxiliary.InfoCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function Auxiliary.LabelCost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function Auxiliary.LabelCost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local l1,l2=e:GetLabel()
	e:SetLabel(1,l2)
	if chk==0 then return true end
end
function Auxiliary.CustomLabelCost(lab)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				e:SetLabel(lab)
				if chk==0 then return true end
			end
end

--Card Action Costs
function Auxiliary.DestroyCost(f,loc1,loc2,min,max,exc)
	loc1=loc1 or LOCATION_ONFIELD
	loc2=loc2 or 0
	min=min or 1
	max=max or min
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local exc=(not exc) and nil or e:GetHandler()
				if chk==0 then return Duel.IsExistingMatchingCard(aux.DestroyFilter(f),tp,loc1,loc2,min,exc,e,tp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,aux.DestroyFilter(f),tp,loc1,loc2,min,max,exc,e,tp)
				if #g>0 then
					local ct=Duel.Destroy(g,REASON_COST)
					return g,ct
				end
				return g,0
			end
end
function Auxiliary.DiscardCost(f,min,max,exc)
	if not min then min=1 end
	if not max then max=min end
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local exc=(not exc) and nil or e:GetHandler()
				if chk==0 then return Duel.IsExistingMatchingCard(aux.DiscardFilter(f,true),tp,LOCATION_HAND,0,min,exc) end
				Duel.DiscardHand(tp,aux.DiscardFilter(f,true),min,max,REASON_COST|REASON_DISCARD,exc)
			end
end
function Auxiliary.BanishCost(f,loc1,loc2,min,max,exc,pos)
	loc1 = loc1 and loc1 or LOCATION_ONFIELD
	loc2 = loc2 and loc2 or 0
	min = min and min or 1
	max = max and max or min
	pos = pos and pos or POS_FACEUP
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local exc=(not exc) and nil or e:GetHandler()
				if chk==0 then return Duel.IsExistingMatchingCard(aux.BanishFilter(f,true,pos),tp,loc1,loc2,min,exc,e,tp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(tp,aux.BanishFilter(f,true,pos),tp,loc1,loc2,min,max,exc,e,tp)
				if #g>0 then
					local ct=Duel.Remove(g,pos,REASON_COST)
					return g,ct
				end
				return g,0
			end
end
function Auxiliary.RevealCost(f,min,max,exc,reset,rct)
	if not min then min=1 end
	if not max then max=min end
	
	if not reset then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local exc=(not exc) and nil or e:GetHandler()
					if chk==0 then return Duel.IsExistingMatchingCard(aux.RevealFilter(f),tp,LOCATION_HAND,0,min,exc) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
					local g=Duel.SelectMatchingCard(tp,aux.RevealFilter(f),tp,LOCATION_HAND,0,min,max,exc,e,tp,eg,ep,ev,re,r,rp)
					if #g>0 then
						Duel.ConfirmCards(1-tp,g)
					end
				end
	else
		if not rct then rct=1 end
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local exc=(not exc) and nil or e:GetHandler()
					if chk==0 then return Duel.IsExistingMatchingCard(aux.RevealFilter(f),tp,LOCATION_HAND,0,min,exc) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
					local g=Duel.SelectMatchingCard(tp,aux.RevealFilter(f),tp,LOCATION_HAND,0,min,max,exc,e,tp,eg,ep,ev,re,r,rp)
					for tc in aux.Next(g) do
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_PUBLIC)
						e1:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
						tc:RegisterEffect(e1)
					end
				end
	end
end
function Auxiliary.ToGraveCost(f,loc1,loc2,min,max,exc)
	if not loc1 then loc1=LOCATION_ONFIELD end
	if not loc2 then loc2=0 end
	if not min then min=1 end
	if not max then max=min end
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local exc=(not exc) and nil or e:GetHandler()
				if chk==0 then return Duel.IsExistingMatchingCard(aux.ToGraveFilter(f,true),tp,loc1,loc2,min,exc,e,tp,eg,ep,ev,re,r,rp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local g=Duel.SelectMatchingCard(tp,aux.ToGraveFilter(f,true),tp,loc1,loc2,min,max,exc,e,tp,eg,ep,ev,re,r,rp)
				if #g>0 then
					local ct=Duel.SendtoGrave(g,REASON_COST)
					return g,ct
				end
				return g,0
			end
end
function Auxiliary.ToHandCost(f,loc1,loc2,min,max,exc)
	if not loc1 then loc1=LOCATION_ONFIELD end
	if not loc2 then loc2=0 end
	if not min then min=1 end
	if not max then max=min end
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local exc=(not exc) and nil or e:GetHandler()
				if chk==0 then return Duel.IsExistingMatchingCard(aux.ToHandFilter(f,true),tp,loc1,loc2,min,exc,e,tp,eg,ep,ev,re,r,rp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local g=Duel.SelectMatchingCard(tp,aux.ToHandFilter(f,true),tp,loc1,loc2,min,max,exc,e,tp,eg,ep,ev,re,r,rp)
				if #g>0 then
					Duel.HintSelection(g)
					local ct=Duel.SendtoHand(g,nil,REASON_COST)
					return g,ct
				end
				return g,0
			end
end
function Auxiliary.ToDeckCost(f,loc1,loc2,min,max,exc,main_or_extra)
	f=aux.ToDeckFilter(f,true,main_or_extra)
	if not loc1 then loc1=LOCATION_ONFIELD end
	if not loc2 then loc2=0 end
	if not min then min=1 end
	if not max then max=min end
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local exc=(not exc) and nil or e:GetHandler()
				if chk==0 then return Duel.IsExistingMatchingCard(f,tp,loc1,loc2,min,exc,e,tp,eg,ep,ev,re,r,rp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(tp,f,tp,loc1,loc2,min,max,exc,e,tp,eg,ep,ev,re,r,rp)
				if #g>0 then
					local hg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE|LOCATION_REMOVED|LOCATION_EXTRA):Filter(Card.IsPublic,nil)
					if #hg>0 then
						Duel.HintSelection(hg)
					end
					local cfg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
					if #cfg>0 then
						Duel.ConfirmCards(1-tp,cfg)
					end
					local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
					return g,ct
				end
				return g,0
			end
end
function Auxiliary.TributeCost(f,min,max,exc)
	if not min then min=1 end
	if not max then max=min end
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local exc=(not exc) and nil or e:GetHandler()
				if chk==0 then return Duel.CheckReleaseGroup(tp,f,min,exc,e,tp,eg,ep,ev,re,r,rp) end
				local rg=Duel.SelectReleaseGroup(tp,f,min,max,exc,e,tp,eg,ep,ev,re,r,rp)
				if #rg>0 then
					local ct=Duel.Release(rg,REASON_COST)
					return rg,ct
				end
				return g,0
			end
end
--[[Generates cost that Tributes a cards
* f 		= Filter for cards that can be Tributed. Use aux.TRUE instead of nil if it is not possible to use additional Tributes from other locations
* min/max 	= Minimum and maximum amount of cards that can be Tributed
* exc 		= Card or Group that cannot be Tributed
* use_hand	= If true, it will be possible to Tribute cards from the hand as well
* use_oppo 	= If true, it will be possible to Tribute cards on the opponent's field as well. Remember to call aux.EnableGlobalEffectTributeOppoCost if you enable this option.
* exf		= Filter for cards that can be Tributed, in addition to those that are already Tributable on your field (and hand or opponent's field if use_hand and use_oppo are ture)
* exlocs	= Additional locations from which cards (that satisfy exf) can be Tributed
* exmin/exmax = Min and max amount of additional cards (that satisfy exf) that can be Tributed
* exexc		= Card or Group that is excluded from the additional Tributable cards
* pretribute = A function that is called before the Tributing occurs
* gf		= Filter that the group of Tributed cards must satisfy in order to be a valid selection
* finishcon = Function that determines whether a given selection is valid, even before the maximum amount of selectable cards is reached. If true, finishcon will coincide with gf
]]
function Auxiliary.TributeGlitchyCost(f,min,max,exc,use_hand,use_oppo,exf,exloc1,exloc2,exmin,exmax,exexc,pretribute,gf,finishcon)
	if not min then min=1 end
	if not max then max=min end
	if use_hand==nil then use_hand=false end
	exloc1 = exloc1 or 0
	exloc2 = exloc2 or 0
	local isfilter=type(f)=="function"
	finishcon=finishcon==true and gf or finishcon
	if exloc2&LOCATION_MZONE>0 then
		aux.EnableGlobalEffectTributeOppoCost()
	end
	if gf or not (exloc1==0 and exloc2~=LOCATION_MZONE) then
		return function(e,tp,eg,ep,ev,re,r,rp,chk)
			if use_oppo then aux.TributeOppoCostFlag=true end
			local g1=isfilter and Duel.GetReleaseGroup(tp,use_hand) or Group.CreateGroup()
			if exf then
				local g2=Duel.Group(Card.IsReleasable,tp,exloc1,exloc2,exexc):Filter(exf,nil,e,tp)
				g1:Merge(g2)
			end
			if isfilter or exc then
				g1=g1:Filter(f,exc,e,tp)
			end
			if chk==0 then
				local res
				if gf then
					res=aux.SelectUnselectGroup(g1,e,tp,min,max,gf,0)
				else
					res=#g1>=min
				end
				aux.TributeOppoCostFlag=false
				return res
			end
			Duel.HintMessage(tp,HINTMSG_RELEASE)
			local sg=gf and aux.SelectUnselectGroup(g1,e,tp,min,max,gf,1,tp,HINTMSG_RELEASE,finishcon) or g1:Select(tp,min,max,exc)
			aux.TributeOppoCostFlag=false
			local exg=sg:Filter(Auxiliary.ExtraReleaseFilter,nil,tp)
			for ec in Auxiliary.Next(exg) do
				local te=ec:IsHasEffect(EFFECT_EXTRA_RELEASE_NONSUM,tp)
				if te and (not g2:IsContains(ec) or Duel.SelectYesNo(tp,STRING_ASK_EXTRA_RELEASE_NONSUM)) then
					Duel.Hint(HINT_CARD,tp,te:GetHandler():GetOriginalCode())
					te:UseCountLimit(tp)
				end
			end
			if pretribute then
				pretribute(sg,e,tp,eg,ep,ev,re,r,rp)
			end
			Duel.Release(sg,REASON_COST)
		end
	else
		if exf then
			f=aux.TributeGlitchyCostFilter(f,exf)
		end
		return function(e,tp,eg,ep,ev,re,r,rp,chk)
			if use_oppo then aux.TributeOppoCostFlag=true end
			if chk==0 then
				local res=Duel.CheckReleaseGroupEx(tp,f,min,REASON_COST,use_hand,exc,e,tp)
				aux.TributeOppoCostFlag=false
				return res
			end
			Duel.HintMessage(tp,HINTMSG_RELEASE)
			local sg=Duel.SelectReleaseGroupEx(tp,f,min,max,REASON_COST,use_hand,exc,e,tp)
			aux.TributeOppoCostFlag=false
			if pretribute then
				pretribute(sg,e,tp,eg,ep,ev,re,r,rp)
			end
			Duel.Release(sg,REASON_COST)
		end
	end
end
function Auxiliary.TributeGlitchyCostFilter(f,exf)
	return	function(c,e,tp)
				if not f(c,e,tp) then return false end
				if c:IsControler(1-tp) then
					return exf(c,e,tp)
				end
				return true
			end
end
-----------------------------------------------------------------------
--Self as Cost
function Auxiliary.BanishFacedownSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost(POS_FACEDOWN) end
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_COST)
end
function Auxiliary.DiscardSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function Auxiliary.DetachSelfCost(min,max)
	if not min then min=1 end
	if not max or max<min then max=min end
	
	if min==max then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then return c:CheckRemoveOverlayCard(tp,min,REASON_COST) end
					c:RemoveOverlayCard(tp,min,min,REASON_COST)
				end
	else
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then
						for i=min,max do
							if c:CheckRemoveOverlayCard(tp,i,REASON_COST) then
								return true
							end
						end
						return false
					end
					local list={}
					for i=min,max do
						if c:CheckRemoveOverlayCard(tp,i,REASON_COST) then
							table.insert(list,i)
						end
					end
					if #list==0 then return end
					if #list==max-min then
						c:RemoveOverlayCard(tp,min,max,REASON_COST)
					else
						local ct=Duel.AnnounceNumber(tp,table.unpack(list))
						c:RemoveOverlayCard(tp,ct,ct,REASON_COST)
					end
				end
	end
end
function Auxiliary.RevealSelfCost(reset,rct)
	if not rct then rct=1 end
	
	if not reset then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then return not c:IsPublic() end
				if not c:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,c) end
			end
	else
		if not rct then rct=1 end
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then return not c:IsPublic() end
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetReset(RESET_EVENT|RESETS_STANDARD|reset,rct)
					c:RegisterEffect(e1)
				end
	end
end
function Auxiliary.RemoveCounterSelfCost(ctype,min,max)
	if not min then min=1 end
	if not max or max<min then max=min end
	
	if min==max then
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then return c:IsCanRemoveCounter(tp,ctype,min,REASON_COST) end
					c:RemoveCounter(tp,ctype,min,REASON_COST)
				end
	else
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then
						for i=min,max do
							if c:IsCanRemoveCounter(tp,ctype,i,REASON_COST) then
								return true
							end
						end
						return false
					end
					local list={}
					for i=min,max do
						if c:IsCanRemoveCounter(tp,ctype,i,REASON_COST) then
							table.insert(list,i)
						end
					end
					if #list==0 then return end
					local ct=Duel.AnnounceNumber(tp,table.unpack(list))
					c:RemoveCounter(tp,ctype,ct,REASON_COST)
				end
	end
end
function Auxiliary.ToDeckSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function Auxiliary.ToExtraSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function Auxiliary.ToGraveSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function Auxiliary.ToHandSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function Auxiliary.TributeSelfCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

function Auxiliary.TributeForSummonFilter(f,sumtype,sump,ign1,ign2,pos,recp,zone)
	local reason
	if sumtype==SUMMON_TYPE_FUSION then
		reason = REASON_FUSION
	elseif sumtype==SUMMON_TYPE_SYNCHRO then
		reason = REASON_SYNCHRO
	elseif sumtype==SUMMON_TYPE_XYZ then
		reason = REASON_XYZ
	elseif sumtype==SUMMON_TYPE_LINK then
		reason = REASON_LINK
	end
	if reason then
		return	function(c,e,tp,...)
					local pg=aux.GetMustBeMaterialGroup(sump,Group.CreateGroup(),sump,c,nil,reason)
					return #pg<=0 and (not f or f(c,e,tp,...)) and c:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,recp,zone)
						and ((not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(recp,e:GetHandler(),sump,LOCATION_REASON_TOFIELD,zone)>0)
						or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(recp,sump,e:GetHandler(),c,zone)>0))
				end
	else
		return	function(c,e,tp,...)
					return (not f or f(c,e,tp,...)) and c:IsCanBeSpecialSummoned(e,sumtype,sump,ign1,ign2,pos,recp,zone)
						and ((not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(recp,e:GetHandler(),sump,LOCATION_REASON_TOFIELD,zone)>0)
						or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(recp,sump,e:GetHandler(),c,zone)>0))
				end
	end
end
function Auxiliary.TributeForSummonSelfCost(f,loc1,loc2,sumtype,sump,ign1,ign2,pos,recp,zone)
	if not loc1 then loc1=LOCATION_DECK end
	if not loc2 then loc2=0 end
	
	if not sumtype then sumtype=0 end
	if not ign1 then ign1=false end
	if not ign2 then ign2=false end
	if not pos then pos=POS_FACEUP end
	if not zone then zone=0xff end
	
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local sump = sump and sump==1 and 1-tp or tp
				local recp = recp and recp==1 and 1-tp or tp
				local zone = type(zone)=="number" and zone or zone(e,tp)
				e:SetLabel(1)
				if chk==0 then
					return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(aux.TributeForSummonFilter(f,sumtype,sump,ign1,ign2,pos,recp,zone),tp,loc1,loc2,1,nil,e,tp,eg,ep,ev,re,r,rp)
				end
				Duel.Release(e:GetHandler(),REASON_COST)
			end
end

-----------------------------------------------------------------------
--Counter Costs
function Auxiliary.RemoveCounterCost(ctype,ct,self,oppo)
	if not ct then ct=1 end
	if not self then self=1 end
	if not oppo then oppo=0 end
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then
					return Duel.IsCanRemoveCounter(tp,self,oppo,ctype,ct,REASON_COST)
				end
				Duel.RemoveCounter(tp,self,oppo,ctype,ct,REASON_COST)
			end
end

-----------------------------------------------------------------------
--LP Payment Costs
function Auxiliary.PayLPCost(lp)
	if not lp then lp=1000 end
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return Duel.CheckLPCost(tp,lp) end
				Duel.PayLPCost(tp,lp)
			end
end
function Auxiliary.PayHalfLPCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

-----------------------------------------------------------------------
--Restrictions (Limits)
function Auxiliary.AttackRestrictionCost(oath,reset,desc)
	local prop=EFFECT_FLAG_CANNOT_DISABLE
	if oath then prop=prop|EFFECT_FLAG_OATH end
	if desc then prop=prop|EFFECT_FLAG_CLIENT_HINT end
	if not reset then reset=RESET_PHASE+PHASE_END end
	
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then return c:GetAttackAnnouncedCount()==0 end
				local e1=Effect.CreateEffect(c)
				if desc then e1:Desc(desc) end
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(prop)
				e1:SetCode(EFFECT_CANNOT_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
				c:RegisterEffect(e1)
			end
end

--[[Scripts the following restriction: "You cannot Special Summon monsters the turn you activate/use this effect, except [f] monsters".
* f 	= Filter for the monsters that can still be SSed under the restriction
* oath	= If true, the restriction is not applied if the activation of the effect is negated
* reset	= Defines the reset timing for the restriction
* id	= ID used for the activity counter and the description string
* cf	= Filter for the activity counter (if not a function, it matches f). It supports LOCATION constants in order to exclude monsters Special Summoned from a specific location from being counted
		towards the restriction
* desc	= Description id (0 to 16)

OPTIONAL PARAMS:
* other = If true, it scripts "You cannot Special Summon OTHER monsters the turn you activate/use this effect, except [f] monsters"
* cost	= It is possible to invoke an additional user-defined cost function along with the one that handles the restriction.
]]
function Auxiliary.SSRestrictionCost(f,oath,reset,id,cf,desc,...)
	local x={...}
	local cost	= #x>0 and x[#x] or nil
	local other	= #x>1 and x[#x-1] or nil
	
	if id then
		local donotcount_function = type(cf)=="function" and cf or f
		if type(cf)=="number" then
			local new_donotcount_function = function(c,...)
				return not c:IsSummonLocation(cf) or donotcount_function(c,...)
			end
			Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,new_donotcount_function)
		else
			Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,donotcount_function)
		end
	end
	local prop=EFFECT_FLAG_PLAYER_TARGET
	if oath then prop=prop|EFFECT_FLAG_OATH end
	if desc then prop=prop|EFFECT_FLAG_CLIENT_HINT end
	if not reset then reset=RESET_PHASE|PHASE_END end
	
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,chk)) end
				local e1=Effect.CreateEffect(e:GetHandler())
				if desc then
					e1:SetDescription(id,desc)
				end
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(prop)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetReset(reset)
				e1:SetTargetRange(1,0)
				if type(cf)~="number" then
					e1:SetTarget(	function(eff,c,sump,sumtype,sumpos,targetp,se)
										return not f(c,eff,sump,sumtype,sumpos,targetp,se) and (not other or se~=e)
									end
								)
				else
					e1:SetTarget(	function(eff,c,sump,sumtype,sumpos,targetp,se)
										return not f(c,eff,sump,sumtype,sumpos,targetp,se) and c:IsLocation(cf) and (not other or se~=e)
									end
								)
				end
				Duel.RegisterEffect(e1,tp)
				if cost then
					cost(e,tp,eg,ep,ev,re,r,rp,chk)
				end
			end
end

function Auxiliary.AddActivationCounter(id,f)
	return Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,f)
end
function Auxiliary.AddSSCounter(id,f)
	return Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,f)
end

--old names
function Auxiliary.SSLimit(f,desc,oath,reset,id,cf)
	return Auxiliary.SSRestrictionCost(f,oath,reset,id,cf,desc)
end
function Card.ActivationCounter(c,f)
	return Duel.AddCustomActivityCounter(c:GetOriginalCode(),ACTIVITY_CHAIN,f)
end
function Card.SSCounter(c,f)
	return Duel.AddCustomActivityCounter(c:GetOriginalCode(),ACTIVITY_SPSUMMON,f)
end