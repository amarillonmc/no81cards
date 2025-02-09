--AUX.SELECTUNSELECTLOOP PORTED FROM EDOPRO
--sg: This group is initially empty and is gradually filled with cards from g.
--mg: This is a clone of the sample group (g) but it does not contain the cards that failed the loop check
--rescon: The condition that must be satisfied by the cards in the temporary checked group (sg). If the "stop" condition is fulfilled, the card is immediately removed from "sg" and fails the loop check
function Auxiliary.SelectUnselectLoop(c,sg,mg,e,tp,minc,maxc,rescon)
	local res=not rescon
	if #sg>=maxc then return false end
	sg:AddCard(c)
	if rescon then
		local stop
		res,stop=rescon(sg,e,tp,mg,c)
		if stop then
			sg:RemoveCard(c)
			return false
		end
	end
	if #sg<minc then
		res=mg:IsExists(Auxiliary.SelectUnselectLoop,1,sg,sg,mg,e,tp,minc,maxc,rescon)
	elseif #sg<maxc and not res then
		res=mg:IsExists(Auxiliary.SelectUnselectLoop,1,sg,sg,mg,e,tp,minc,maxc,rescon)
	end
	sg:RemoveCard(c)
	return res
end
function Auxiliary.SelectUnselectGroup(g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,finishcon,breakcon,cancelable)
	local minc=minc or 1
	local maxc=maxc or #g
	if chk==0 then
		if #g<minc then return false end
		local eg=g:Clone()
		for c in aux.Next(g) do
			if Auxiliary.SelectUnselectLoop(c,Group.CreateGroup(),eg,e,tp,minc,maxc,rescon) then return true end
			eg:RemoveCard(c)
		end
		return false
	end
	local hintmsg=hintmsg or 0
	local sg=Group.CreateGroup()
	while true do
		local finishable = #sg>=minc and (not finishcon or finishcon(sg,e,tp,g))
		local mg=g:Filter(Auxiliary.SelectUnselectLoop,sg,sg,g,e,tp,minc,maxc,rescon)
		if (breakcon and breakcon(sg,e,tp,mg)) or #mg<=0 or #sg>=maxc then break end
		Duel.Hint(HINT_SELECTMSG,seltp,hintmsg)
		local tc=mg:SelectUnselect(sg,seltp,finishable,finishable or (cancelable and #sg==0),minc,maxc)
		if not tc then break end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
		else
			sg:AddCard(tc)
		end
	end
	return sg
end

--[[Differently from the regular SelectUnselectLoop, now rescon can also be used to define a razor filter that will restrict which members of (mg) can be added to the current subgroup]]
function Glitchy.SelectUnselectLoop(c,sg,mg,e,tp,minc,maxc,rescon)
	local res=not rescon
	if #sg>=maxc then return false end
	local mg2=mg:Clone()
	sg:AddCard(c)
	local razor
	if rescon then
		local stop
		res,stop,razor=rescon(sg,e,tp,mg2,c)
		if stop then
			sg:RemoveCard(c)
			return false
		end
	end
	
	if razor then
		if type(razor)=="table" then
			local razorfunc=razor[1]
			table.remove(razor,1)
			mg2=mg2:Filter(razorfunc,nil,table.unpack(razor))
		else
			mg2=mg2:Filter(razor,nil)
		end
	end
	
	if #sg<minc then
		res=mg2:IsExists(Glitchy.SelectUnselectLoop,1,sg,sg,mg2,e,tp,minc,maxc,rescon)
	elseif #sg<maxc and not res then
		res=mg2:IsExists(Glitchy.SelectUnselectLoop,1,sg,sg,mg2,e,tp,minc,maxc,rescon)
	end
	sg:RemoveCard(c)
	return res
end

--[[Function to check the existence and to select subgroups of (g) that satisfy a certain (rescon)
Hybrid method for selecting and unselecting cards from a group (g).
The method dynamically switches between two selection approaches depending on the group size:
- The regular Auxiliary.SelectUnselectGroup is used for small groups (when the group size is below a threshold).
- The Glitchy implementation is used for large groups (when the group size exceeds the threshold).

**Parameters:**
  g (Group): The group of cards from which a selection is being made.
  e (Effect): The effect triggering the selection.
  tp (Player): The player whose cards are being selected.
  minc (integer): The minimum number of cards required in the selected group.
  maxc (integer): The maximum number of cards allowed in the selected group.
  rescon (function): A function that checks the validity of a subgroup based on the current selection.
  chk (integer): A flag used for the check phase (0 or 1).
  seltp (integer): Selecting player.
  hintmsg (integer): The message type for hinting.
  finishcon (function): A function to check if the current group is finishable.
  breakcon (function): A function that checks whether the loop should break.
  cancelable (boolean): Whether the selection can be canceled.
  firstElementFilter (function): If this filter is defined, it forces the check/selection to start from an element of the group that satisfies the filter's condition

**Return:**
  The selected group (Group) of cards that satisfies the conditions defined by `minc`, `maxc`, and `rescon` (if chk==1), or whether a valid subgroup exists (if chk==0)

**Steps
1) (g) is cloned into (eg)
2) The first member (c0) of (eg) is passed to rescon, and the latter is evaluated (sg is the current subgroup being built and checked, while mg is the group of available members that can still be added to the current subgroup)
3) Regardless of the result, another member is taken from (eg) and is evaluated. This process repeats until the subgroup reaches the minimum size AND satisfies rescon. If the subgroup reaches the maximum size and it still does NOT satisfy rescon, then the member (c0) is removed from (eg) and the process starts again from STEP 2 with the next member of (eg): note that the previous (c0) will not be able to be added to any subgroup from that point onwards
4) If rescon returns a second false, the subgroup creation abrupts immediately and the check is failed. (c0) is removed from (eg) and the process starts again from STEP 2 with the next member of (eg): note that the previous (c0) will not be able to be added to any subgroup from that point onwards.

The rescon function is expected to return three possible outputs:
1) Boolean: The first return value indicates whether the current subgroup (sg) is valid or not.
2) Boolean: The second return value is a flag (stop) that determines if the subgroup selection process should be halted immediately. If stop is true, the current selection process is stopped, and the function backtracks.
3) Optional Value (razor): The third return value is an optional value, which can either be a function, a table, or nil. If provided, it allows for additional modifications or pruning of the group. Specifically:
	- A function (razorfunc): This function can be used to prune the remaining candidates for selection based on some criteria. It applies a filtering function to mg2 (the candidate group) to narrow down the possible selections further.
	- A table (razor): If a table is returned, the first element is expected to be the pruning function, while the remaining ones are the parameters required by such function
	- nil: If razor is nil, no further pruning or filtering is applied.
]]

GLITCHY_LARGE_GROUP_THRESHOLD_STRICT = 6

local function ApplyDelta(group,delta)
    for card in aux.Next(delta.added) do group:AddCard(card) end
    for card in aux.Next(delta.removed) do group:RemoveCard(card) end --for futureproofing
end
function Glitchy.SelectUnselectGroup(customLargeGroupThreshold,g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,finishcon,breakcon,cancelable,firstElementFilter)
	if aux.GetValueType(customLargeGroupThreshold)=="Group" then
		g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,finishcon,breakcon,cancelable=customLargeGroupThreshold,g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,finishcon,breakcon
		customLargeGroupThreshold=nil
	end

	local LARGE_GROUP_SIZE = customLargeGroupThreshold or 16
	
	--Use regular auxiliary for small groups
	if #g<LARGE_GROUP_SIZE then
		return aux.SelectUnselectGroup(g,e,tp,minc,maxc,rescon,chk,seltp,hintmsg,finishcon,breakcon,cancelable)
	end
	
	local minc=minc or 1
	local maxc=maxc or #g
	if chk==0 then
		if #g<minc then return false end
		local eg=g:Clone()
		if firstElementFilter then
			local fg=g:Filter(firstElementFilter,nil,e,tp)
			for c in aux.Next(fg) do
				if Glitchy.SelectUnselectLoop(c,Group.CreateGroup(),eg,e,tp,minc,maxc,rescon) then return true end
				eg:RemoveCard(c)
			end
			return false
		else
			for c in aux.Next(g) do
				if Glitchy.SelectUnselectLoop(c,Group.CreateGroup(),eg,e,tp,minc,maxc,rescon) then return true end
				eg:RemoveCard(c)
			end
		end
		return false
	end
	local hintmsg=hintmsg or 0
	local sg=Group.CreateGroup()
	local history={}
	local deltas={}
	local g2=g:Clone()
	while true do
		local finishable = #sg>=minc and (not finishcon or finishcon(sg,e,tp,g2))
		local mg=g2:Filter(Glitchy.SelectUnselectLoop,sg,sg,g2,e,tp,minc,maxc,rescon)
		if (breakcon and breakcon(sg,e,tp,mg)) or #mg<=0 or #sg>=maxc then break end
		local selg=(firstElementFilter and #sg==0) and mg:Filter(firstElementFilter,nil,e,tp) or mg
		Duel.Hint(HINT_SELECTMSG,seltp,hintmsg)
		local tc=selg:SelectUnselect(sg,seltp,finishable,finishable or (cancelable and #sg==0),minc,maxc)
		if not tc then break end
		if sg:IsContains(tc) then
			while true do
				local tc2=table.remove(history)
				sg:RemoveCard(tc2)
				local lastDelta = table.remove(deltas)
				ApplyDelta(g2, { added = lastDelta.removed, removed = lastDelta.added })
				if tc2==tc then
					break
				end
			end
		else
			sg:AddCard(tc)
			
			if rescon then
				local delta = { added = Group.CreateGroup(), removed = Group.CreateGroup() }	--delta.added just for futureproofing
				table.insert(deltas, delta)

				
				table.insert(history,tc)
				local _,_,razor=rescon(sg,e,tp,mg,tc)
				if razor then
					if type(razor)=="table" then
						local razorfunc=razor[1]
						table.remove(razor,1)
						g2=g2:Filter(razorfunc,nil,table.unpack(razor))
					else
						g2=g2:Filter(razor,nil)
					end
					delta.removed = g:Filter(function(card) return not g2:IsContains(card) end, nil)
				end
			end
		end
	end
	return sg
end


--SelectUnselectGroup aux functions
function Auxiliary.dncheckbrk(g,e,tp,mg,c)
	local res=g:GetClassCount(Card.GetCode)==#g
	return res, not res
end
function Glitchy.dncheck(g,e,tp,mg,c)
    local valid = g:GetClassCount(Card.GetCode)==#g
    local razor = {aux.NOT(Card.IsCode),c:GetCode()}
    return valid,false,razor
end

function Auxiliary.sncheck(g)
	return g:GetClassCount(Card.GetCode)==1
end

function Auxiliary.ogdncheckbrk(g,e,tp,mg,c)
	local res=g:GetClassCount(Card.GetOriginalCodeRule)==#g
	return res, not res
end

--check for Free Monster Zones
function Auxiliary.ChkfMMZ(sumcount)
	return	function(sg,e,tp,mg)
				return Duel.GetMZoneCount(tp,sg)>=sumcount
			end
end