--幻叙记录者 克劳
local s,id,o=GetID()
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.initial_effect(c)
	--activate
	aux.EnablePendulumAttribute(c)
	local tp=0 
	if Duel.GetFieldGroupCount(0,0,LOCATION_DECK)>0 or Duel.GetFieldGroupCount(0,LOCATION_EXTRA,0)>0 then tp=1 end
	if not KRO_COPY then
		KRO_COPY=true
		s.IsSetCard=Card.IsSetCard
		s.IsLinkSetCard=Card.IsLinkSetCard
		s.IsFusionSetCard=Card.IsFusionSetCard
		s.IsPreviousSetCard=Card.IsPreviousSetCard
		s.IsOriginalSetCard=Card.IsOriginalSetCard
		s.RegisterEffect=Card.RegisterEffect
		KRO_COPY={}
		KRO_COPIED={}
		for p=0,1 do
			KRO_COPY[p]={}
			local pname=s.getplayername(p)
			local str=Duel.GetRegistryValue(pname)
			if str then
				KRO_COPIED[p]=s.stringToTable(str)
			else
				KRO_COPIED[p]={}
				--KRO_COPIED[p]={{code=55144522,id={1}}}
			end
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,1)
		e1:SetCondition(s.costcon)
		e1:SetTarget(s.actarget)
		e1:SetOperation(s.costop)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PREDRAW)
		e2:SetCountLimit(1)
		e2:SetOperation(s.cpop)
		Duel.RegisterEffect(e2,0)
	end
	for _,cdata in pairs(KRO_COPIED[1-tp]) do
		s.geteffect(cdata,c)
	end
end
function s.getplayername(tp)
	local p0=Duel.GetRegistryValue("player_name_0")
	local p1=Duel.GetRegistryValue("player_name_1")
	if p0==p1 then
		p1=p1.."_2"
		Duel.SetRegistryValue("player_name_1",p1)
	end
	local pname="Kro_Effect_"
	if tp==0 then
	--if tonumber(Duel.GetRegistryValue("player_type_0"))==tp then			
		pname=pname..p0
	else
		pname=pname..p1
	end
	return pname
end
function s.costcon(e)
	s[0]=false
	return true
end
function s.actarget(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)	
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	if s[0] or te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then return end
	s[0]=true
	local effects={tc:GetCardRegistered(nil,GETEFFECT_INITIAL)}
	local bool=false
	for _,ce in ipairs(effects) do
		if s.issameeffect(te,ce) then
			bool=true
			break
		end
	end
	if bool and not KRO_COPY[tp][te] then
		table.insert(KRO_COPY[tp],te)
	end
end
function s.cfilter(c,cid,tp)
	return c:GetOriginalCode()==cid and c:IsControler(1-tp)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for p=0,1 do
		if #KRO_COPY[p]>0 then
			local key=Duel.GetRandomNumber(1,#KRO_COPY[p])
			local te=KRO_COPY[p][key]
			local cdata=s.findeffect(te)
			s.addData(KRO_COPIED[p],cdata)

			local code=te:GetHandler():GetCode()
			Duel.Hint(HINT_CARD,0,id)
			Duel.Hint(HINT_CODE,0,code)
			Duel.Hint(HINT_CODE,1,code)
			local desc=s.getdesc(te)
			Duel.Hint(HINT_OPSELECTED,0,desc)
			Duel.Hint(HINT_OPSELECTED,1,desc)
			local str=s.tableToString(KRO_COPIED[p])
			Duel.SetRegistryValue(s.getplayername(p),str)

			local str=Duel.GetRegistryValue(s.getplayername(p))
			if str then
				KRO_COPIED[p]=s.stringToTable(str)
			end

			local g=Duel.GetFieldGroup(0,0x7f,0x7f)
			local xg=Duel.GetOverlayGroup(0,0x7f,0x7f)
			g:Merge(xg)
			g=g:Filter(s.cfilter,nil,id,p)
			for tc in aux.Next(g) do
				s.geteffect(cdata,tc)
			end
			KRO_COPY[p]={}
		end
	end
end
function s.issameeffect(e1,e2)
	local tg=e1:GetTarget()
	local op=e1:GetOperation()
	local code1=e1:GetCode()
	local code2=e2:GetCode()
	return tg==e2:GetTarget() and (op==nil or op==e2:GetOperation()) and (code1==code2 or code and code2 and code1*code2==EVENT_SPSUMMON_SUCCESS*EVENT_SUMMON_SUCCESS)
end
function s.addData(ctable,cdata)
	local code=cdata.code
	local found=false
	for _,item in ipairs(ctable) do
		if item.code==code then
			found=true
			local id=cdata.id
			for i in pairs(id) do
				table.insert(item.id,i)
			end
			break
		end
	end
	if not found then
		table.insert(ctable,cdata)
	end
end
function s.geteffect(cdata,c)
	effects={}
	function Card.RegisterEffect(cc,ce,...)
		table.insert(effects,ce) 
	end
	Duel.DisableActionCheck(true)
	local token=Duel.CreateToken(0,cdata.code)
	Duel.DisableActionCheck(false)
	Card.RegisterEffect=s.RegisterEffect

	for i,effect in ipairs(effects) do
		for _,cid in ipairs(cdata.id) do
			if i==cid then
				s.setcheffect(c,effect,cdata.code)
			end
		end
	end
end
function s.findeffect(e)
	local c=e:GetHandler()
	local ccode=c:GetOriginalCode()
	local tg=e:GetTarget()
	local op=e:GetOperation()
	effects={}
	function Card.RegisterEffect(cc,ce,...)
		table.insert(effects,ce) 
	end
	local token=Duel.CreateToken(0,ccode)
	Card.RegisterEffect=s.RegisterEffect

	local cdata={}
	for i,effect in ipairs(effects) do
		if s.issameeffect(e,effect) then
			if #cdata==0 then
				cdata={code=ccode,id={i}}
			else
				table.insert(cdata.id,i)
			end
		end
	end
	return cdata
end
function s.tableToString(table)
	if #table==0 then
		return ""
	end
	local string=""
	for i,cdata in ipairs(table) do
		if i>1 then string=string.."|" end
		local idStr=tostring(cdata.code)..":"
		for j,cid in ipairs(cdata.id) do
			if j>1 then idStr=idStr.."," end
			idStr=idStr..tostring(cid)
		end
		string=string..idStr
	end
	return string
end
function s.stringToTable(str)
	local dataTable = {}
	for recordStr in str:gmatch("[^|]+") do
		if recordStr and recordStr ~= "" then
			local codePart, idPart = recordStr:match("^(%d+):(.*)$")			
			if codePart and idPart then
				local code = tonumber(codePart)
				local ids = {}
				if idPart and idPart ~= "" then
					for idStr in idPart:gmatch("[^,]+") do
						local idNum = tonumber(idStr)
						if idNum then
							table.insert(ids, idNum)
						end
					end
				end
				table.insert(dataTable, {
					code = code,
					id = ids
				})
			end
		end
	end 
	return dataTable
end
function s.decomposeHexValueUnique(v)
	if v<=0xfff then
		return {v}
	end
	local results={}
	local low12bits=v& 0xfff
	local high4bits=v>>12
	local seen={}
	if not seen[v] then
		seen[v]=true
		table.insert(results,v)
	end
	if not seen[low12bits] then
		seen[low12bits]=true
		table.insert(results,low12bits)
	end
	for i=0,high4bits-1 do
		local newVal=(i<<12)|low12bits
		if not seen[newVal] then
			seen[newVal]=true
			table.insert(results,newVal)
		end
	end
	table.sort(results)
	return results
end
function s.hasCommonElements(arr1,arr2)
	if not arr1 or not arr2 or #arr1==0 or #arr2==0 then
		return false
	end
	local set={}
	for _,v in ipairs(arr1) do
		set[v]=true
		if v>0xfff then
			local decomposed = s.decomposeHexValueUnique(v)
			for _, val in ipairs(decomposed) do
				set[val] = true
			end
		else
			set[v]=true
		end
	end
	for _,v in ipairs(arr2) do
		if set[v] then
			return true
		end
	end
	return false
end
function s.chfunction(code)
	local table={Duel.ReadCard(code,CARDDATA_SETCODE)}
	Card.IsSetCard=function (c,...)
		if s.IsSetCard(c,0x838) and s.hasCommonElements(table,{...}) then return true end
		return s.IsSetCard(c,...)
	end
	Card.IsLinkSetCard=function (c,...)
		if s.IsLinkSetCard(c,0x838) and s.hasCommonElements(table,{...}) then return true end
		return s.IsLinkSetCard(c,...)
	end
	Card.IsFusionSetCard=function (c,...)
		if s.IsFusionSetCard(c,0x838) and s.hasCommonElements(table,{...}) then return true end
		return s.IsFusionSetCard(c,...)
	end
	Card.IsPreviousSetCard=function (c,...)
		if s.IsPreviousSetCard(c,0x838) and s.hasCommonElements(table,{...}) then return true end
		return s.IsPreviousSetCard(c,...)
	end
	Card.IsOriginalSetCard=function (c,...)
		if s.IsOriginalSetCard(c,0x838) and s.hasCommonElements(table,{...}) then return true end
		return s.IsOriginalSetCard(c,...)
	end
end
function s.unchfunction()
	Card.IsSetCard=s.IsSetCard
	Card.IsLinkSetCard=s.IsLinkSetCard
	Card.IsFusionSetCard=s.IsFusionSetCard
	Card.IsPreviousSetCard=s.IsPreviousSetCard
	Card.IsOriginalSetCard=s.IsOriginalSetCard
end
function s.chcon(ce,code)
	local con=ce:GetCondition()
	if not con then con=aux.TRUE end
	return function (e,tp,eg,ep,ev,re,r,rp)
		s.chfunction(code)
		local res=con(e,tp,eg,ep,ev,re,r,rp)		
		s.unchfunction()
		return res
	end
end
function s.chcost(ce,code)
	local cost=ce:GetCost()
	if not cost then cost=aux.TRUE end
	return function (e,tp,eg,ep,ev,re,r,rp,chk)
		s.chfunction(code)
		if chk==0 then
			local res=cost(e,tp,eg,ep,ev,re,r,rp,chk)
			s.unchfunction()
			return res
		else
			Duel.Hint(HINT_CARD,0,code)
			cost(e,tp,eg,ep,ev,re,r,rp,chk)
			s.unchfunction()
			e:Reset()
		end
	end
end
function s.chtg(ce,code)
	local tg=ce:GetTarget()
	if not tg then tg=aux.TRUE end
	return function (e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		s.chfunction(code)
		if chk==0 then		  
			local res=tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			s.unchfunction()
			return res
		else
			Duel.Hint(HINT_OPSELECTED,0,desc)
			Duel.Hint(HINT_OPSELECTED,1,desc)
			tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
			s.unchfunction()
		end
	end
end
function s.chop(ce,code)
	local op=ce:GetOperation()
	if not op then op=aux.TRUE end
	return function (e,tp,eg,ep,ev,re,r,rp)
		s.chfunction(code)
		op(e,tp,eg,ep,ev,re,r,rp)
		s.unchfunction()
	end
end
function s.getdesc(ce)
	local desc=ce:GetDescription()
	local cate=ce:GetCategory()
	if desc~=0 then
		Duel.Hint(HINT_OPSELECTED,0,desc)
		Duel.Hint(HINT_OPSELECTED,1,desc)
	end
	if cate&CATEGORY_DAMAGE>0 then desc=1122
	elseif cate&CATEGORY_RECOVER>0 then desc=1123
	elseif cate&CATEGORY_REMOVE>0 then desc=1192
	elseif cate&CATEGORY_NEGATE>0 then desc=aux.Stringid(id,2)
	elseif cate&CATEGORY_DISABLE>0 then desc=1131
	elseif cate&CATEGORY_DRAW>0 then desc=1108
	elseif cate&CATEGORY_SPECIAL_SUMMON>0 then desc=1152
	elseif cate&CATEGORY_TODECK>0 then desc=1193
	elseif cate&CATEGORY_SEARCH>0 then desc=1109
	elseif cate&CATEGORY_TOGRAVE>0 then desc=1191
	else desc=aux.Stringid(id,1)
	end
	return desc
end
function s.setcheffect(c,te,code)
	local ce=te:Clone()
	local desc=s.getdesc(ce)
	ce:SetDescription(desc)
	local ctype=ce:GetType()
	if ctype&EFFECT_TYPE_TRIGGER_F>0 then ce:SetType(ctype-EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O) end
	if ctype&EFFECT_TYPE_QUICK_F>0 then ce:SetType(ctype-EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O) end
	ce:SetProperty(ce:GetProperty()|EFFECT_FLAG_UNCOPYABLE)
	ce:SetCondition(s.chcon(te,code))
	ce:SetCost(s.chcost(te,code))
	ce:SetTarget(s.chtg(te,code))
	ce:SetOperation(s.chop(te,code))
	c:RegisterEffect(ce,true)
end