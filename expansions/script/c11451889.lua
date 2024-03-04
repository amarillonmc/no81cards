--弦月斩
local cm,m=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then y=0
		else x,y=-1,0.5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		elseif c:IsLocation(LOCATION_SZONE) and x<=4 then x,y=4-x,4
		else x,y=5,3.5 end
	end
	return x,y
end
function cm.gradient(y,x)
	if y>0 and x==0 then return math.pi/2 end
	if y<0 and x==0 then return math.pi*3/2 end
	if y>=0 and x>0 then return math.atan(y/x) end
	if x<0 then return math.pi+math.atan(y/x) end
	if y<0 and x>0 then return 2*math.pi+math.atan(y/x) end
	return 1000
end
function cm.xytozone(x,y)
	if x==5 and y==0.5 then return 1<<13
	elseif x==-1 and y==3.5 then return 1<<29
	elseif x>=0 and x<=4 then
		if y==0 then return 1<<(x+8)
		elseif y==1 then return 1<<x
		elseif y==3 then return 1<<(20-x)
		elseif y==4 then return 1<<(28-x)
		elseif y==2 and x==1 then return 0x400020
		elseif y==2 and x==3 then return 0x200040 end
	end
	return nil
end
function cm.zonetoxy(fd)
	if fd==0x400020 then return 1,2 end
	if fd==0x200040 then return 3,2 end
	local seq=math.log(fd,2)
	if seq>=0 and seq<5 then return seq,1
	elseif seq>=8 and seq<13 then return seq-8,0
	elseif seq>=16 and seq<21 then return 20-seq,3
	elseif seq>=24 and seq<29 then return 28-seq,4
	elseif seq==5 or seq==22 then return 1,2
	elseif seq==6 or seq==21 then return 3,2
	elseif seq==13 then return -1,0.5
	elseif seq==29 then return 5,3.5
	elseif seq>=32 then return seq-32,2 end
	return nil
end
function cm.distance2(ac,bc,tp)
	local ax,ay=cm.xylabel(ac,tp)
	local bx,by=cm.xylabel(bc,tp)
	return ((by-ay)*(by-ay)+(ax-bx)*(ax-bx))*1000
end
function cm.distozone2(c,i,j,tp)
	local x,y=cm.xylabel(c,tp)
	return math.sqrt((y-j)*(y-j)+(x-i)*(x-i))*1000
end
function cm.filter(c,g,i1,j1,i2,j2,tp)
	return g:IsExists(cm.filter2,1,c,c,i1,j1,i2,j2,tp)
end
function cm.filter2(c,tc,i1,j1,i2,j2,tp)
	return cm.distozone2(c,i1,j1,tp)+cm.distozone2(c,i2,j2,tp)==cm.distozone2(tc,i1,j1,tp)+cm.distozone2(tc,i2,j2,tp)
end
function cm.filter3(c,tc,i1,j1,i2,j2,tp)
	return cm.distozone2(c,i1,j1,tp)+cm.distozone2(c,i2,j2,tp)>=cm.distozone2(tc,i1,j1,tp)+cm.distozone2(tc,i2,j2,tp)
end
function cm.dis2(c,i1,j1,i2,j2,tp)
	return cm.distozone2(c,i1,j1,tp)+cm.distozone2(c,i2,j2,tp)
end
function cm.fselect(g,i1,j1,i2,j2,tp)
	return g:GetClassCount(cm.dis2,i1,j1,i2,j2,tp)==1
end
function cm.nfilter(c,x,y,tp)
	local x0,y0=cm.xylabel(c,tp)
	return x~=x0 or y~=y0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then
		local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,e)
		if #g==0 then return false end
		for i1=0,4 do
			for j1=0,4 do
				for i2=0,4 do
					for j2=0,4 do
						if g:IsExists(cm.filter,1,nil,g,i1,j1,i2,j2,tp) then return true end
					end
				end
			end
		end
		return false
	end
	local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,e)
	local zone=0
	local off=1
	local ops,opval={},{}
	for i1=0,4 do
		for j1=0,4 do
			for i2=0,4 do
				for j2=0,4 do
					if g:IsExists(cm.filter,1,nil,g,i1,j1,i2,j2,tp) then
						--Debug.Message(i1..j1..i2..j2)
						local res=cm.xytozone(i1,j1)
						if j1~=2 then
							zone=zone|res
						else
							ops[off]=aux.Stringid(m,i1+1)
							opval[off]=i1
							off=off+1
						end
						goto cancel
					end
				end
			end
			::cancel::
		end
	end
	local fd=0
	if zone>0 and (off==1 or not Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		fd=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,~zone)
		Duel.Hint(HINT_ZONE,tp,fd)
		local fdx=fd
		if fd>=1<<16 then fdx=fd>>16 else fdx=fd<<16 end
		Duel.Hint(HINT_ZONE,1-tp,fdx)
	elseif off>1 then
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		fd=1<<(sel+32)
	end
	local i1,j1=cm.zonetoxy(fd)
	zone=0
	off=1
	ops,opval={},{}
	for i2=0,4 do
		for j2=0,4 do
			if g:IsExists(cm.filter,1,nil,g,i1,j1,i2,j2,tp) then
				--Debug.Message(i2..j2)
				local res=cm.xytozone(i2,j2)
				if j2~=2 then
					zone=zone|res
				else
					ops[off]=aux.Stringid(m,i2+1)
					opval[off]=i2
					off=off+1
				end
			end
		end
	end
	local fd2=0
	if zone>0 and (off==1 or not Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		fd2=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,~zone)
		Duel.Hint(HINT_ZONE,tp,fd2)
		local fdx2=fd2
		if fd2>=1<<16 then fdx2=fd2>>16 else fdx2=fd2<<16 end
		Duel.Hint(HINT_ZONE,1-tp,fdx2)
	elseif off>1 then
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		fd2=1<<(sel+32)
	end
	local i2,j2=cm.zonetoxy(fd2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	--[[local tc=g:FilterSelect(tp,cm.filter,1,1,nil,g,i1,j1,i2,j2,tp):GetFirst()
	local g2=g:Filter(cm.filter2,tc,tc,i1,j1,i2,j2,tp)
	local sg=g2:Select(tp,1,#g2,nil)
	sg:AddCard(tc)--]]
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,#g,i1,j1,i2,j2,tp)
	Duel.SetTargetCard(sg)
	--Debug.Message(i1..j1..i2..j2)
	--Debug.Message(cm.distozone2(tc,i1,j1,tp)+cm.distozone2(tc,i2,j2,tp))
	--Debug.Message(cm.distozone2(tc2,i1,j1,tp)+cm.distozone2(tc2,i2,j2,tp))
	--Duel.HintSelection(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	if #sg>2 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local tg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,sg:GetFirst(),i1,j1,i2,j2,tp)
		tg:KeepAlive()
		Duel.SetChainLimit(cm.limit(tg))
	end
end
function cm.limit(g)
	return function(e,lp,tp)
				return not g:IsContains(e:GetHandler())
			end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end