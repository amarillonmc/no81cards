tama=tama or {}

--[[To use this, have to add
xpcall(function() require("expansions/script/c" + "code") end,function() require("script/c" + "code") end) ]]
tama.loaded_metatable_list=tama.loaded_metatable_list or {}
function tama.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=tama.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			tama.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function tama.is_series(c,series,v,f,...) 
	local codet=nil
	if type(c)=="number" then
		codet={c}
	elseif type(c)=="table" then
		codet=c
	elseif type(c)=="userdata" then
		local f=f or Card.GetCode
		codet={f(c)}
	end
	local ncodet={...}
	for i,code in pairs(codet) do
		for i,ncode in pairs(ncodet) do
			if code==ncode then return true end
		end
		local mt=tama.LoadMetatable(code)
		if mt and mt["is_series_with_"..series] and (not v or mt["is_series_with_"..series]==v) then return true end
	end
	return false
end
function tama.DeepCopy( obj )   
	local InTable = {};
	local function Func(obj)
		if type(obj) ~= "table" then   --判断表中是否有表
			return obj;
		end
		local NewTable = {};  --定义一个新表
		InTable[obj] = NewTable;  --若表中有表，则先把表给InTable，再用NewTable去接收内嵌的表
		for k,v in pairs(obj) do  --把旧表的key和Value赋给新表
			NewTable[Func(k)] = Func(v);
		end
		return setmetatable(NewTable, getmetatable(obj))--赋值元表
	end
	return Func(obj) --若表中有表，则把内嵌的表也复制了
end
function tama.getTargetTable(c,str)
	local mt=tama.load_metatable(c:GetOriginalCode())
	if mt==nil or type(mt[c])~="table" then return nil end
	local eflist=mt[c]
	--[[
	local i=1
	while eflist[i] do
		if eflist[i]==str then
			i=i+1
			return eflist[i]
		end
		i=i+1
	end
	]]
	local i=1
	while eflist[i] do
		if type(eflist[i])=="table" and eflist[i][1]==str then
			return eflist[i][2]
		end
		i=i+1
	end
	return nil
end
function tama.cosmicFighters_optionFilter(c)
	return c:IsFaceup() and c:IsCode(93130022)
end
function tama.cosmicFighters_getOptions(c)
	local og=c:GetCardTarget()
	local g=og:Filter(tama.cosmicFighters_optionFilter,nil)
	return g
end
function tama.cosmicFighters_getFormation(c)
	local og=tama.cosmicFighters_getOptions(c)
	og:AddCard(c)
	return og
end
function tama.cosmicFighters_equipGetFormation(c)
	local ec=c:GetEquipTarget()
	if not ec then return nil end
	local f=tama.cosmicFighters_getFormation(ec)
	return f
end
function tama.cosmicFighters_isInFormation(c)
	local og=tama.cosmicFighters_getFormation(c)
	return og:IsContains(c)
end

--[[some of tamas have alchemical elements.If want to use, add
	local elements={elements code}
	eflist={"tama_elements",elements}
	c+code[c]=eflist
]]
TAMA_ELEMENT_WIND=13254031
TAMA_ELEMENT_EARTH=13254032
TAMA_ELEMENT_WATER=13254033
TAMA_ELEMENT_FIRE=13254034
TAMA_ELEMENT_ORDER=13254035
TAMA_ELEMENT_CHAOS=13254036
TAMA_ELEMENT_MANA=13254048
TAMA_ELEMENT_ENERGY=13254052
TAMA_ELEMENT_LIFE=13254054
--[[check card or elements table has element
]]
function tama.tamas_isExistElement(c,code)
	local elements=tama.tamas_getElements(c)
	local i=1
	if #elements~=0 then
		while elements[i] do
			if elements[i][1]==code then return true end
			i=i+1
		end
	end
	return false
end
--[[check card or elements table has a group of elements
]]
function tama.tamas_isExistElements(c,codes)
	local elements=tama.tamas_getElements(c)
	local i=1
	while codes[i] do
		if tama.tamas_isExistElement(elements,codes[i]) then return true end
		i=i+1
	end
	return false
end
--[[check card or elements table's count of element
]]
function tama.tamas_getElementCount(c,code)
	local elements=tama.tamas_getElements(c)
	local i=1
	local count=0
	if #elements~=0 then
		while elements[i] do
			if elements[i][1]==code then count=count+elements[i][2] end
			i=i+1
		end
	end
	return count
end
function tama.tamas_getElements(v)
	local codes={}
	if aux.GetValueType(v)=="Card" then
		local elements=tama.getTargetTable(v,"tama_elements")
		if elements~=nil then
			codes=elements
		end
	elseif type(v)=="table" then
		codes=v
	end
	return codes
end
function tama.tamas_decreaseElements(codes,reduce)
	local i=1
	local toReduce=tama.DeepCopy(codes)
	while toReduce[i] do
		local j=1
		while reduce[j] do
			if toReduce[i][1]==reduce[j][1] then
				toReduce[i][2]=toReduce[i][2]-reduce[j][2]
			end
			j=j+1
		end
		i=i+1
	end
	return toReduce
end
function tama.tamas_increaseElements(codes,add)
	local toAdd=tama.DeepCopy(codes)
	if #toAdd>0 then
		if not tama.tamas_checkContainElements(toAdd,add) then
			local i=1
			while add[i] do
				if not tama.tamas_isExistElement(toAdd,add[i][1]) then
					table.insert(toAdd,{add[i][1],0})
				end
				i=i+1
			end
		end
		local i=1
		while toAdd[i] do
			local j=1
			while add[j] do
				if toAdd[i][1]==add[j][1] then
					toAdd[i][2]=toAdd[i][2]+add[j][2]
				end
				j=j+1
			end
			i=i+1
		end
	else
		local i=1
		while add[i] do
			table.insert(toAdd,add[i])
			--toAdd[i]=add[i]
			i=i+1
		end
	end
	return toAdd
end
function tama.tamas_sumElements(group)
	local tc=group:GetFirst()
	local sum={}
	while tc do
		sum=tama.tamas_increaseElements(sum,tama.tamas_getElements(tc))
		tc=group:GetNext()
	end
	return sum
end
function tama.tamas_checkElementsForLess(codes,check)
	local i=1
	local less=false
	local banned=false
	while codes[i] do
		local j=1
		while check[j] do
			if codes[i][1]==check[j][1] and codes[i][2]>check[j][2] then
				banned=true
			elseif codes[i][1]==check[j][1] then
				less=true
			end
			j=j+1
		end
		i=i+1
	end
	return less and not banned
end
--[[if A={{A,2},{B,2}},B={{A,2}},return true
if A={{A,2},{B,2}},B={{A,2},{B,2}},return true
if A={{A,2},{B,2}},B={{A,2},{C,2}},return true
if A={{A,2},{B,2}},B={{C,2}},return false]]
function tama.tamas_checkElements(codes,check)
	local i=1
	local accept=false
	while codes[i] do
		local j=1
		while check[j] do
			if codes[i][1]==check[j][1] then
				accept=true
			end
			j=j+1
		end
		i=i+1
	end
	return accept
end
--[[if A={{A,2},{B,2}},B={{A,2}},return true
if A={{A,2},{B,2}},B={{A,2},{B,2}},return true
if A={{A,2},{B,2}},B={{A,2},{C,2}},return false
if A={{A,2},{B,2}},B={{C,2}},return false]]
function tama.tamas_checkContainElements(codes,check)
	local i=1
	local contain=false
	while check[i] do
		local j=1
		local accept=false
		while codes[j] do
			if check[i][1]==codes[j][1] then
				--codes has check element, current checking true
				accept=true
			end
			j=j+1
		end
		contain=accept
		if not contain then return contain end
		i=i+1
	end
	return contain
end
--some elements are equal or lower than 0
function tama.tamas_checkElementsEmpty(codes)
	local i=1
	local empty=true
	while codes[i] do
		if codes[i][2]>0 then
			empty=false
		end
		i=i+1
	end
	return empty
end
--some elements are lower than 0
function tama.tamas_checkElementsLowerEmpty(codes)
	local i=1
	local empty=true
	while codes[i] do
		if codes[i][2]>=0 then
			empty=false
		end
		i=i+1
	end
	return empty
end
function tama.tamas_checkGroupElementsForLess(g,codes)
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local elements=tama.tamas_getElements(tc)
		if tama.tamas_checkElementsForLess(elements,codes) then
			sg:AddCard(tc)
		end
		tc=g:GetNext()
	end
	return sg
end
function tama.tamas_checkGroupElements(g,codes)
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local elements=tama.tamas_getElements(tc)
		if tama.tamas_checkElements(elements,codes) then
			sg:AddCard(tc)
		end
		tc=g:GetNext()
	end
	return sg
end
--target:2A,2B,2C,storage:(A+B)*3,(A+C)*3,(B+C)*2,C*2,final:(A+B)+(A+C)+(B+C) or (A+B)*2+C*2
function tama.tamas_selectElementsForEqual(c,mg,sg,codes)
	local targetCodes=tama.DeepCopy(codes)
	sg:AddCard(c)
	local res=false
	local elements=tama.tamas_getElements(c)
	if tama.tamas_checkElementsForLess(elements,targetCodes) then
		local targetCodes1=tama.tamas_decreaseElements(targetCodes,elements)
		if tama.tamas_checkElementsEmpty(targetCodes1) then
			res=true
		else
			res=mg:IsExists(tama.tamas_selectElementsForEqual,1,sg,mg,sg,targetCodes1)
		end
	end
	sg:RemoveCard(c)
	return res
end
--target:2A,2B,storage:(A+B)*2,3A*1,3B*1,final:(A+B)*2 or 3A+3B
function tama.tamas_selectElementsForAbove(c,mg,sg,codes)
	local targetCodes=tama.DeepCopy(codes)
	sg:AddCard(c)
	local res=false
	local elements=tama.tamas_getElements(c)
	if tama.tamas_checkElements(elements,targetCodes) then
		local targetCodes1=tama.tamas_decreaseElements(targetCodes,elements)
		if tama.tamas_checkElementsEmpty(targetCodes1) then
			res=true
		else
			res=mg:IsExists(tama.tamas_selectElementsForAbove,1,sg,mg,sg,targetCodes1)
		end
	end
	sg:RemoveCard(c)
	return res
end
function tama.tamas_groupHasGroup(g1,g2)
	local has=true
	if g2:GetCount()==0 then return true end
	local tc=g2:GetFirst()
	while tc do
		if not g1:IsContains(tc) then
			has=false
			break
		end
		tc=g2:GetNext()
	end
	return has
end
function tama.tamas_groupHasGroupCard(g1,g2)
	local has=false
	if g2:GetCount()==0 then return false end
	local tc=g2:GetFirst()
	while tc do
		if g1:IsContains(tc) then
			has=true
			break
		end
		tc=g2:GetNext()
	end
	return has
end
--t{{group.elements}...}
function tama.tamas_addElementsGroupToTable(t,g,reduceElements)
	--reduce group size
	local i=1
	local added=false
	while t[i] do
		if tama.tamas_groupHasGroup(g,t[i][1]) then
			added=true
		end
		i=i+1
	end
	if not added then
		i=1
		while t[i] do
			if tama.tamas_groupHasGroup(t[i][1],g) then
				table.remove(t,i)
				i=i-1
			end
			i=i+1
		end
		local addUp=tama.DeepCopy(reduceElements)
		table.insert(t,{g:Clone(),addUp})
	end
end
function tama.tamas_elementsSelectFilterForEqual(c,mg,sg,codes,allSelect,selectedElements)
	local targetCodes=tama.DeepCopy(codes)
	local selectedElements1=tama.DeepCopy(selectedElements)
	if c~=nil then 
		sg:AddCard(c) 
		mg:RemoveCard(c) 
		local elements=tama.tamas_getElements(c)
		if tama.tamas_checkElementsForLess(elements,targetCodes) then
			local selectedElements2=tama.tamas_increaseElements(selectedElements1,elements)
			local targetCodes1=tama.tamas_decreaseElements(targetCodes,elements)
			if tama.tamas_checkElementsEmpty(targetCodes1) then
				tama.tamas_addElementsGroupToTable(allSelect,sg,selectedElements2)
			else
				local tc=mg:GetFirst()
				while tc do
					tama.tamas_elementsSelectFilterForEqual(tc,mg:Clone(),sg,targetCodes1,allSelect,selectedElements2)
					tc=mg:GetNext()
				end
			end
		end
	elseif mg:GetCount()>0 then
		local tc=mg:GetFirst()
		while tc do
			tama.tamas_elementsSelectFilterForEqual(tc,mg:Clone(),sg,targetCodes,allSelect,selectedElements1)
			tc=mg:GetNext()
		end
	end
	if c~=nil then sg:RemoveCard(c) end
	return #allSelect>0
end
function tama.tamas_getAllSelectForEqual(mg,codes)
	local targetCodes=tama.DeepCopy(codes)
	local allSelect={}
	local tc=mg:GetFirst()
	local sg=Group.CreateGroup()
	tama.tamas_elementsSelectFilterForEqual(nil,mg:Clone(),sg,codes,allSelect,{})
	return allSelect
end
function tama.tamas_selectAllSelectForEqual(mg,codes,tp)
	local allSelect=tama.tamas_getAllSelectForEqual(mg,codes)
	local sg=Group.CreateGroup()
	local elements={}
	while true do
		local i=1
		local sg1=Group.CreateGroup()
		while allSelect[i] and allSelect[i][1] do
			if tama.tamas_groupHasGroup(allSelect[i][1],sg) then
				sg1:Merge(allSelect[i][1])
			end
			i=i+1
		end
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=sg1:Select(tp,1,1,sg)
		if g:GetCount()>0 then
			sg:Merge(g)
		else 
			local j=1
			while allSelect[j] do
				if tama.tamas_groupHasGroup(allSelect[j][1],sg) then
					elements=allSelect[j][2]
				end
				j=j+1
			end break
		end
	end
	return sg,elements
end
function tama.tamas_elementsSelectFilterForAbove(c,mg,sg,codes,allSelect,selectedElements)
	local targetCodes=tama.DeepCopy(codes)
	local selectedElements1=tama.DeepCopy(selectedElements)
	if c~=nil then 
		--sg添加穷举到的卡
		sg:AddCard(c) 
		mg:RemoveCard(c) 
		local elements=tama.tamas_getElements(c)
		if tama.tamas_checkElements(elements,targetCodes) then
			local selectedElements2=tama.tamas_increaseElements(selectedElements1,elements)
			local targetCodes1=tama.tamas_decreaseElements(targetCodes,elements)
			if tama.tamas_checkElementsEmpty(targetCodes1) then
				tama.tamas_addElementsGroupToTable(allSelect,sg,selectedElements2)
			else
				local tc=mg:GetFirst()
				while tc do
					tama.tamas_elementsSelectFilterForAbove(tc,mg:Clone(),sg,targetCodes1,allSelect,selectedElements2)
					tc=mg:GetNext()
				end
			end
		end
	elseif mg:GetCount()>0 then
		local tc=mg:GetFirst()
		while tc do
			tama.tamas_elementsSelectFilterForAbove(tc,mg:Clone(),sg,targetCodes,allSelect,selectedElements1)
			tc=mg:GetNext()
		end
	end
	if c~=nil then sg:RemoveCard(c) end
	return #allSelect>0
end
function tama.tamas_getAllSelectForAbove(mg,codes)
	local targetCodes=tama.DeepCopy(codes)
	local allSelect={}
	local tc=mg:GetFirst()
	local sg=Group.CreateGroup()
	tama.tamas_elementsSelectFilterForAbove(nil,mg:Clone(),sg,codes,allSelect,{})
	return allSelect
end
function tama.tamas_selectAllSelectForAbove(mg,codes,tp)
	local allSelect=tama.tamas_getAllSelectForAbove(mg,codes)
	local sg=Group.CreateGroup()
	local elements={}
	while true do
		local i=1
		local sg1=Group.CreateGroup()
		while allSelect[i] and allSelect[i][1] do
			if tama.tamas_groupHasGroup(allSelect[i][1],sg) then
				sg1:Merge(allSelect[i][1])
			end
			i=i+1
		end
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=sg1:Select(tp,1,1,sg)
		if g:GetCount()>0 then
			sg:Merge(g)
		else 
			local j=1
			while allSelect[j] do
				if tama.tamas_groupHasGroup(allSelect[j][1],sg) then
					elements=allSelect[j][2]
				end
				j=j+1
			end break
		end
	end
	return sg,elements
end
--[[if elements A={{a,2}{b,2}}, B={{a,2}{b,2}}, A<=B
if elements A={{a,2}{b,2}}, B={{a,2}}, A>B
if elements A={{a,2}{b,2}}, B={{a,2}{b,1}}, A<=B
if elements A={{a,2}{b,2}}, B={{a,2}{c,2}}, A<=B
]]
function tama.tamas_checkElementsGreater(codes,targetCodes)
	local greater=false
	local elements=tama.DeepCopy(codes)
	elements=tama.tamas_decreaseElements(elements,targetCodes)
	if tama.tamas_checkContainElements(elements,targetCodes) and not tama.tamas_checkElementsLowerEmpty(elements) then
		greater=true
	end
	return greater
end
function tama.tamas_checkCardElementsGreater(card,targetCard)
	local codes=tama.tamas_getElements(card)
	local targetCodes=tama.tamas_getElements(targetCard)
	return tama.tamas_checkElementsGreater(codes,targetCodes)
end

COSMIC_BATTLESHIP_SHIELD=0x353
COSMIC_BATTLESHIP_CHARGE=0x354
function tama.cosmicBattleship_equipShield(targetCard,count)
	if not targetCard:IsFaceup() or not targetCard:IsOnField() then return end
	if not targetCard:IsDisabled() and not targetCard:IsCanAddCounter(COSMIC_BATTLESHIP_SHIELD,count) then
		targetCard:EnableCounterPermit(COSMIC_BATTLESHIP_SHIELD)
		--Destroy replace
		local e1=Effect.CreateEffect(targetCard)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT+REASON_BATTLE)
					and e:GetHandler():GetCounter(COSMIC_BATTLESHIP_SHIELD)>0 end
				return true
			end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				c:RemoveCounter(ep,COSMIC_BATTLESHIP_SHIELD,1,REASON_EFFECT)
				Duel.RaiseEvent(c,EVENT_REMOVE_COUNTER+COSMIC_BATTLESHIP_SHIELD,e,REASON_EFFECT+REASON_REPLACE,tp,tp,1)
			end)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		targetCard:RegisterEffect(e1,true)
	end
	if targetCard:IsCanAddCounter(COSMIC_BATTLESHIP_SHIELD,count) then
		targetCard:AddCounter(COSMIC_BATTLESHIP_SHIELD,count)
	end
end
