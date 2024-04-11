local m=53799261
local cm=_G["c"..m]
cm.name="天地翻转"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>0 end
	local fdzone=0
	for i=0,4 do
		if not Duel.GetFieldCard(tp,LOCATION_MZONE,i) then fdzone=fdzone|1<<i end
		if not Duel.GetFieldCard(tp,LOCATION_SZONE,i) then fdzone=fdzone|1<<(i+8) end
		if not Duel.GetFieldCard(1-tp,LOCATION_MZONE,i) then fdzone=fdzone|1<<(i+16) end
		if not Duel.GetFieldCard(1-tp,LOCATION_SZONE,i) then fdzone=fdzone|1<<(i+24) end
	end
	local exzone=0x60
	for i=5,6 do
		if Duel.GetFieldCard(tp,LOCATION_MZONE,i) then exzone=(1<<i)~exzone end
		if Duel.GetFieldCard(1-tp,LOCATION_MZONE,i) then exzone=(1<<(11-i))~exzone end
	end
	fdzone=fdzone|exzone
	fdzone=fdzone|0x2000
	fdzone=fdzone|0x20000000
	local g=Duel.GetMatchingGroup(function(c)return c:GetSequence()>4 end,tp,0,LOCATION_MZONE,nil)
	local z=0
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local b1,b2=0,0
		for tc in aux.Next(g) do
			if tc:GetSequence()==5 then b2=1 end
			if tc:GetSequence()==6 then b1=1 end
		end
		local op=0
		if b1>0 and b2>0 then op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3)) elseif b1>0 then op=Duel.SelectOption(tp,aux.Stringid(m,2)) else op=Duel.SelectOption(tp,aux.Stringid(m,3))+1 end
		if op==0 then z=0x20 else z=0x40 end
		e:SetLabel(z)
		Duel.Hint(HINT_ZONE,tp,z)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		z=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,fdzone)
		e:SetLabel(z)
		Duel.Hint(HINT_ZONE,tp,z)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local sdg=Group.FromCards(cm.gettc(tp,z))
		sdg:KeepAlive()
		cm[0]=sdg
		cm[1]=tp
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	local c=cm[0]:GetFirst()
	return not Duel.GetMatchingGroup(cm.tgfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,cm[1],1100,100,0,1000):IsContains(e:GetHandler())
end
function cm.xylabel(c,tp)
	local x,y=c:GetSequence(),0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_PZONE) then y=0
		elseif c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		else x,y=-1,-5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_PZONE) then x,y=4-x,4
		elseif c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		else x,y=5,9 end
	end
	return x,y
end
function cm.gradient(y,x)
	if y>0 and x==0 then return 1000 end
	if y<0 and x==0 then return 1100 end
	if y>0 and x~=0 then return y/x end
	if y<0 and x~=0 then return y/x+100 end
	if y==0 and x>0 then return 0 end
	if y==0 and x<0 then return 100 end
	return 65536
end
function cm.tgfilter1(tc,c,tp,...)
	local x1,y1=cm.xylabel(c,tp)
	local x2,y2=cm.xylabel(tc,tp)
	for _,k in ipairs({...}) do if cm.gradient(y2-y1,x2-x1)==k then return true end end
	return false
end
function cm.tgfilter2(g,tp)
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local fid=tc:GetFieldID()
		tc:RegisterFlagEffect(m+500,RESET_CHAIN,0,1,fid)
		local lg=Duel.GetMatchingGroup(cm.tgfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tc,tp,101,99,-1,1)
		for sc in aux.Next(lg) do
			sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,fid)
			sg:AddCard(sc)
		end
	end
	return sg
end
function cm.tgfilter3(c,g)
	for tc in aux.Next(g) do
		local fid=tc:GetFlagEffectLabel(m+500)
		if fid~=nil and c:GetFlagEffectLabel(m)==fid then return true end
	end
	return false
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local z=e:GetLabel()
	local tc=cm.gettc(tp,z)
	if not tc then return end
	local lg=cm.tgfilter2(Group.FromCards(tc),tp)
	Duel.HintSelection(Group.FromCards(tc))
	local ac,og=cm.posac(Group.FromCards(tc),e,tp)
	if ac==0 then return end
	local sg=lg:Filter(cm.tgfilter3,nil,og)
	while sg:GetCount()>0 do
		Duel.BreakEffect()
		lg=cm.tgfilter2(sg,tp)
		Duel.HintSelection(sg)
		local ac,og=cm.posac(sg,e,tp)
		if ac==0 then return end
		sg=lg:Filter(cm.tgfilter3,nil,og)
	end
end
function cm.posac(g,e,tp)
	local ac,og=0,Group.CreateGroup()
	for tc in aux.Next(g) do
		if tc:IsFaceup() and tc:IsCanTurnSet() and not tc:IsLocation(LOCATION_PZONE) then
			if tc:IsLocation(LOCATION_MZONE) then
				Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
				local pos1=Duel.GetOperatedGroup():GetCount()
				ac=ac+pos1
			else
				Duel.ChangePosition(tc,POS_FACEDOWN)
				local pos2=Duel.GetOperatedGroup():GetCount()
				Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
				ac=ac+pos2
			end
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
			local tg=Duel.GetOperatedGroup():GetCount()
			ac=ac+tg
		end
		if ac>0 then og:AddCard(tc) end
	end
	return ac,og
end
function cm.gettc(tp,z)
	local tc=nil
	if z&0x60==0 then
		local seq=math.log(z,2)
		if seq<5 then tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq) end
		if seq>7 and seq<13 then tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq-8) end
		if seq>15 and seq<21 then tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq-16) end
		if seq>23 and seq<29 then tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,seq-24) end
	else
		if z&0x20==0x20 then
			if Duel.GetFieldCard(tp,LOCATION_MZONE,5) then tc=Duel.GetFieldCard(tp,LOCATION_MZONE,5) end
			if Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) then tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
		elseif z&0x40==0x40 then
			if Duel.GetFieldCard(tp,LOCATION_MZONE,6) then tc=Duel.GetFieldCard(tp,LOCATION_MZONE,6) end
			if Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) then tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
		end
	end
	return tc
end
