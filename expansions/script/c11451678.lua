--精灵弓之镞
local m=11451678
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
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
function cm.filter(c,g,i,j,tp)
	return g:IsExists(cm.filter2,1,nil,c,i,j,tp)
end
function cm.filter2(c,tc,i,j,tp)
	local x1,y1=cm.xylabel(tc,tp)
	local x2,y2=cm.xylabel(c,tp)
	return cm.gradient(y2-y1,x2-x1)==cm.gradient(y2-j,x2-i)
end
function cm.filter3(tc,c,i,j,tp)
	local x1,y1=cm.xylabel(tc,tp)
	local x2,y2=cm.xylabel(c,tp)
	return cm.gradient(y2-y1,x2-x1)==cm.gradient(y2-j,x2-i)
end
function cm.nfilter(c,x,y,tp)
	local x0,y0=cm.xylabel(c,tp)
	return x~=x0 or y~=y0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if #g1==0 or #g2==0 then return false end
		for i=0,4 do
			for j=0,4 do
				if g2:IsExists(cm.filter,1,nil,g1,i,j,tp) then return true end
			end
		end
		return false
	end
	local g1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local zone=0
	local off=1
	local ops,opval={},{}
	for i=0,4 do
		for j=0,4 do
			if g2:IsExists(cm.filter,1,nil,g1,i,j,tp) then
				local res=cm.xytozone(i,j)
				if j~=2 then
					zone=zone|res
				else
					ops[off]=aux.Stringid(m,i+1)
					opval[off]=i
					off=off+1
				end
			end
		end
	end
	local fd=0
	if zone>0 and (off==1 or not Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		fd=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,~zone)
	elseif off>1 then
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		fd=1<<(sel+32)
	end
	local x,y=cm.zonetoxy(fd)
	e:SetLabel(x,y)
	local tg=g2:Filter(cm.filter,nil,g1,x,y,tp)
	Duel.HintSelection(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tg,#tg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
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
	local x,y=e:GetLabel()
	local fd2=cm.xytozone(x,y)
	local g1=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_ONFIELD,0,nil,x,y,tp)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if #g1==0 or #g2==0 then return end
	local tg=g2:Filter(cm.filter,nil,g1,x,y,tp)
	if #tg>0 then
		local sg=Group.CreateGroup()
		local dam=0
		if Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
			for i=1,#g1 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
				local ag=g1:Select(tp,1,1,nil)
				Duel.HintSelection(ag)
				if fd2 then Duel.Hint(HINT_ZONE,tp,fd2) end
				g1:Sub(ag)
				local ac=ag:GetFirst()
				local x1,y1=cm.xylabel(ac,tp)
				local res=x1+(x-x1)/(y-y1)*(4.5-y1)
				local mg=g2:Filter(cm.filter3,nil,ac,x,y,tp)
				if #mg>0 then
					Duel.HintSelection(mg)
					g2:Sub(mg)
					sg:Merge(mg)
				elseif y1<y and res>=-0.5 and res<=4.5 then
					dam=dam+500
				end
			end
		else
			for i=1,#g1 do
				local ag=g1:RandomSelect(tp,1)
				Duel.HintSelection(ag)
				if fd2 then Duel.Hint(HINT_ZONE,tp,fd2) end
				g1:Sub(ag)
				local ac=ag:GetFirst()
				local x1,y1=cm.xylabel(ac,tp)
				local res=x1+(x-x1)/(y-y1)*(4.5-y1)
				local mg=g2:Filter(cm.filter3,nil,ac,x,y,tp)
				if #mg>0 then
					Duel.HintSelection(mg)
					g2:Sub(mg)
					sg:Merge(mg)
				elseif y1<y and res>=-0.5 and res<=4.5 then
					dam=dam+500
				end
			end
		end
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end