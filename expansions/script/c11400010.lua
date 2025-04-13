--自问自答
local cm,m=GetID()
function cm.initial_effect(c) end
if pnfl then return end
pnfl=cm

--子集判断、选取函数优化版.11451549.
--采用顺序迭代的深度搜索，等效于逐层剪枝递归而不是原版代码的第一层剪枝
--通过分类、排序、跳过三个人工辅助函数提升效率.注意，分类函数要保证同类卡选取时【完全等效】
--满足条件的组之间有包含关系时（如等级合计是5的倍数）goalstop取false.check取true则等价于CheckSubGroup
function cm.SelectSubGroup(g,tp,f,cancelable,min,max,...)
	--classif: function to classify cards, e.g. function(c,tc) return c:GetLevel()==tc:GetLevel() end
	--sortif: function of subgroup search order, high to low. e.g. Card.GetLevel
	--passf: cards that do not require check, e.g. function(c) return c:IsLevel(1) end
	--goalstop: do you want to backtrack after reaching the goal? true/false
	--check: do you want to return true after reaching the goal firstly? true/false
	local classif,sortf,passf,goalstop,check=table.unpack(cm.SubGroupParams)
	goalstop=goalstop~=false
	min=min or 1
	max=max or #g
	local sg=Group.CreateGroup()
	local fg=Duel.GrabSelectedCard()
	if #fg>max or min>max or #(g+fg)<min then return nil end
	if not check then
		for tc in aux.Next(fg) do
			fg:SelectUnselect(sg,tp,false,false,min,max)
		end
	end
	sg:Merge(fg)
	local mg,iisg,tmp,stop,iter,ctab,rtab,gtab
	--main check
	local finish=(#sg>=min and #sg<=max and f(sg,...))
	while #sg<max do
		mg=g-sg
		iisg=sg:Clone()
		if passf then
			aux.SubGroupCaptured=mg:Filter(passf,nil,sg,g)
		else
			aux.SubGroupCaptured=Group.CreateGroup()
		end
		ctab,rtab,gtab={},{},{1}
		for tc in aux.Next(mg) do
			ctab[#ctab+1]=tc
		end
		--high to low
		if sortf then
			for i=1,#ctab-1 do
				for j=1,#ctab-1-i do
					if sortf(ctab[j])<sortf(ctab[j+1]) then
						tmp=ctab[j]
						ctab[j]=ctab[j+1]
						ctab[j+1]=tmp
					end
				end
			end
		end
		--classify
		if classif then
			--make similar cards adjacent
			for i=1,#ctab-2 do
				for j=i+2,#ctab do
					if classif(ctab[i],ctab[j]) then
						tmp=ctab[j]
						ctab[j]=ctab[i+1]
						ctab[i+1]=tmp
					end
				end
			end
			--rtab[i]: what category does the i-th card belong to
			--gtab[i]: What is the first card's number in the i-th category
			for i=1,#ctab-1 do
				rtab[i]=#gtab
				if not classif(ctab[i],ctab[i+1]) then
					gtab[#gtab+1]=i+1
				end
			end
			rtab[#ctab]=#gtab
			--iter record all cards' number in sg
			iter={1}
			sg:AddCard(ctab[1])
			while #sg>#iisg and #aux.SubGroupCaptured<#mg do
				stop=#sg>=max
				--prune if too much cards
				if (aux.GCheckAdditional and not aux.GCheckAdditional(sg,c,g,f,min,max,...)) then
					stop=true
				--skip check if no new cards
				elseif #(sg-iisg-aux.SubGroupCaptured)>0 and #sg>=min and #sg<=max and f(sg,...) then
					for sc in aux.Next(sg-iisg) do
						if check then return true end
						aux.SubGroupCaptured:Merge(mg:Filter(classif,nil,sc))
					end
					stop=goalstop
				end
				local code=iter[#iter]
				--last card isn't in the last category
				if code and code<gtab[#gtab] then
					if stop then
						--backtrack and add 1 card from next category
						iter[#iter]=gtab[rtab[code]+1]
						sg:RemoveCard(ctab[code])
						sg:AddCard(ctab[(iter[#iter])])
					else
						--continue searching forward
						iter[#iter+1]=code+1
						sg:AddCard(ctab[code+1])
					end
				--last card is in the last category
				elseif code then
					if stop or code>=#ctab then
						--clear all cards in the last category
						while #iter>0 and iter[#iter]>=gtab[#gtab] do
							sg:RemoveCard(ctab[(iter[#iter])])
							iter[#iter]=nil
						end
						--backtrack and add 1 card from next category
						local code2=iter[#iter]
						if code2 then
							iter[#iter]=gtab[rtab[code2]+1]
							sg:RemoveCard(ctab[code2])
							sg:AddCard(ctab[(iter[#iter])])
						end
					else
						--continue searching forward
						iter[#iter+1]=code+1
						sg:AddCard(ctab[code+1])
					end
				end
			end
			if check then return false end
		--classification is essential for efficiency, and this part is only for backup
		else
			iter={1}
			sg:AddCard(ctab[1])
			while #sg>#iisg and #aux.SubGroupCaptured<#mg do
				stop=#sg>=max
				if (aux.GCheckAdditional and not aux.GCheckAdditional(sg,c,g,f,min,max,...)) then
					stop=true
				elseif #(sg-iisg-aux.SubGroupCaptured)>0 and #sg>=min and #sg<=max and f(sg,...) then
					for sc in aux.Next(sg-iisg) do
						if check then return true end
						aux.SubGroupCaptured:AddCard(sc) --Merge(mg:Filter(class,nil,sc))
					end
					stop=goalstop
				end
				local code=iter[#iter]
				if code<#ctab then
					if stop then
						iter[#iter]=nil
						sg:RemoveCard(ctab[code])
					end
					iter[#iter+1]=code+1
					sg:AddCard(ctab[code+1])
				else
					local code2=iter[#iter-1]
					iter[#iter]=nil
					sg:RemoveCard(ctab[code])
					if code2 and code2>0 then
						iter[#iter]=code2+1
						sg:RemoveCard(ctab[code2])
						sg:AddCard(ctab[code2+1])
					end
				end
			end
		end
		--finish searching
		sg=iisg
		local cg=aux.SubGroupCaptured:Clone()
		aux.SubGroupCaptured:Clear()
		cg:Sub(sg)
		--Debug.Message(cm[0])
		finish=(#sg>=min and #sg<=max and f(sg,...))
		if #cg==0 then break end
		local cancel=not finish and cancelable
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
end

--将不入连锁效果变为允许手动排序的状态
function cm.enableeffectsort(...)
	for _,e in pairs({...}) do
		local c=e:GetHandler()
		if not e:IsHasType(EFFECT_TYPE_CONTINUOUS) then return end
		local event=e:GetCode()
		if event==EVENT_FREE_CHAIN or event&EVENT_PHASE>0 then return end
		if e:IsHasProperty(EFFECT_FLAG_DELAY) then event=event+0x100000 end
		cm.continuoustab=cm.continuoustab or {}
		if not cm.continuoustab[event] then
			cm.continuoustab[event]={[0]={},[1]={}}
			local ec={
				EVENT_CHAIN_ACTIVATING,
				EVENT_CHAINING,
				EVENT_ATTACK_ANNOUNCE,
				EVENT_BREAK_EFFECT,
				EVENT_CHAIN_SOLVING,
				EVENT_CHAIN_SOLVED,
				EVENT_CHAIN_END,
				EVENT_SUMMON,
				EVENT_SPSUMMON,
				EVENT_MSET,
				EVENT_BATTLE_DESTROYED
			}
			for _,code in ipairs(ec) do
				if code~=event%0x100000 then
					local ge1=Effect.CreateEffect(c)
					ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					ge1:SetCode(code)
					ge1:SetOperation(function() cm.continuoustab[event]={[0]={},[1]={}} end)
					Duel.RegisterEffect(ge1,0)
				end
			end
		end
		local con=e:GetCondition() or aux.TRUE
		local op=e:GetOperation() or aux.TRUE
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
							local c=e:GetHandler()
							local p=c:GetControler()
							local res=con(e,tp,eg,ep,ev,re,r,rp)
							if res and not c:IsDisabled() then
								table.insert(cm.continuoustab[event][p],e)
							end
							return res
						end)
		e:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							local c=e:GetHandler()
							local p=c:GetControler()
							if cm.continuoustab[event]["resolving"] then
								op(e,tp,eg,ep,ev,re,r,rp)
								cm.continuoustab[event]["resolving"]=nil
								e:Reset()
							elseif cm.continuoustab[event]["sorting"] or #cm.continuoustab[event][p]>1 then
								cm.continuoustab[event]["sorting"]=#cm.continuoustab[event][p]>1
								local opt=1
								if cm.continuoustab[event]["sorting"] then
									local tab,tab2,tab3={},{},{}
									local g=Group.CreateGroup()
									for i,te in pairs(cm.continuoustab[event][p]) do
										g:AddCard(te:GetHandler())
										tab[i]=te:GetDescription()
										tab2[te:GetHandler()]=tab2[te:GetHandler()] or {}
										table.insert(tab2[te:GetHandler()],te:GetDescription())
										tab3[te:GetHandler()]=tab3[te:GetHandler()] or {}
										table.insert(tab3[te:GetHandler()],i)
									end
									Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(m,0))
									local tc=g:Select(p,1,1,nil):GetFirst()
									local s=1
									if #tab2[tc]>1 then s=1+Duel.SelectOption(p,table.unpack(tab2[tc])) end
									opt=tab3[tc][s]
								end
								local de=cm.continuoustab[event][p][opt]
								table.remove(cm.continuoustab[event][p],opt)
								if e==de then
									op(e,tp,eg,ep,ev,re,r,rp)
								else
									local ce=de:Clone()
									local fid=ce:GetFieldID()
									ce:SetCondition(aux.TRUE)
									ce:SetCode(EVENT_CUSTOM+m+event*0xffff+fid)
									Duel.RegisterEffect(ce,de:GetHandler():GetControler())
									cm.continuoustab[event]["resolving"]=true
									if not eg then
										Duel.RaiseEvent(de:GetHandler(),EVENT_CUSTOM+m+event*0xffff+fid,re,r,rp,ep,ev)
									else
										Duel.RaiseEvent(eg,EVENT_CUSTOM+m+event*0xffff+fid,re,r,rp,ep,ev)
									end
									cm.continuoustab[event]["resolving"]=nil
									ce:Reset()
								end
							else
								op(e,tp,eg,ep,ev,re,r,rp)
							end
						end)
	end
end 

--card,zone,(p,loc,seq),(x,y)的转换.x为纵列号,y为横行号.

--(p,loc,seq)->从tp来看的zone.11451494.
function cm.getzone(p,loc,seq,tp)
	local zone=1<<seq
	if loc&LOCATION_SZONE~=0 then zone=zone<<8 end
	if p~=tp then zone=zone<<16 end
	if zone==0x20 or zone==0x400000 then zone=0x400020 end
	if zone==0x40 or zone==0x200000 then zone=0x200040 end
	return zone
end
--card->从tp来看的zone.11451584.
function cm.getzone(c,tp)
	local p=c:GetControler()
	local loc=c:GetLocation()
	local seq=c:GetSequence()
	local zone=1<<seq
	if loc&LOCATION_SZONE~=0 then zone=zone<<8 end
	if p~=tp then zone=zone<<16 end
	if zone==0x20 or zone==0x400000 then zone=0x400020 end
	if zone==0x40 or zone==0x200000 then zone=0x200040 end
	return zone
end
--从tp来看的zone->card.11451566.
function cm.GetCardsInZone(tp,fd)
	if fd==0x400020 then return Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if fd==0x200040 then return Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
	local seq=math.log(fd,2)
	local p=tp
	if seq>=16 then
		p=1-tp
		seq=seq-16
	end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	return Duel.GetFieldCard(p,loc,math.floor(seq+0.5))
end
--card->从tp来看的(x,y).11451530.
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
--(x,y)->zone.11451650.
function cm.xytozone(x,y)
	if x==-1 and y==0.5 then return 1<<13
	elseif x==5 and y==3.5 then return 1<<29
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
--zone->(x,y).11451678.
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
	elseif seq==29 then return 5,3.5 end
	return nil
end

--几何关系

--从tp来看的ac,bc,cc,dc对角线交点的x,y.11451530.
function cm.intersection(ac,bc,cc,dc,tp)
	local ax,ay=cm.xylabel(ac,tp)
	local bx,by=cm.xylabel(bc,tp)
	local cx,cy=cm.xylabel(cc,tp)
	local dx,dy=cm.xylabel(dc,tp)
	local dr=(by-ay)*(dx-cx)-(ax-bx)*(cy-dy)
	if dr==0 then return -1,-1 end
	local x=((bx-ax)*(dx-cx)*(cy-ay)+(by-ay)*(dx-cx)*ax-(dy-cy)*(bx-ax)*cx)/dr
	local y=-((by-ay)*(dy-cy)*(cx-ax)+(bx-ax)*(dy-cy)*ay-(dx-cx)*(by-ay)*cy)/dr
	return x,y
end
--以tc为中心的十字4格.11451562.
function cm.seqfilter(c,tc,tp)
	local x1,y1=cm.xylabel(c,tp)
	local x2,y2=cm.xylabel(tc,tp)
	return (x1==x2 and math.abs(y1-y2)==1) or (y1==y2 and math.abs(x1-x2)==1)
end
--方向向量(x,y)的斜率（旧）.11451575.
function cm.gradient(y,x)
	if y>0 and x==0 then return 100 end
	if y<0 and x==0 then return 110 end
	if y>0 and x~=0 then return y/x end
	if y<0 and x~=0 then return y/x+10 end
	if y==0 and x>0 then return 0 end
	if y==0 and x<0 then return 10 end
	return 1000
end
--直线(x,y)的斜率（旧）.11451712.
function cm.gradient(y,x)
	if y~=0 and x==0 then return 100 end
	if y~=0 and x~=0 then return y/x end
	if y==0 and x~=0 then return 0 end
	return 1000
end
--方向向量(x,y)的斜率，用极角表示.11451575.
function cm.gradient(y,x)
	if y>0 and x==0 then return math.pi/2 end
	if y<0 and x==0 then return math.pi*3/2 end
	if y>=0 and x>0 then return math.atan(y/x) end
	if x<0 then return math.pi+math.atan(y/x) end
	if y<0 and x>0 then return 2*math.pi+math.atan(y/x) end
	return 1000
end
--直线(x,y)的斜率，用极角表示.11451712.
function cm.gradient(y,x)
	if y~=0 and x==0 then return math.pi/2 end
	if x*y>=0 and x~=0 then return math.atan(y/x) end
	if x*y<0 and x~=0 then return math.pi+math.atan(y/x) end
	return 1000
end
--判断(x1,y1)->(x2,y2)的射线斜率是否为k.11451575.
function cm.fieldline(x1,y1,x2,y2,...)
	for _,k in pairs({...}) do
		if cm.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
--判断连接怪兽lc在tp来看、tgp场上的(x0,y0)出场是否会让c在其连接方向上.11451575.
function cm.willbelinkdir(c,lc,x0,y0,tp,tgp)
	if tp~=tgp then x0,y0=4-x0,4-y0 end
	local x,y=cm.xylabel(c,tgp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
	end
	return false
end
--判断tp来看的(x,y)是否在连接怪兽lc的连接方向上.11451575.
function cm.islinkdir(lc,x,y,tp)
	if lc:IsControler(1-tp) then x,y=4-x,4-y end
	local x0,y0=cm.xylabel(lc,lc:GetControler())
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
	end
	return false
end
--判断连接怪兽lc在tp来看、tgp场上的(x0,y0)出场是否会和连接怪兽c互相连接.11451575.
function cm.willbemutuallinked(c,lc,x0,y0,tp,tgp)
	if tp~=tgp then x0,y0=4-x0,4-y0 end
	local x,y=cm.xylabel(c,tgp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	local ct=c:IsControler(tgp)
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,tgp,list[i+1]*math.pi) and math.abs(x0-x)<=1 and math.abs(y0-y)<=1 and ((c:IsLinkMarker(1<<(8-i)) and ct) or (c:IsLinkMarker(1<<i) and not ct)) then return true end
	end
	return false
end
--判断tp来看的(x,y)是否在lc的8个方向上，返回方向序号.i号方向是指连接标记(1<<i)所指向的方向.11451649.
function cm.isdir(lc,x,y,tp)
	local x0,y0=cm.xylabel(lc,tp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if cm.fieldline(x0,y0,x,y,tp,list[i+1]*math.pi) then return true,i end
	end
	return false,nil
end
--返回c和lc的直线斜率.11451712.
function cm.direction(c,lc,tp)
	local x1,y1=cm.xylabel(c,tp)
	local x2,y2=cm.xylabel(lc,tp)
	return cm.gradient(y2-y1,x2-x1)
end
--判断g是否全部在过c的同一直线上.11451712.
function cm.fselect(g,c)
	local tc=g:GetFirst()
	if not tc then return false end
	local i=1
	if tc==c then
		i=i+1
		tc=g:GetNext()
	end
	if not tc then return true end
	local dir=cm.direction(tc,c,0)
	while i<#g do
		i=i+1
		tc=g:GetNext()
		if tc~=c and dir~=cm.direction(tc,c,0) then return false end
	end
	return true
end
--返回连接怪兽lc的连接方向上的tp来看的loc区域，exlcheck则在tp使用一个ex区时不返回另一个ex区.11451650.
function cm.getlinkdirzone(lc,tp,...)
	local loc,exlcheck,p=table.unpack({...})
	local x0,y0=cm.xylabel(lc,lc:GetControler())
	local res=0
	for x=0,4 do
		for y=0,4 do
			local zone=cm.xytozone(x,y)
			if zone and cm.islinkdir(lc,x,y,tp) then res=zone|res end
		end
	end
	if loc and loc==LOCATION_MZONE then res=res&0xff00ff end
	if loc and loc==LOCATION_SZONE then res=res&0xff00ff00 end
	if exlcheck then
		if (Duel.GetFieldCard(p,LOCATION_MZONE,5)~=nil and p==tp) or (Duel.GetFieldCard(p,LOCATION_MZONE,6)~=nil and p~=tp) then res=res&(~0x200040) end
		if (Duel.GetFieldCard(p,LOCATION_MZONE,6)~=nil and p==tp) or (Duel.GetFieldCard(p,LOCATION_MZONE,5)~=nil and p~=tp) then res=res&(~0x400020) end
	end
	return res
end