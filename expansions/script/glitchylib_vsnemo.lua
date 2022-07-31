Glitchy = Glitchy or {}

self_reference_effect				= nil
self_reference_tp					= nil

LOCATION_ALL = LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA

EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER	= 33720071
EFFECT_UTTER_CONFUSION_CONFIDENCE		= 33720072

Glitchy.EnableTestChamber = false
Glitchy.TestChamberResult = 0
Glitchy.TestChamberResultGroup = {}
Glitchy.UndefinedActionWarning = false

GLITCHY_ENABLE_TEST_CHAMBER = 33720071
TEST_CHAMBER_TARGET = 0x1
TEST_CHAMBER_TOHAND = 0x2

--Internal Archetypes
ARCHE_UTTER_CONFUSION = {33720051,33720052,33720053,33720070,33720071,33720072,33720073,33720074}

--TEST CHAMBER MECHANIC (necessary for UTTER CONFUSION - CONFIDENCE)
local _Hint, _IsCanBeEffectTarget, _IsAbleToHand, _IsAbleToHandAsCost, _SelectMatchingCard, _SelectTarget, _GetMatchingGroup, _GroupFilter, _GroupSelect, _FilterSelect, _SelectUnselect, _GroupMerge, _GroupClone, _SelectSubGroup,
_SelectSubGroupEach, _SelectWithSumEqual, _SelectWithSumGreater =
Duel.Hint, Card.IsCanBeEffectTarget, Card.IsAbleToHand, Card.IsAbleToHandAsCost, Duel.SelectMatchingCard, Duel.SelectTarget, Duel.GetMatchingGroup, Group.Filter, Group.Select, Group.FilterSelect, Group.SelectUnselect, Group.Merge, Group.Clone,
Group.SelectSubGroup, Group.SelectSubGroupEach, Group.SelectWithSumEqual, Group.SelectWithSumGreater

Duel.Hint = function(hinttype,p,hint)
	if hint==HINTMSG_OPERATECARD then
		Glitchy.UndefinedActionWarning = true
	end
	return _Hint(hinttype,p,hint)
end
Card.IsCanBeEffectTarget = function(c,e)
	if Glitchy.EnableTestChamber and Glitchy.TestChamberResult&TEST_CHAMBER_TARGET==0 then
		Glitchy.TestChamberResult = Glitchy.TestChamberResult | TEST_CHAMBER_TARGET
	end
	return _IsCanBeEffectTarget(c,e)
end
Card.IsAbleToHand = function(c,...)
	local x = {...}
	local p = x[1]
	if Glitchy.EnableTestChamber and Glitchy.TestChamberResult&TEST_CHAMBER_TOHAND==0 and (not p or p==self_reference_effect) then
		Glitchy.TestChamberResult = Glitchy.TestChamberResult | TEST_CHAMBER_TOHAND
	end
	return _IsAbleToHand(c,...)
end
Card.IsAbleToHandAsCost = function(c)
	if Glitchy.EnableTestChamber and Glitchy.TestChamberResult&TEST_CHAMBER_TOHAND==0 then
		Glitchy.TestChamberResult = Glitchy.TestChamberResult | TEST_CHAMBER_TOHAND
	end
	return _IsAbleToHandAsCost(c)
end
	
Duel.SelectMatchingCard = function(p,f,pov,loc1,loc2,min,max,exc,...)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 then
		local test_chamber = _GetMatchingGroup(f,pov,loc1,loc2,exc,...)
		Glitchy.EnableTestChamber = true
		Glitchy.TestChamberResult = 0
		for tc in aux.Next(test_chamber) do
			f(tc,...)
		end
		Glitchy.EnableTestChamber = false
		local result = Glitchy.TestChamberResult
		Glitchy.TestChamberResult = 0
		
		local player = p
		local nloc1,nloc2 = loc1,loc2
		if p==self_reference_effect:GetHandlerPlayer() then
			if result&TEST_CHAMBER_TARGET>0 and Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER) then
				player = 1-p
			
			elseif result&TEST_CHAMBER_TOHAND>0 and not Glitchy.UndefinedActionWarning and Duel.IsPlayerAffectedByEffect(p,EFFECT_UTTER_CONFUSION_CONFIDENCE) then
				if loc1&~(LOCATION_DECK+LOCATION_GRAVE)==0 and loc2==0 then
					player = 1-p
				else
					local opt = loc1&(LOCATION_DECK+LOCATION_GRAVE)==0 and 2 or Duel.SelectOption(p,aux.Stringid(33720071,0),aux.Stringid(33720071,1))
					if opt==0 then
						player = 1-p
						nloc1=nloc1&(LOCATION_DECK+LOCATION_GRAVE)
						nloc2=0
					elseif opt==1 then
						nloc1 = nloc1&~(LOCATION_DECK+LOCATION_GRAVE)
					end
				end
			end
		end
		if Glitchy.UndefinedActionWarning then
			Glitchy.UndefinedActionWarning = false
		end
		
		return _SelectMatchingCard(player,f,pov,nloc1,nloc2,min,max,exc,...)
	
	else
		return _SelectMatchingCard(p,f,pov,loc1,loc2,min,max,exc,...)
	end
end

Duel.GetMatchingGroup = function(f,pov,loc1,loc2,exc,...)
	local g = _GetMatchingGroup(f,pov,loc1,loc2,exc,...)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 then
		Glitchy.EnableTestChamber = true
		Glitchy.TestChamberResult = 0
		for tc in aux.Next(g) do
			f(tc,...)
		end
		Glitchy.EnableTestChamber = false
		Glitchy.TestChamberResultGroup[g] = Glitchy.TestChamberResult
		Glitchy.TestChamberResult = 0
	end
	return g
end

Group.Filter = function(g,f,exc,...)
	local new_g = _GroupFilter(g,f,exc,...)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 then
		Glitchy.EnableTestChamber = true
		Glitchy.TestChamberResult = 0
		for tc in aux.Next(g) do
			f(tc,...)
		end
		Glitchy.EnableTestChamber = false
		Glitchy.TestChamberResultGroup[new_g] = Glitchy.TestChamberResult
		if type(Glitchy.TestChamberResultGroup[g])=="number" then
			Glitchy.TestChamberResultGroup[new_g] = Glitchy.TestChamberResultGroup[new_g] | Glitchy.TestChamberResultGroup[g]
		end
		Glitchy.TestChamberResult = 0
	end
	return new_g
end

Duel.SelectTarget = function(p,f,pov,loc1,loc2,min,max,exc,...)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 then
		local test_chamber = _GetMatchingGroup(f,pov,loc1,loc2,exc,...)
		Glitchy.EnableTestChamber = true
		Glitchy.TestChamberResult = 0
		for tc in aux.Next(test_chamber) do
			f(tc,...)
		end
		Glitchy.EnableTestChamber = false
		local result = Glitchy.TestChamberResult
		Glitchy.TestChamberResult = 0
		
		local player = p
		local nloc1,nloc2 = loc1,loc2
		if p==self_reference_effect:GetHandlerPlayer() then
			if Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER) then
				for _,ce in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER)}) do
					if ce and aux.GetValueType(ce)=="Effect" and ce.SetLabel then
						local val=ce:GetValue()
						if not val or val(ce,self_reference_effect,self_reference_tp) then
							player = 1-p
							break
						end
					end
				end
			
			elseif result&TEST_CHAMBER_TOHAND>0 and not Glitchy.UndefinedActionWarning and Duel.IsPlayerAffectedByEffect(p,EFFECT_UTTER_CONFUSION_CONFIDENCE) then
				if loc1&~(LOCATION_DECK+LOCATION_GRAVE)==0 and loc2==0 then
					player = 1-p
				else
					local opt = loc1&(LOCATION_DECK+LOCATION_GRAVE)==0 and 2 or Duel.SelectOption(p,aux.Stringid(33720071,0),aux.Stringid(33720071,1))
					if opt==0 then
						player = 1-p
						nloc1=nloc1&(LOCATION_DECK+LOCATION_GRAVE)
						nloc2=0
					elseif opt==1 then
						nloc1 = nloc1&~(LOCATION_DECK+LOCATION_GRAVE)
					end
				end
			end
		end
		if Glitchy.UndefinedActionWarning then
			Glitchy.UndefinedActionWarning = false
		end
		
		return _SelectTarget(player,f,pov,loc1,loc2,min,max,exc,...)
	
	else
		return _SelectTarget(p,f,pov,loc1,loc2,min,max,exc,...)
	end
end

Group.Select = function(g,p,min,max,exc)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 and type(Glitchy.TestChamberResultGroup[g])=="number" then
		local result = Glitchy.TestChamberResultGroup[g]
		
		local player = p
		if p==self_reference_effect:GetHandlerPlayer() then
			if result&TEST_CHAMBER_TARGET>0 and Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER) then
				for _,ce in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER)}) do
					if ce and aux.GetValueType(ce)=="Effect" and ce.SetLabel then
						local val=ce:GetValue()
						if not val or val(ce,self_reference_effect,self_reference_tp) then
							player = 1-p
							break
						end
					end
				end
			
			elseif result&TEST_CHAMBER_TOHAND>0 and not Glitchy.UndefinedActionWarning and Duel.IsPlayerAffectedByEffect(p,EFFECT_UTTER_CONFUSION_CONFIDENCE) then
				if not g:IsExists(function(card,tp) return not card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or card:IsControler(1-tp) end,1,nil,p) then
					player = 1-p
				else
					local opt=Duel.SelectOption(p,aux.Stringid(33720071,0),aux.Stringid(33720071,1))
					if opt==0 then
						player = 1-p
						g = _GroupFilter(g,function(card,tp) return card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and card:IsControler(tp) end,nil,p)
					else
						g = _GroupFilter(g,function(card,tp) return not card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or card:IsControler(1-tp) end,nil,p)
					end
				end
			end
		end
		if Glitchy.UndefinedActionWarning then
			Glitchy.UndefinedActionWarning = false
		end
		
		return _GroupSelect(g,player,min,max,exc)
	
	else
		return _GroupSelect(g,p,min,max,exc)
	end
end

Group.FilterSelect = function(g,p,f,min,max,exc,...)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 then
		Glitchy.EnableTestChamber = true
		Glitchy.TestChamberResult = 0
		for tc in aux.Next(g) do
			f(tc,...)
		end
		Glitchy.EnableTestChamber = false
		if type(Glitchy.TestChamberResultGroup[g])=="number" then
			Glitchy.TestChamberResult = Glitchy.TestChamberResult | Glitchy.TestChamberResultGroup[g]
		end
		local result = Glitchy.TestChamberResult
		Glitchy.TestChamberResult = 0
		
		local player = p
		if p==self_reference_effect:GetHandlerPlayer() then
			if result&TEST_CHAMBER_TARGET>0 and Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER) then
				for _,ce in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER)}) do
					if ce and aux.GetValueType(ce)=="Effect" and ce.SetLabel then
						local val=ce:GetValue()
						if not val or val(ce,self_reference_effect,self_reference_tp) then
							player = 1-p
							break
						end
					end
				end
			
			elseif result&TEST_CHAMBER_TOHAND>0 and not Glitchy.UndefinedActionWarning and Duel.IsPlayerAffectedByEffect(p,EFFECT_UTTER_CONFUSION_CONFIDENCE) then
				if not g:IsExists(function(card,tp) return not card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or card:IsControler(1-tp) end,1,nil,p) then
					player = 1-p
				else
					local opt=Duel.SelectOption(p,aux.Stringid(33720071,0),aux.Stringid(33720071,1))
					if opt==0 then
						player = 1-p
						g = _GroupFilter(g,function(card,tp) return card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and card:IsControler(tp) end,nil,p)
					else
						g = _GroupFilter(g,function(card,tp) return not card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or card:IsControler(1-tp) end,nil,p)
					end
				end
			end
		end
		if Glitchy.UndefinedActionWarning then
			Glitchy.UndefinedActionWarning = false
		end
		
		return _FilterSelect(g,player,f,min,max,exc,...)
	
	else
		return _FilterSelect(g,p,f,min,max,exc,...)
	end
end

Group.SelectUnselect = function(g,ug,p,...)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 and type(Glitchy.TestChamberResultGroup[g])=="number" then
		local result = Glitchy.TestChamberResultGroup[g]
		
		local player = p
		if p==self_reference_effect:GetHandlerPlayer() then
			if result&TEST_CHAMBER_TARGET>0 and Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER) then
				for _,ce in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER)}) do
					if ce and aux.GetValueType(ce)=="Effect" and ce.SetLabel then
						local val=ce:GetValue()
						if not val or val(ce,self_reference_effect,self_reference_tp) then
							player = 1-p
							break
						end
					end
				end
			
			elseif result&TEST_CHAMBER_TOHAND>0 and not Glitchy.UndefinedActionWarning and Duel.IsPlayerAffectedByEffect(p,EFFECT_UTTER_CONFUSION_CONFIDENCE) then
				if not g:IsExists(function(card,tp) return not card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or card:IsControler(1-tp) end,1,nil,p) then
					player = 1-p
				else
					local opt=Duel.SelectOption(p,aux.Stringid(33720071,0),aux.Stringid(33720071,1))
					if opt==0 then
						player = 1-p
						g = _GroupFilter(g,function(card,tp) return card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and card:IsControler(tp) end,nil,p)
					else
						g = _GroupFilter(g,function(card,tp) return not card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or card:IsControler(1-tp) end,nil,p)
					end
				end
			end
		end
		if Glitchy.UndefinedActionWarning then
			Glitchy.UndefinedActionWarning = false
		end
		
		return _SelectUnselect(g,ug,player,...)
	
	else
		return _SelectUnselect(g,ug,p,...)
	end
end

Group.Merge = function(g,c)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 and aux.GetValueType(c)=="Group" and type(Glitchy.TestChamberResultGroup[c])=="number" then
		if type(Glitchy.TestChamberResultGroup[g])~="number" then Glitchy.TestChamberResultGroup[g] = 0 end
		Glitchy.TestChamberResultGroup[g] = Glitchy.TestChamberResultGroup[g] + Glitchy.TestChamberResultGroup[c]
	end
	return _GroupMerge(g,c)
end

Group.Clone = function(g,g2)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 and type(Glitchy.TestChamberResultGroup[g2])=="number" then
		if type(Glitchy.TestChamberResultGroup[g])~="number" then Glitchy.TestChamberResultGroup[g] = 0 end
		Glitchy.TestChamberResultGroup[g] = Glitchy.TestChamberResultGroup[g] + Glitchy.TestChamberResultGroup[g2]
	end
	return _GroupClone(g,g2)
end

Group.SelectSubGroup = function(g,tp,f,cancelable,min,max,...)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 then
		Auxiliary.SubGroupCaptured=Group.CreateGroup()
		local min=min or 1
		local max=max or #g
		local ext_params={...}
		local sg=Group.CreateGroup()
		local fg=Duel.GrabSelectedCard()
		if #fg>max or min>max or #(g+fg)<min then return nil end
		for tc in aux.Next(fg) do
			if type(Glitchy.TestChamberResultGroup[g])=="number" then
				Glitchy.TestChamberResultGroup[fg] = Glitchy.TestChamberResultGroup[g]
			end
			fg:SelectUnselect(sg,tp,false,false,min,max)
		end
		sg:Merge(fg)
		local finish=(#sg>=min and #sg<=max and f(sg,...))
		while #sg<max do
			local cg=Group.CreateGroup()
			local eg=g:Clone()
			for c in aux.Next(g-sg) do
				if not cg:IsContains(c) then
					if Auxiliary.CheckGroupRecursiveCapture(c,sg,eg,f,min,max,ext_params) then
						cg:Merge(Auxiliary.SubGroupCaptured)
					else
						eg:RemoveCard(c)
					end
				end
			end
			cg:Sub(sg)
			finish=(#sg>=min and #sg<=max and f(sg,...))
			if #cg==0 then break end
			local cancel=not finish and cancelable
			if type(Glitchy.TestChamberResultGroup[g])=="number" then
				Glitchy.TestChamberResultGroup[cg] = Glitchy.TestChamberResultGroup[g]
			end
			local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
			if not tc then break end
			if not fg:IsContains(tc) then
				if not sg:IsContains(tc) then
					sg:AddCard(tc)
					if #sg==max then finish=true end
				else
					sg:RemoveCard(tc)
				end
			elseif cancelable then
				return nil
			end
		end
		if finish then
			return sg
		else
			return nil
		end
	else
		return _SelectSubGroup(g,tp,f,cancelable,min,max,...)
	end
end

Group.SelectSubGroupEach = function(g,tp,checks,cancelable,f,...)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 then
		if cancelable==nil then cancelable=false end
		if f==nil then f=Auxiliary.TRUE end
		local ct=#checks
		local ext_params={...}
		local sg=Group.CreateGroup()
		local finish=false
		while #sg<ct do
			local cg=g:Filter(Auxiliary.CheckGroupRecursiveEach,sg,sg,g,f,checks,ext_params)
			if #cg==0 then break end
			if type(Glitchy.TestChamberResultGroup[g])=="number" then
				Glitchy.TestChamberResultGroup[cg] = Glitchy.TestChamberResultGroup[g]
			end
			local tc=cg:SelectUnselect(sg,tp,false,cancelable,ct,ct)
			if not tc then break end
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if #sg==ct then finish=true end
			else
				sg:Clear()
			end
		end
		if finish then
			return sg
		else
			return nil
		end
	
	else
		return _SelectSubGroupEach(g,tp,checks,cancelable,f,...)
	end
end

Group.SelectWithSumEqual = function(g,p,f,acc,min,max,...)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 and type(Glitchy.TestChamberResultGroup[g])=="number" then
		local result = Glitchy.TestChamberResultGroup[g]
		
		local player = p
		if p==self_reference_effect:GetHandlerPlayer() then
			if result&TEST_CHAMBER_TARGET>0 and Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER) then
				for _,ce in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER)}) do
					if ce and aux.GetValueType(ce)=="Effect" and ce.SetLabel then
						local val=ce:GetValue()
						if not val or val(ce,self_reference_effect,self_reference_tp) then
							player = 1-p
							break
						end
					end
				end
			
			elseif result&TEST_CHAMBER_TOHAND>0 and not Glitchy.UndefinedActionWarning and Duel.IsPlayerAffectedByEffect(p,EFFECT_UTTER_CONFUSION_CONFIDENCE) then
				if not g:IsExists(function(card,tp) return not card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or card:IsControler(1-tp) end,1,nil,p) then
					player = 1-p
				else
					local opt=Duel.SelectOption(p,aux.Stringid(33720071,0),aux.Stringid(33720071,1))
					if opt==0 then
						player = 1-p
						g = _GroupFilter(g,function(card,tp) return card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and card:IsControler(tp) end,nil,p)
					else
						g = _GroupFilter(g,function(card,tp) return not card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or card:IsControler(1-tp) end,nil,p)
					end
				end
			end
		end
		if Glitchy.UndefinedActionWarning then
			Glitchy.UndefinedActionWarning = false
		end
		
		return _SelectWithSumEqual(g,player,f,acc,min,max,...)
	
	else
		return _SelectWithSumEqual(g,p,f,acc,min,max,...)
	end
end

Group.SelectWithSumGreater = function(g,p,f,acc,...)
	if Duel.GetFlagEffect(p,GLITCHY_ENABLE_TEST_CHAMBER)>0 and type(Glitchy.TestChamberResultGroup[g])=="number" then
		local result = Glitchy.TestChamberResultGroup[g]
		
		local player = p
		if p==self_reference_effect:GetHandlerPlayer() then
			if result&TEST_CHAMBER_TARGET>0 and Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER) then
				for _,ce in ipairs({Duel.IsPlayerAffectedByEffect(p,EFFECT_GLITCHY_CHANGE_TARGETING_PLAYER)}) do
					if ce and aux.GetValueType(ce)=="Effect" and ce.SetLabel then
						local val=ce:GetValue()
						if not val or val(ce,self_reference_effect,self_reference_tp) then
							player = 1-p
							break
						end
					end
				end
			
			elseif result&TEST_CHAMBER_TOHAND>0 and not Glitchy.UndefinedActionWarning and Duel.IsPlayerAffectedByEffect(p,EFFECT_UTTER_CONFUSION_CONFIDENCE) then
				if not g:IsExists(function(card,tp) return not card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or card:IsControler(1-tp) end,1,nil,p) then
					player = 1-p
				else
					local opt=Duel.SelectOption(p,aux.Stringid(33720071,0),aux.Stringid(33720071,1))
					if opt==0 then
						player = 1-p
						g = _GroupFilter(g,function(card,tp) return card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and card:IsControler(tp) end,nil,p)
					else
						g = _GroupFilter(g,function(card,tp) return not card:IsLocation(LOCATION_DECK+LOCATION_GRAVE) or card:IsControler(1-tp) end,nil,p)
					end
				end
			end
		end
		if Glitchy.UndefinedActionWarning then
			Glitchy.UndefinedActionWarning = false
		end
		
		return _SelectWithSumGreater(g,player,f,acc,...)
	
	else
		return _SelectWithSumGreater(g,p,f,acc,...)
	end
end

--Glitchylib imports
function Auxiliary.Option(id,tp,desc,...)
	local list={...}
	local off=1
	local ops={}
	local opval={}
	local truect=1
	for ct,b in ipairs(list) do
		local check=b
		local localid=id
		local localdesc=desc+truect-1
		if aux.GetValueType(b)=="table" then
			check=b[1]
			localid=b[2]
			localdesc=b[3]
		else
			truect=truect+1
		end
		if check==true then
			ops[off]=aux.Stringid(localid,localdesc)
			opval[off]=ct-1
			off=off+1
		end
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	Duel.Hint(HINT_OPSELECTED,1-tp,ops[op])
	return sel
end

function Duel.Attach(c,xyz)
	if aux.GetValueType(c)=="Card" then
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(xyz,Group.FromCards(c))
		return xyz:GetOverlayGroup():IsContains(c)
			
	elseif aux.GetValueType(c)=="Group" then
		for tc in aux.Next(c) do
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
		end
		Duel.Overlay(xyz,c)
		return c:FilterCount(function (card,group) return group:IsContains(card) end, nil, xyz:GetOverlayGroup())
	end
end
function Duel.Negate(tc,e,reset,notfield,forced)
	if not reset then reset=0 end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
	tc:RegisterEffect(e1,forced)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	if not notfield then
		e2:SetValue(RESET_TURN_SET)
	end
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
	tc:RegisterEffect(e2,forced)
	if not notfield and tc:IsType(TYPE_TRAPMONSTER) then
		local e=Effect.CreateEffect(e:GetHandler())
		e:SetType(EFFECT_TYPE_SINGLE)
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e:SetReset(RESET_EVENT+RESETS_STANDARD+reset)
		tc:RegisterEffect(e,forced)
		return e1,e2,e
	end
	return e1,e2
end
function Duel.UpdateFlagEffectLabel(p,id,ct)
	if not ct then ct=1 end
	return Duel.SetFlagEffectLabel(p,id,Duel.GetFlagEffectLabel(p,id)+ct)
end

--Other Imports
function Card.HasLevel(c)
	if c:IsType(TYPE_MONSTER) then
		return (c:GetType()&TYPE_LINK~=TYPE_LINK and c:GetType()&TYPE_XYZ~=TYPE_XYZ) and not c:IsStatus(STATUS_NO_LEVEL)
	elseif c:IsOriginalType(TYPE_MONSTER) then
		return not (c:IsOriginalType(TYPE_XYZ+TYPE_LINK) or c:IsStatus(STATUS_NO_LEVEL))
	end
	return false
end
function Card.HasDefense(c)
	return not c:IsOriginalType(TYPE_LINK)
end

--EFFECT TABLES
--Global Card Effect Table
if not global_card_effect_table_global_check then
	global_card_effect_table_global_check=true
	global_card_effect_table={}
	Card.register_global_card_effect_table = Card.RegisterEffect
	function Card:RegisterEffect(e,forced)
		if not global_card_effect_table[self] then global_card_effect_table[self]={} end
		table.insert(global_card_effect_table[self],e)
		
		local condition,cost,tg,op,val=e:GetCondition(),e:GetCost(),e:GetTarget(),e:GetOperation(),e:GetValue()
		if condition and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0)) then	
			local newcon =	function(...)
								self_reference_effect=e
								local x={...}
								if type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								return condition(...)
							end
			e:SetCondition(newcon)
		end
		if cost and not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0) then
			local newcost =	function(...)
								self_reference_effect=e
								local x={...}
								if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								return cost(...)
							end
			e:SetCost(newcost)
		end
		if tg then
			if e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G then
				local newtg =	function(...)
									self_reference_effect=e
									local x={...}
									if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
										self_reference_tp = x[2]
									end
									return tg(...)
								end
				e:SetTarget(newtg)
			elseif not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0) then
				local newtg =	function(...)
									self_reference_effect=e
									local x={...}
									if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
										self_reference_tp = x[2]
									end
									return tg(...)
								end
				e:SetTarget(newtg)
			end
		end
		if op and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
			local newop =	function(...)
								self_reference_effect=e
								local x={...}
								if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
									self_reference_tp = x[2]
								end
								return op(...)
							end
			e:SetOperation(newop)
		end
		if val then
			if type(val)=="function" and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()==EFFECT_TYPE_XMATERIAL or e:GetType()==EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
				local newval =	function(...)
									self_reference_effect=e
									return val(...)
								end
				e:SetValue(newval)
				
			end
		end
		return self.register_global_card_effect_table(self,e,forced)
	end
end

--Global Card Effect Table (for Duel.RegisterEffect)
if not global_duel_effect_table_global_check then
	global_duel_effect_table_global_check=true
	global_duel_effect_table={}
	Duel.register_global_duel_effect_table = Duel.RegisterEffect
	Duel.RegisterEffect = function(e,tp)
							if not global_duel_effect_table[tp] then global_duel_effect_table[tp]={} end
							table.insert(global_duel_effect_table[tp],e)
							
							local condition,cost,tg,op,val=e:GetCondition(),e:GetCost(),e:GetTarget(),e:GetOperation(),e:GetValue()
							if condition and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
								local newcon =	function(...)
													self_reference_effect=e
													local x={...}
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													return condition(...)
												end
								e:SetCondition(newcon)
							end
							if cost and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
								local newcost =	function(...)
													self_reference_effect=e
													local x={...}
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													return cost(...)
												end
								e:SetCost(newcost)
							end
							if tg then
								if e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G then
									local newtg =	function(...)
														self_reference_effect=e
														local x={...}
														if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
															self_reference_tp = x[2]
														end
														return tg(...)
													end
									e:SetTarget(newtg)
								elseif not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0) then
									local newtg =	function(...)
														self_reference_effect=e
														local x={...}
														if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
															self_reference_tp = x[2]
														end
														return tg(...)
													end
									e:SetTarget(newtg)
								end
							end
							if op and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
								local newop =	function(...)
													self_reference_effect=e
													local x={...}
													if #x>1 and type(x[2])=="number" and (x[2]==0 or x[2]==1) then
														self_reference_tp = x[2]
													end
													return op(...)
												end
								e:SetOperation(newop)
							end
							if val then
								if type(val)=="function" and ((e:GetCode()==EFFECT_SPSUMMON_PROC or e:GetCode()==EFFECT_SPSUMMON_PROC_G) or not (e:GetType()==EFFECT_TYPE_FIELD or e:GetType()==EFFECT_TYPE_SINGLE or e:GetType()&EFFECT_TYPE_GRANT~=0)) then
									local newval =	function(...)
														self_reference_effect=e
														return val(...)
													end
									e:SetValue(newval)
								
								end
							end
							return Duel.register_global_duel_effect_table(e,tp)
	end
end