--血雳强袭队·紫云英
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetHintTiming(TIMING_END_PHASE+TIMING_BATTLE_END+TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.scon)
	e1:SetTarget(cm.stg)
	e1:SetOperation(cm.sop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+6)
	e2:SetCondition(cm.mcon)
	e2:SetTarget(cm.mtg)
	e2:SetOperation(cm.mop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function cm.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
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
function cm.fieldline(x1,y1,x2,y2,...)
	for _,k in pairs({...}) do
		if cm.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
function cm.isdir(c,x1,y1,tp,...)
	local x2,y2=cm.xylabel(c,tp)
	for _,k in pairs({...}) do
		if cm.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
function cm.willbealllinkdir(lc,x0,y0,tp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if lc:IsLinkMarker(1<<i) and not Duel.IsExistingMatchingCard(cm.isdir,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,x0,y0,tp,list[i+1]*math.pi) then return false end
	end
	return true
end
function cm.islinkdirstate(c)
	local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_LINK)
	local g0=g:Filter(Card.IsControler,nil,0)
	local g1=g:Filter(Card.IsControler,nil,1)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for lc in aux.Next(g0) do
		local x0,y0=cm.xylabel(lc,0)
		local x,y=cm.xylabel(c,0)
		for i=0,8 do
			if lc:IsLinkMarker(1<<i) and cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
		end
	end
	for lc in aux.Next(g1) do
		local x1,y1=cm.xylabel(lc,1)
		local x,y=cm.xylabel(c,1)
		for i=0,8 do
			if lc:IsLinkMarker(1<<i) and cm.fieldline(x1,y1,x,y,list[i+1]*math.pi) then return true end
		end
	end
	return false
end
function cm.willbelinkdir(c,x0,y0,tp)
	local x,y=cm.xylabel(c,tp)
	local list={5/4,3/2,7/4,1,1000,0,3/4,1/2,1/4}
	for i=0,8 do
		if cm.fieldline(x0,y0,x,y,list[i+1]*math.pi) then return true end
	end
	return false
end
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.get_zone(c,tp)
	local zone=0
	for x=0,4 do
		if cm.willbealllinkdir(c,x,1,tp) then zone=zone|(1<<x) end
	end
	if cm.willbealllinkdir(c,1,2,tp) then zone=zone|0x20 end
	if cm.willbealllinkdir(c,3,2,tp) then zone=zone|0x40 end
	return zone
end
function cm.spfilter(c,e,tp)
	local zone=cm.get_zone(c,tp)
	return zone~=0 and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,seq)
	local tc=g:GetFirst()
	if not tc then return end
	local zone=cm.get_zone(tc,tp)
	if zone~=0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)>0 and c:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		--aclimit
		local ge0=Effect.CreateEffect(tc)
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetRange(LOCATION_MZONE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(cm.actarget1)
		ge0:SetOperation(cm.costop1)
		ge0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(ge0,true)
	end
end
function cm.actarget1(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	local res=false
	local tab=getmetatable(te:GetHandler())
	for _,f in pairs(tab) do
		if f and f==op then res=true end
	end
	if res then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,1)
		e1:SetValue(cm.aclimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
end
function cm.aclimit(e,te,tp)
	if te:GetHandler()~=e:GetHandler() then return false end
	local op=te:GetOperation()
	local res=false
	local tab=getmetatable(te:GetHandler())
	for _,f in pairs(tab) do
		if f and f==op then res=true end
	end
	return res
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function cm.mcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.nfilter(c,lc,tp,bool)
	if not c:IsFaceup() then return false,false end
	if cm.islinkdirstate(c) then return true,true end
	if not bool then return false,false end
	local seq=lc:GetSequence()
	local b1=seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)
	local b2=seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
	local b3=(seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
	local b4=(seq==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5)) or (seq==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6))
	local x0,y0=cm.xylabel(lc,0)
	if (b1 and cm.willbelinkdir(c,x0-1,y0,tp)) or (b2 and cm.willbelinkdir(c,x0+1,y0,tp)) or (b3 and cm.willbelinkdir(c,x0,y0-1,tp)) or (b4 and cm.willbelinkdir(c,x0,y0+1,tp)) then return true,false end
	return false,false
end
function cm.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local b1=seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)
	local b2=seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
	local b3=(seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
	local b4=(seq==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5)) or (seq==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6))
	local g=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp,false)
	local typ=0
	for fc in aux.Next(g) do
		typ=typ|bit.band(fc:GetType(),0x7)
	end
	local ct=0
	for i=0,2 do if typ&(1<<i)>0 then ct=ct+1 end end
	local q1=#g>0 and Duel.IsPlayerCanDraw(tp,ct)
	if chk==0 then return (b1 or b2 or b3 or b4) or q1 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bool=c:IsRelateToEffect(e) --and c:IsControler(tp) and c:IsFaceup()
	local seq=c:GetSequence()
	local b1=seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)
	local b2=seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
	local b3=(seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
	local b4=(seq==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5)) or (seq==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6))
	local q2=bool and (b1 or b2 or b3 or b4)
	local g=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp,false)
	local typ=0
	for fc in aux.Next(g) do
		typ=typ|bit.band(fc:GetType(),0x7)
	end
	local ct=0
	for i=0,2 do if typ&(1<<i)>0 then ct=ct+1 end end
	local q1=#g>0 and Duel.IsPlayerCanDraw(tp,ct)
	if not q1 and not q2 then return end
	local opt=aux.SelectFromOptions(tp,{q1,aux.Stringid(m,1)},{q2,aux.Stringid(m,2)})
	if opt==1 then
		local d=Duel.Draw(tp,ct,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		Duel.DiscardHand(tp,nil,d-1,d-1,REASON_EFFECT+REASON_DISCARD)
		local bool=c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsFaceup()
		local seq=c:GetSequence()
		local b1=seq>0 and seq<5 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)
		local b2=seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)
		local b3=(seq==5 and Duel.CheckLocation(tp,LOCATION_MZONE,1)) or (seq==6 and Duel.CheckLocation(tp,LOCATION_MZONE,3))
		local b4=(seq==1 and Duel.CheckLocation(tp,LOCATION_MZONE,5)) or (seq==3 and Duel.CheckLocation(tp,LOCATION_MZONE,6))
		local q2=bool and (b1 or b2 or b3 or b4)
		if q2 then
			Duel.BreakEffect()
			local flag=0
			if b1 then flag=bit.replace(flag,0x1,seq-1) end
			if b2 then flag=bit.replace(flag,0x1,seq+1) end
			if b3 then if seq==5 then flag=flag|0x2 else flag=flag|0x8 end end
			if b4 then if seq==1 then flag=flag|0x20 else flag=flag|0x40 end end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
			local nseq=math.log(s&0xff,2)
			Duel.MoveSequence(c,nseq)
		end
	elseif opt==2 then
		local flag=0
		if b1 then flag=bit.replace(flag,0x1,seq-1) end
		if b2 then flag=bit.replace(flag,0x1,seq+1) end
		if b3 then if seq==5 then flag=flag|0x2 else flag=flag|0x8 end end
		if b4 then if seq==1 then flag=flag|0x20 else flag=flag|0x40 end end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
		local nseq=math.log(s&0xff,2)
		Duel.MoveSequence(c,nseq)
		local g=Duel.GetMatchingGroup(cm.nfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp,false)
		local typ=0
		for fc in aux.Next(g) do
			typ=typ|bit.band(fc:GetType(),0x7)
		end
		local ct=0
		for i=0,2 do if typ&(1<<i)>0 then ct=ct+1 end end
		local q1=#g>0 and Duel.IsPlayerCanDraw(tp,ct)
		if q1 then
			Duel.BreakEffect()
			local d=Duel.Draw(tp,ct,REASON_EFFECT)
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,nil,d-1,d-1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end